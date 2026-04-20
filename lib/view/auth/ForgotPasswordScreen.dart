
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          // 🟣 الخلفية الملونة للهيدر الأساسي
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                colors: [
                  AppColors.primaryGradientStart,
                  AppColors.primaryGradientEnd
                ],
              ),
            ),
            child: Stack(
              children: [
                // فقاعات خفيفة جداً داخل الهيدر الملون
                Positioned(
                  top: 80,
                  left: -20,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.05),
                  ),
                ),
                Positioned(
                  top: 150,
                  right: 30,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white.withOpacity(0.03),
                  ),
                ),

                // محتوى الهيدر (الأيقونة والنص)
                Column(
                  children: [
                    const SizedBox(height: 100),
                    const Center(
                      child: Icon(Icons.security_rounded, size: 80, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "أمن الحساب",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal'
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                        "خطوة واحدة لاستعادة وصولك",
                        style: TextStyle(color: Colors.white70)
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ⚪ الجزء الأبيض المنحني (المحتوى)
          Column(
            children: [
              const SizedBox(height: 300), // يحدد من أين يبدأ الانحناء الأبيض
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // ✨ الفقاعة السفلية اليمينية بلون الأكسينت
                      Positioned(
                        bottom: -40,
                        right: -30,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.accent.withOpacity(0.1),
                          ),
                        ),
                      ),

                      SingleChildScrollView(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            // بطاقة المعلومات المحدثة بالألوان الجديدة
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGradientStart.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: AppColors.primaryGradientStart.withOpacity(0.1)),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.info_outline, color: AppColors.primaryGradientStart),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "سنرسل كود مؤلف من 6 أرقام لبريدك الإلكتروني للتأكد من هويتك.",
                                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                            CustomTextField(
                              label: "البريد الإلكتروني",
                              hint: "mail@example.com",
                              prefixIcon: Icons.alternate_email,
                              iconColor: AppColors.accent, // لون الأكسينت للأيقونة
                              controller: authController.forgotEmailController,
                            ),
                            const SizedBox(height: 50),
                            Obx(() => PrimaryButton(
                              text: "إرسال كود التحقق",
                              isLoading: authController.isLoading.value,
                              onPressed: () => authController.sendPasswordResetCode(),
                            )),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
