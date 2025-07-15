import 'package:get/get.dart';
import 'package:presensi_school/app/data/models/school_model.dart';
import 'package:presensi_school/app/data/repository/school_repository.dart';
import 'package:flutter/material.dart';

class SchoolController extends GetxController {
  final repository = Get.find<SchoolRepository>();

  var schools = <School>[].obs;
  var selectedSchool = Rxn<School>();
  var isLoading = false.obs;
  var error = ''.obs;

  final locationController = TextEditingController();
  final inTimeController = TextEditingController();
  final outTimeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchSchools();
  }

  Future<void> fetchSchools() async {
    isLoading.value = true;
    error.value = '';
    try {
      final data = await repository.getAllSchools();
      schools.assignAll(data);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void selectSchool(School school) {
    selectedSchool.value = school;
    locationController.text = school.location;
    inTimeController.text = school.inTime;
    outTimeController.text = school.outTime;
  }

  void clearForm() {
    selectedSchool.value = null;
    locationController.clear();
    inTimeController.clear();
    outTimeController.clear();
  }

  Future<void> createSchool() async {
    isLoading.value = true;
    error.value = '';
    try {
      await repository.createSchool(
        location: locationController.text,
        inTime: inTimeController.text,
        outTime: outTimeController.text,
      );
      await fetchSchools();
      clearForm();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSchool() async {
    if (selectedSchool.value == null) return;
    isLoading.value = true;
    error.value = '';
    try {
      await repository.updateSchool(
        idSekolah: selectedSchool.value!.idSekolah,
        location: locationController.text,
        inTime: inTimeController.text,
        outTime: outTimeController.text,
      );
      await fetchSchools();
      clearForm();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteSchool(String id) async {
    isLoading.value = true;
    error.value = '';
    try {
      await repository.deleteSchool(idSekolah: id);
      await fetchSchools();
      clearForm();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    locationController.dispose();
    inTimeController.dispose();
    outTimeController.dispose();
    super.onClose();
  }
}
