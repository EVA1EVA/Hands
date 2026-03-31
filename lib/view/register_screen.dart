import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../core/theme/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/wave_clipper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late AuthController authController;

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. التموج العلوي (Teal Gradient)
          Positioned(
            top: 0, left: 0, right: 0,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.tealGradientStart, AppColors.tealGradientEnd],
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Create Account",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),

          // 2. محتوى الفورم
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 20, right: 20, bottom: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text("I want to:", style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 15),

                    // بطاقات اختيار النوع مع أيقونات باللون الـ Accent
                    Obx(() => Row(
                      children: [
                        _buildTypeCard(
                            "Service Seeker",
                            Icons.person_search_outlined,
                            authController.userType.value == 'client',
                                () => authController.setUserType('client')
                        ),
                        const SizedBox(width: 15),
                        _buildTypeCard(
                            "Service Provider",
                            Icons.engineering_outlined,
                            authController.userType.value == 'provider',
                                () => authController.setUserType('provider')
                        ),
                      ],
                    )),
                    const SizedBox(height: 30),

                    CustomTextField(
                      label: "Full Name",
                      hint: "Enter your full name",
                      prefixIcon: Icons.person_outline,
                      controller: authController.nameController,
                      validator: (v) => v!.isEmpty ? "Name is required" : null,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      label: "Email Address",
                      hint: "mail@example.com",
                      prefixIcon: Icons.email_outlined,
                      controller: authController.emailController,
                      validator: (v) => GetUtils.isEmail(v!) ? null : "Invalid email",
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      label: "Password",
                      hint: "Create secure password",
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      controller: authController.passwordController,
                      validator: (v) => v!.length < 8 ? "Too short (min 8 chars)" : null,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      label: "Confirm Password",
                      hint: "Re-enter password",
                      prefixIcon: Icons.lock_reset_outlined,
                      isPassword: true,
                      controller: authController.confirmPasswordController,
                      validator: (v) => v != authController.passwordController.text ? "Not match" : null,
                    ),
                    const SizedBox(height: 35),

                    Obx(() => PrimaryButton(
                      text: "Sign Up",
                      isLoading: authController.isLoading.value,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          authController.register();
                        }
                      },
                    )),

                    const SizedBox(height: 25),

                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        children: [
                          const TextSpan(text: "Already have an account? "),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: GestureDetector(
                              onTap: () => Get.back(),
                              child: const Text(
                                "Login Here",
                                style: TextStyle(color: AppColors.tealGradientStart, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // الويدجت المعدلة لتجعل الأيقونة دائماً باللون الـ Accent
  Widget _buildTypeCard(String title, IconData icon, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.card : AppColors.card.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected ? AppColors.accent : Colors.grey.shade200,
              width: 2,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ] : [],
          ),
          child: Column(
            children: [
              // الأيقونة هنا دائماً تأخذ لون الـ Accent
              Icon(
                  icon,
                  color: AppColors.accent,
                  size: 30
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}