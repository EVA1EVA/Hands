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
          // التموج العلوي (Wave)
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
                    "رمز التحقق",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "يرجى إدخال رمز التحقق المكون من 6 أرقام\nالمرسل إلى بريدك الإلكتروني",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 40),

                  // حقول إدخال الرمز (6 خانات) مع الهالة
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          6,
                              (index) => _buildGlowOTPBox(context, index, authController)
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // زر التحقق مع حالة التحميل
                  Obx(() => PrimaryButton(
                    text: "تحقق الآن",
                    isLoading: authController.isLoading.value,
                    onPressed: () => authController.verifyOTP(),
                  )),

                  const SizedBox(height: 25),

                  // زر إعادة الإرسال
                  TextButton(
                    onPressed: () {
                      // استدعاء دالة إعادة الإرسال من الـ controller
                    },
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        children: [
                          TextSpan(text: "لم يصلك الرمز؟ "),
                          TextSpan(
                            text: "إعادة إرسال",
                            style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
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

  // ويدجت مربع الـ OTP مع تأثير الهالة (Glow Effect)
  Widget _buildGlowOTPBox(BuildContext context, int index, AuthController controller) {
    return Container(
      width: 46,
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // إضافة الهالة والظل لتطابق شاشة إعادة التعيين
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.accent.withOpacity(0.15), // الهالة الملونة
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 1.2,
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
            color: AppColors.accent
        ),
        onChanged: (value) {
          // تحديث الرمز في الـ Controller
          controller.updateOTP(index, value);

          // منطق التنقل التلقائي بين المربعات
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && index > 0) {
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