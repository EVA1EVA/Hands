import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../routes/app_routes.dart';
import 'package:http/http.dart' as http;
class AuthController extends GetxController {
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var userType = 'user'.obs;
  var otpValues = List.filled(6, "").obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final forgotEmailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();
  final otpController = TextEditingController();


  /// دالة تسجيل الدخول
  void login() async {
    if (!_validateLogin()) return;

    isLoading.value = true;
    try {
      Map<String, dynamic> body = {
        "email": emailController.text.trim(),
        "password": passwordController.text,
      };

      final response = await ApiService.loginUser(body);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        String token = responseData['token'] ?? "";

        // نصيحة: خزنّي التوكن لاحقاً باستخدام GetStorage
        Get.snackbar("نجاح", "أهلاً بك مجدداً");

        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.snackbar("خطأ", responseData['message'] ?? "بيانات الدخول غير صحيحة");
      }
    } catch (e) {
      print("Login Error: $e");
      Get.snackbar("خطأ", "تعذر الاتصال بالسيرفر");
    } finally {
      isLoading.value = false;
    }
  }
  /// دالة إنشاء حساب جديد
  void register() async {
    if (!_validateRegister()) return;

    isLoading.value = true;
    try {
      Map<String, dynamic> body = {
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text,
        "password_confirmation": confirmPasswordController.text,
        "role": userType.value,
      };

      final response = await ApiService.registerUser(body);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar("نجاح", responseData['message'] ?? "تم إنشاء الحساب");
        Get.toNamed(AppRoutes.verification);
      } else {
        Get.snackbar("خطأ", responseData['message'] ?? "فشل التسجيل");
      }
    } catch (e) {
      Get.snackbar("خطأ", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void updateOTP(int index, String value) {
    otpValues[index] = value;
  }

  /// إرسال الرمز للتحقق من الإيميل

  void verifyOTP() async {
    String fullOTP = otpValues.join(); // تجميع الرمز 819003
    if (fullOTP.length < 6) {
      Get.snackbar("تنبيه", "يرجى إدخال الرمز كاملاً");
      return;
    }

    isLoading.value = true;
    try {
      Map<String, dynamic> body = {
        "email": emailController.text.trim(),
        "code": fullOTP,
      };

      final response = await ApiService.verifyEmail(body);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("نجاح", responseData['message'] ?? "تم تفعيل حسابك بنجاح");

        Get.offAllNamed(AppRoutes.login);
      } else {
        Get.snackbar("فشل التحقق", responseData['message'] ?? "الرمز غير صحيح");
      }
    } catch (e) {
      print("Verification Error: $e");
      Get.snackbar("خطأ", "تعذر الاتصال بالسيرفر");
    } finally {
      isLoading.value = false;
    }
  }



  //  دوال استعادة كلمة المرور

  /// طلب إرسال رمز استعادة كلمة المرور (إلى الإيميل)
  void sendPasswordResetCode() async {
    if (forgotEmailController.text.isEmpty) {
      Get.snackbar("خطأ", "يرجى إدخال البريد الإلكتروني");
      return;
    }
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 2));
      Get.toNamed(AppRoutes.resetPassword);
    } finally {
      isLoading.value = false;
    }
  }

  /// تعيين كلمة المرور الجديدة بعد إدخال الرمز
  void resetPassword() async {
    String code = otpValues.join();

    if (code.length < 6 || newPasswordController.text.isEmpty) {
      Get.snackbar("خطأ", "يرجى إكمال جميع البيانات");
      return;
    }

    isLoading.value = true;
    try {
      // الربط مع API: (email, code, password, password_confirmation)
      await Future.delayed(const Duration(seconds: 2));
      Get.offAllNamed(AppRoutes.login);
    } finally {
      isLoading.value = false;
    }
  }

  //5. دوال مساعدة

  /// تغيير نوع الحساب
  void setUserType(String type) => userType.value = type;

  /// تبديل رؤية كلمة المرور
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  bool _validateLogin() {
    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar("تنبيه", "البريد الإلكتروني غير صحيح");
      return false;
    }
    if (passwordController.text.length < 8) {
      Get.snackbar("تنبيه", "كلمة المرور قصيرة جداً");
      return false;
    }
    return true;
  }

  bool _validateRegister() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar("تنبيه", "الاسم مطلوب");
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar("تنبيه", "كلمات المرور غير متطابقة");
      return false;
    }
    return _validateLogin();
  }
}