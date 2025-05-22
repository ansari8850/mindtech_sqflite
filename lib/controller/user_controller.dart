import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindtech_task/helper/database_helper.dart';
import 'package:mindtech_task/model/user_model.dart';

class UserController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final dobController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var users = <UserModel>[].obs;
  var selectedDate = DateTime.now().obs;
  var isLoading = false.obs;

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  void onInit() {
    super.onInit();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    try {
      log('Initializing database...');
      await _databaseHelper.getDatabaseInfo();
      await loadUsers();
      log('Database initialization completed');
    } catch (e) {
      log('Database initialization error: $e');
      Get.snackbar('Database Error', 'Failed to initialize database: $e');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    dobController.dispose();
    super.onClose();
  }

  Future<void> loadUsers() async {
    try {
      isLoading.value = true;
      log('Loading users from database...');
      final userList = await _databaseHelper.getAllUsers();
      users.assignAll(userList);

      log('Loaded ${userList.length} users successfully');
    } catch (e) {
      log('Error loading users: $e');
      Get.snackbar('Error', 'Failed to load users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addUser() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (!isAgeValid()) {
      Get.snackbar('Invalid Age', 'Age must be 20 or above');
      return;
    }

    try {
      isLoading.value = true;

      final user = UserModel(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        mobileNumber: mobileController.text.trim(),
        dateOfBirth: dobController.text.trim(),
      );

      log('Adding user: ${user.toString()}');
      await _databaseHelper.insertUser(user);
      await loadUsers();
      clearForm();
      Get.snackbar('Success', 'User added successfully');
    } catch (e) {
      log('Error adding user: $e');
      Get.snackbar('Error', 'Failed to add user: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      isLoading.value = true;
      await _databaseHelper.updateUser(user);
      await loadUsers();
      Get.snackbar('Success', 'User updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update user: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      isLoading.value = true;
      await _databaseHelper.deleteUser(id);
      await loadUsers();
      Get.snackbar('Success', 'User deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete user: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void showDeleteConfirmation(UserModel user) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              deleteUser(user.id!);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      dobController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  bool isAgeValid() {
    if (dobController.text.isEmpty) return false;

    try {
      final dob = DateFormat('dd/MM/yyyy').parse(dobController.text);
      final today = DateTime.now();
      final age = today.year - dob.year;
      if (today.month < dob.month ||
          (today.month == dob.month && today.day < dob.day)) {
        return age - 1 >= 20;
      }
      return age >= 20;
    } catch (e) {
      return false;
    }
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }
    if (!GetUtils.isPhoneNumber(value.trim())) {
      return 'Enter a valid mobile number';
    }
    if (value.trim().length < 10) {
      return 'Mobile number must be at least 10 digits';
    }
    return null;
  }

  String? validateDOB(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Date of birth is required';
    }
    if (!isAgeValid()) {
      return 'Age must be 20 or above';
    }
    return null;
  }

  void clearForm() {
    nameController.clear();
    emailController.clear();
    mobileController.clear();
    dobController.clear();
    selectedDate.value = DateTime.now();
  }

  void fillFormForEdit(UserModel user) {
    nameController.text = user.name;
    emailController.text = user.email;
    mobileController.text = user.mobileNumber;
    dobController.text = user.dateOfBirth;

    try {
      selectedDate.value = DateFormat('dd/MM/yyyy').parse(user.dateOfBirth);
    } catch (e) {
      selectedDate.value = DateTime.now();
    }
  }
}
