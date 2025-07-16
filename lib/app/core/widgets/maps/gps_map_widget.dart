import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:presensi_school/app/core/widgets/maps/location_service.dart';
import 'package:presensi_school/app/data/models/school_model.dart';
import 'package:presensi_school/app/data/repository/school_repository.dart';

class MapWidget extends StatefulWidget {
  final Function(LatLng, bool) onLocationFetched;

  const MapWidget({Key? key, required this.onLocationFetched})
    : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  LatLng? currentLocation;
  LatLng? schoolLocation;
  final double radiusInMeters = 700;
  bool isWithinRadius = false;
  final MapController mapController = MapController();

  final schoolRepo = Get.find<SchoolRepository>();

  @override
  void initState() {
    super.initState();
    _loadSchoolLocation();
  }

  Future<void> _loadSchoolLocation() async {
    try {
      // Asumsikan hanya ada 1 sekolah (ambil pertama)
      final allSchools = await schoolRepo.getAllSchools();
      if (allSchools.isEmpty || allSchools.first.location.isEmpty) {
        throw 'Tidak ada data sekolah atau lokasi kosong';
      }

      final school = allSchools.first;
      final coords = school.location.split(',');
      if (coords.length != 2) throw 'Format lokasi sekolah tidak valid';

      final lat = double.parse(coords[0]);
      final lng = double.parse(coords[1]);
      schoolLocation = LatLng(lat, lng);

      await _getUserLocation(); // lanjut ambil lokasi user
    } catch (e) {
      debugPrint('Gagal mendapatkan lokasi sekolah: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal mendapatkan lokasi sekolah")),
        );
      }
    }
  }

  Future<void> _getUserLocation() async {
    try {
      final locationService = LocationService();
      final position = await locationService.getCurrentLocation(context);
      final userLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        currentLocation = userLocation;
        final double distanceToSchool = calculateDistance(
          userLocation.latitude,
          userLocation.longitude,
          schoolLocation!.latitude,
          schoolLocation!.longitude,
        );
        isWithinRadius = distanceToSchool <= radiusInMeters;
      });

      widget.onLocationFetched(userLocation, isWithinRadius);
    } catch (e) {
      debugPrint('Error fetching user location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentLocation == null || schoolLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: currentLocation!,
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.presensi_school',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 40,
                    height: 40,
                    point: currentLocation!,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                  Marker(
                    width: 40,
                    height: 40,
                    point: schoolLocation!,
                    child: const Icon(
                      Icons.school,
                      color: Colors.blue,
                      size: 40,
                    ),
                  ),
                ],
              ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: schoolLocation!,
                    radius: radiusInMeters,
                    useRadiusInMeter: true,
                    color: Colors.blue.withOpacity(0.2),
                    borderColor: Colors.blue,
                    borderStrokeWidth: 2,
                  ),
                ],
              ),
            ],
          ),
        ),
        isWithinRadius
            ? Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                "Anda berada di dalam radius sekolah.",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            )
            : contentNotInRadius(),
      ],
    );
  }

  Widget contentNotInRadius() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.red),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.red,
            ),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Anda berada di luar lokasi area sekolah. Silakan menuju lokasi sekolah untuk menggunakan fitur ini.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// Fungsi Haversine
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371000;
  double dLat = degToRad(lat2 - lat1);
  double dLon = degToRad(lon2 - lon1);
  double a =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(degToRad(lat1)) * cos(degToRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadius * c;
}

double degToRad(double deg) => deg * (pi / 180);
