import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/primary_button.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 🟣 الفقاعات الخلفية لتوحيد الهوية
          Positioned(
            top: -70,
            right: -50,
            child: _buildCircle(250, AppColors.primaryGradientStart.withOpacity(0.15)),
          ),
          Positioned(
            top: 40,
            left: -60,
            child: _buildCircle(180, AppColors.tealGradientStart.withOpacity(0.1)),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 80), // زيادة المسافة العلوية لتعويض العداد

                  // 🎯 أيقونة البريد المدمجة
                  _buildAnimatedHeaderIcon(),

                  const SizedBox(height: 40),

                  const Text(
                    "رمز التحقق",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGradientStart,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "أدخل الرمز المكون من 6 أرقام\nالذي أرسلناه إلى بريدك الإلكتروني",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                      height: 1.6,
                      fontFamily: 'Tajawal',
                    ),
                  ),

                  const SizedBox(height: 60),

                  // 🔢 حقول الـ OTP (المنطق كما هو تماماً)
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                            (index) => _buildGlowOTPBox(context, index, authController),
                      ),
                    ),
                  ),

                  const SizedBox(height: 80), // مسافة واسعة لتعطي راحة بصرية بعد الحذف

                  // 🔘 زر التحقق الأساسي
                  Obx(() => PrimaryButton(
                    text: "تحقق الآن",
                    isLoading: authController.isLoading.value,
                    onPressed: () => authController.verifyOTP(),
                  )),

                  const SizedBox(height: 80),

                  // 🛡️ تذييل الأمان (Security Footer)
                  _buildSecurityFooter(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت الهيدر المدمج
  Widget _buildAnimatedHeaderIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [AppColors.primaryGradientStart.withOpacity(0.12), Colors.transparent],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGradientStart.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.mark_email_read_rounded,
            size: 65,
            color: AppColors.primaryGradientStart,
          ),
        ),
      ],
    );
  }

  // مربعات الـ OTP المطور
  Widget _buildGlowOTPBox(BuildContext context, int index, AuthController controller) {
    return Container(
      width: 48,
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.12),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: AppColors.accent.withOpacity(0.25),
          width: 1.5,
        ),
      ),
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        cursorColor: AppColors.accent,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.accent),
        onChanged: (value) {
          controller.updateOTP(index, value); // المنطق محفوظ
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

  // تذييل الأمان المنسجم
  Widget _buildSecurityFooter() {
    return Column(
      children: [
        Container(
          width: 40,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.primaryGradientStart.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.textSecondary.withOpacity(0.4)),
            const SizedBox(width: 8),
            Text(
              "عملية تحقق آمنة بنسبة 100%",
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.4),
                fontSize: 11,
                fontFamily: 'Tajawal',
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}