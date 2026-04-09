import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  // ---------------------------------------------------------------------------
  // 1. المتغيرات والـ Controllers (Variables & Text Controllers)
  // ---------------------------------------------------------------------------
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var userType = 'client'.obs; // 'client' or 'provider'
  var otpValues = List.filled(6, "").obs;

  // الحقول الأساسية
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // حقول استعادة كلمة المرور
  final forgotEmailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  // حقل الـ OTP (اختياري إذا كنتِ تستخدمين القائمة)
  final otpController = TextEditingController();

  // ---------------------------------------------------------------------------
  // 2. دوال تسجيل الدخول وإنشاء الحساب (Auth Logic)
  // ---------------------------------------------------------------------------

  /// دالة تسجيل الدخول
  void login() async {
    if (!_validateLogin()) return;

    isLoading.value = true;
    try {
      // محاكاة طلب الشبكة (API لاحقاً)
      await Future.delayed(const Duration(seconds: 2));
      // Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      // التعامل مع الأخطاء
    } finally {
      isLoading.value = false;
    }
  }

  /// دالة إنشاء حساب جديد
  void register() async {
    if (!_validateRegister()) return;

    Map<String, dynamic> body = {
      "name": nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "password_confirmation": confirmPasswordController.text,
      "role": userType.value,
    };

    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 2));
      Get.toNamed(AppRoutes.verification);
    } catch (e) {
      // التعامل مع الأخطاء
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // 3. دوال التحقق من البريد (Email Verification - OTP)
  // ---------------------------------------------------------------------------

  /// تحديث رقم معين في قائمة الـ OTP
  void updateOTP(int index, String value) {
    otpValues[index] = value;
  }

  /// إرسال الرمز للتحقق من الإيميل
  void verifyOTP() async {
    String fullOTP = otpValues.join();
    if (fullOTP.length < 6) {
      Get.snackbar("خطأ", "أكمل الرمز أولاً");
      return;
    }

    isLoading.value = true;
    try {
      print("جاري التحقق من الرمز: $fullOTP");
      // الربط مع API: (email, code)
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // 4. دوال استعادة كلمة المرور (Forgot & Reset Password)
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // 5. دوال مساعدة (Helper & UI Functions)
  // ---------------------------------------------------------------------------

  /// تغيير نوع الحساب
  void setUserType(String type) => userType.value = type;

  /// تبديل رؤية كلمة المرور
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // ---------------------------------------------------------------------------
  // 6. التحقق من صحة البيانات (Validation Logic)
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // 7. دورة الحياة (Lifecycle)
  // ---------------------------------------------------------------------------
/*
  @override
  void onClose() {
    // إغلاق جميع الـ Controllers لتوفير الذاكرة
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    forgotEmailController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    otpController.dispose();
    super.onClose();
  }*/
}