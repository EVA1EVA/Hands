import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../core/theme/app_colors.dart';
import '../routes/app_routes.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/wave_clipper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthController authController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    authController = Get.put(AuthController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.tealGradientStart, AppColors.tealGradientEnd],
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.handshake_rounded, size: 70, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.32,
            left: 20, right: 20, bottom: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // سيعمل من اليمين تلقائياً مع الـ RTL
                  children: [
                    const Text(
                      "مرحباً بك مجدداً",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "قم بتسجيل الدخول للوصول إلى الخدمات",
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 45),
                    CustomTextField(
                      label: "البريد الإلكتروني",
                      hint: "مثال: mail@example.com",
                      prefixIcon: Icons.email_outlined,
                      controller: authController.emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "البريد الإلكتروني مطلوب";
                        if (!GetUtils.isEmail(value)) return "صيغة البريد غير صحيحة";
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    CustomTextField(
                      label: "كلمة المرور",
                      hint: "أدخل كلمة المرور الخاصة بك",
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      controller: authController.passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "كلمة المرور مطلوبة";
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerLeft, // في العربية تكون يساراً
                      child: TextButton(
                        onPressed: () {Get.toNamed(AppRoutes.forgotPassword);},
                        child: const Text(
                          "نسيت كلمة المرور؟",
                          style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Obx(() => PrimaryButton(
                      text: "تسجيل الدخول",
                      isLoading: authController.isLoading.value,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          authController.login();
                        }
                      },
                    )),
                    const SizedBox(height: 35),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
                          children: [
                            const TextSpan(text: "ليس لديك حساب؟ "),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: GestureDetector(
                                onTap: () => Get.toNamed(AppRoutes.register),
                                child: const Text(
                                  "سجل الآن",
                                  style: TextStyle(color: AppColors.tealGradientStart, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}