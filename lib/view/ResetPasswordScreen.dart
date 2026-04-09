import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../core/theme/app_colors.dart';
import '../routes/app_routes.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "إعادة تعيين",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.tealGradientEnd,
              ),
            ),
            const Text(
              "كلمة المرور",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 40),

            const Text(
              "أدخل الرمز المستلم:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),

            // حقول الـ OTP مع تأثير الهالة (Glow Effect)
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                      (index) => _buildModernOTPBox(context, index, authController),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // حقل كلمة المرور الجديدة
            CustomTextField(
              label: "كلمة المرور الجديدة",
              hint: "أدخل كلمة المرور الجديدة",
              isPassword: true,
              controller: authController.newPasswordController,
              prefixIcon: Icons.lock_open_rounded,
            ),
            const SizedBox(height: 12),

            // تلميح قوة كلمة المرور
            Row(
              children: [
                const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  "يجب أن تحتوي على رموز وأرقام لضمان الأمان",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // حقل تأكيد كلمة المرور
            CustomTextField(
              label: "تأكيد كلمة المرور",
              hint: "أعد كتابة كلمة المرور",
              isPassword: true,
              controller: authController.confirmNewPasswordController,
              prefixIcon: Icons.verified_user_outlined,
            ),

            const SizedBox(height: 50),

            // زر التحديث النهائي
            Obx(() => PrimaryButton(
              text: "تحديث وحفظ",
              isLoading: authController.isLoading.value,
              onPressed: () => authController.resetPassword(),
            )),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ويدجت مربع الـ OTP مع تصميم الهالة (Glow Effect)
  Widget _buildModernOTPBox(BuildContext context, int index, AuthController controller) {
    return Container(
      width: 48,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        // تأثير الهالة والظل
        boxShadow: [
          // ظل طبيعي لإبراز المربع
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          // هالة بلون الأكسينت (Accent Glow)
          BoxShadow(
            color: AppColors.accent.withOpacity(0.2), // شفافية ناعمة للهالة
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
        // إطار رقيق بلون الأكسينت لزيادة الأناقة
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        cursorColor: AppColors.accent,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.accent, // لون النص يطابق الهالة
        ),
        onChanged: (value) {
          controller.updateOTP(index, value);
          // الانتقال التلقائي بين المربعات
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
        decoration: const InputDecoration(
          counterText: "",
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}