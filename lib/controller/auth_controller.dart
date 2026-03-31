import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var userType = 'client'.obs;

  final otpController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void login() async {
    if (!_validateLogin()) return;

    isLoading.value = true;
    try {
      // محاكاة طلب الشبكة (سيتم ربط الـ API هنا لاحقاً)
      await Future.delayed(const Duration(seconds: 2));

      _showSnackBar("نجاح", "تم تسجيل الدخول بنجاح", isError: false);

      // Get.offAllNamed(AppRoutes.home); // الانتقال للرئيسية
    } catch (e) {
      _showSnackBar("خطأ", "فشل الاتصال بالسيرفر");
    } finally {
      isLoading.value = false;
    }
  }

  /// دالة إنشاء حساب جديد (Register)
  void register() async {
    if (!_validateRegister()) return;

    isLoading.value = true;
    try {
      // محاكاة إرسال البيانات للسيرفر مع نوع الحساب المختبر (userType.value)
      await Future.delayed(const Duration(seconds: 2));
      Get.toNamed(AppRoutes.verification);
      _showSnackBar("تنبيه", "تم إرسال رمز التحقق لبريدك", isError: false);
      // Get.back(); // العودة للـ Login بعد النجاح
    } catch (e) {
      _showSnackBar("خطأ", "حدث خطأ أثناء إنشاء الحساب");
    } finally {
      isLoading.value = false;
    }
  }

  /// تغيير نوع الحساب (Toggle logic)
  void setUserType(String type) => userType.value = type;

  /// التحقق من مدخلات تسجيل الدخول
  bool _validateLogin() {
    if (!GetUtils.isEmail(emailController.text.trim())) {
      _showSnackBar("تنبيه", "يرجى إدخال بريد إلكتروني صالح");
      return false;
    }
    if (passwordController.text.length < 8) {
      _showSnackBar("تنبيه", "كلمة المرور يجب أن تكون 8 محارف على الأقل");
      return false;
    }
    return true;
  }

  /// التحقق الشامل لإنشاء الحساب (إضافة تأكيد كلمة المرور)
  bool _validateRegister() {
    if (nameController.text.trim().isEmpty) {
      _showSnackBar("تنبيه", "يرجى إدخال اسمك الكامل");
      return false;
    }
    // التأكد من تطابق كلمة المرور مع التأكيد
    if (passwordController.text != confirmPasswordController.text) {
      _showSnackBar("تنبيه", "كلمات المرور غير متطابقة، يرجى التأكد");
      return false;
    }
    // استدعاء فحص البريد وكلمة المرور الأساسي
    return _validateLogin();
  }

  /// تبديل رؤية كلمة المرور
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void verifyOTP() async {
    if (otpController.text.length < 4) {
      _showSnackBar("تنبيه", "يرجى إدخال الرمز كاملاً");
      return;
    }

    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 2));
      _showSnackBar("تم بنجاح", "تم تفعيل حسابك، أهلاً بك في Hands!", isError: false);
      // Get.offAllNamed(AppRoutes.home);
    } finally {
      isLoading.value = false;
    }
  }
  void _showSnackBar(String title, String message, {bool isError = true}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? AppColors.error.withOpacity(0.8) : AppColors.textPrimary,
      colorText: Colors.white,
      margin: const EdgeInsets.all(15),
      borderRadius: 10,
      duration: const Duration(seconds: 3),
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: Colors.white,
      ),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}