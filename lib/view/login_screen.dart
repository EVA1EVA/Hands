import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../core/theme/app_colors.dart';
import '../routes/app_routes.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/wave_clipper.dart'; // استيراد الكليبر الجديد

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
          // 1. الجزء العلوي المتموج (الحقيقي) مع تدرج الألوان الفخم
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: WaveClipper(), // تطبيق الكليبر الفني
              child: Container(
                height: MediaQuery.of(context).size.height * 0.35, // ارتفاع أكبر قليلاً
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.tealGradientStart,
                      AppColors.tealGradientEnd,
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // أيقونة فنية بسيطة بدلاً من الصورة
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.handshake_rounded, // أيقونة الأيادي المعبرة
                          size: 70,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),


                    ],
                  ),
                ),
              ),
            ),
          ),

          // 2. المحتوى الأبيض العائم بلمسة فخمة
          Positioned(
            top: MediaQuery.of(context).size.height * 0.32, // يتداخل مع التموج
            left: 20,
            right: 20,
            bottom: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // محاذاة لليسار
                  children: [
                    const Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Enter your details to access services",
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 45),

                    // حقل البريد المطوّر
                    CustomTextField(
                      label: "Email Address",
                      hint: "e.g., mail@example.com",
                      prefixIcon: Icons.email_outlined,
                      controller: authController.emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Email is required";
                        if (!GetUtils.isEmail(value)) return "Invalid email format";
                        return null;
                      },
                    ),
                    const SizedBox(height: 25), // مسافة أنيقة للـ Label العلوي

                    // حقل كلمة المرور مع العين
                    CustomTextField(
                      label: "Password",
                      hint: "Enter your password",
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      controller: authController.passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Password is required";
                        if (value.length < 8) return "Minimum 8 characters";
                        return null;
                      },
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // زر تسجيل الدخول Elegant بتدرج فيروزي
                    Obx(() => PrimaryButton(
                      text: "Sign In",
                      isLoading: authController.isLoading.value,
                      onPressed: authController.isLoading.value ? null : () {
                        if (_formKey.currentState!.validate()) {
                          authController.login();
                        }
                      },
                    )),

                    const SizedBox(height: 35),
                    // استبدلي الـ Row القديم بهذا الكود
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 20),
                        children: [
                          const TextSpan(text: "Don't have an account? "),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: GestureDetector(
                              onTap: () {
                                 Get.toNamed(AppRoutes.register);
                              },
                              child: const Text(
                                "Sign Up Now",
                                style: TextStyle(
                                  color: AppColors.primaryGradientStart,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
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