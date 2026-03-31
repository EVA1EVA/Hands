import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../core/theme/app_colors.dart';
import '../widgets/primary_button.dart';
import '../widgets/wave_clipper.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. التموج العلوي الموحد للهوية
          Positioned(
            top: 0, left: 0, right: 0,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.tealGradientStart, AppColors.tealGradientEnd],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.mark_email_read_outlined, size: 80, color: Colors.white),
                ),
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: 20, right: 20, bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "Verification Code",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Please enter the 4-digit code sent to your email address",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // حقول إدخال الرمز (OTP Fields)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) => _buildOTPBox(context, index)),
                  ),

                  const SizedBox(height: 40),

                  Obx(() => PrimaryButton(
                    text: "Verify Now",
                    isLoading: authController.isLoading.value,
                    onPressed: () => authController.verifyOTP(),
                  )),

                  const SizedBox(height: 25),

                  // إعادة إرسال الرمز مع استخدام الـ Accent لكسر الكآبة
                  TextButton(
                    onPressed: () {
                      // منطق إعادة الإرسال
                    },
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        children: [
                          TextSpan(text: "Didn't receive a code? "),
                          TextSpan(
                            text: "Resend",
                            style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // بناء مربعات الرمز الفردية
  Widget _buildOTPBox(BuildContext context, int index) {
    return Container(
      width: 60,
      height: 65,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: TextField(
        onChanged: (value) {
          if (value.length == 1 && index < 3) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.accent),
        decoration: const InputDecoration(
          counterText: "",
          border: InputBorder.none,
        ),
      ),
    );
  }
}