// To parse this JSON data, do
//
//     final presensi = presensiFromJson(jsonString);

import 'dart:convert';

Presensi presensiFromJson(String str) => Presensi.fromJson(json.decode(str));

String presensiToJson(Presensi data) => json.encode(data.toJson());

class Presensi {
    String? idPresensi;
    String? inLocation;
    String? inTime;
    String? inStatus;
    String? inKeterangan;
    String? outLocation;
    String? outTime;
    String? outStatus;
    String? outKeterangan;
    String? staffId;
    String? sekolahId;
    String? createdAt;
    String? updatedAt;
    Sekolah? sekolah;

    Presensi({
        this.idPresensi,
        this.inLocation,
        this.inTime,
        this.inStatus,
        this.inKeterangan,
        this.outLocation,
        this.outTime,
        this.outStatus,
        this.outKeterangan,
        this.staffId,
        this.sekolahId,
        this.createdAt,
        this.updatedAt,
        this.sekolah,
    });

    factory Presensi.fromJson(Map<String, dynamic> json) => Presensi(
        idPresensi: json["idPresensi"],
        inLocation: json["inLocation"],
        inTime: json["inTime"],
        inStatus: json["inStatus"],
        inKeterangan: json["inKeterangan"],
        outLocation: json["outLocation"],
        outTime: json["outTime"],
        outStatus: json["outStatus"],
        outKeterangan: json["outKeterangan"],
        staffId: json["staff_id"],
        sekolahId: json["sekolah_id"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        sekolah: json["sekolah"] == null ? null : Sekolah.fromJson(json["sekolah"]),
    );

    Map<String, dynamic> toJson() => {
        "idPresensi": idPresensi,
        "inLocation": inLocation,
        "inTime": inTime,
        "inStatus": inStatus,
        "inKeterangan": inKeterangan,
        "outLocation": outLocation,
        "outTime": outTime,
        "outStatus": outStatus,
        "outKeterangan": outKeterangan,
        "staff_id": staffId,
        "sekolah_id": sekolahId,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "sekolah": sekolah?.toJson(),
    };
}

class Sekolah {
    String? location;
    String? inTime;
    String? outTime;

    Sekolah({
        this.location,
        this.inTime,
        this.outTime,
    });

    factory Sekolah.fromJson(Map<String, dynamic> json) => Sekolah(
        location: json["location"],
        inTime: json["inTime"],
        outTime: json["outTime"],
    );

    Map<String, dynamic> toJson() => {
        "location": location,
        "inTime": inTime,
        "outTime": outTime,
    };
}
