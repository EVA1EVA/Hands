
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

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
        iconTheme: const IconThemeData(color: AppColors.primaryGradientStart),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          // الفقاعات الخلفية للتناسق
          Positioned(
            top: -30,
            right: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.tealGradientStart.withOpacity(0.1),
              ),
            ),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "إعادة تعيين",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGradientStart, // توحيد اللون للبنفسجي
                  ),
                ),
                const Text(
                  "كلمة المرور",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 40),

                const Text(
                  "أدخل الرمز المستلم (OTP):",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),

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

                CustomTextField(
                  label: "كلمة المرور الجديدة",
                  hint: "أدخل كلمة مرور قوية",
                  isPassword: true,
                  iconColor: AppColors.accent,
                  controller: authController.newPasswordController,
                  prefixIcon: Icons.lock_open_rounded,
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 16, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      "استخدم مزيجاً من الحروف والأرقام",
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                CustomTextField(
                  label: "تأكيد كلمة المرور",
                  hint: "أعد كتابة كلمة المرور",
                  isPassword: true,
                  iconColor: AppColors.accent,
                  controller: authController.confirmNewPasswordController,
                  prefixIcon: Icons.verified_user_outlined,
                ),

                const SizedBox(height: 50),

                Obx(() => PrimaryButton(
                  text: "تحديث وحفظ",
                  isLoading: authController.isLoading.value,
                  onPressed: () => authController.resetPassword(),
                )),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernOTPBox(BuildContext context, int index, AuthController controller) {
    return Container(
      width: 45,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.15),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
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
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.accent,
        ),
        onChanged: (value) {
          controller.updateOTP(index, value);
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