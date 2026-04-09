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
                    "إنشاء حساب جديد",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 20, right: 20, bottom: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text("أرغب في التسجيل كـ:", style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 15),
                    Obx(() => Row(
                      children: [
                        _buildTypeCard("طالب خدمة", Icons.person_search_outlined, authController.userType.value == 'client', () => authController.setUserType('client')),
                        const SizedBox(width: 15),
                        _buildTypeCard("مقدم خدمة", Icons.engineering_outlined, authController.userType.value == 'provider', () => authController.setUserType('provider')),
                      ],
                    )),
                    const SizedBox(height: 30),
                    CustomTextField(
                      label: "الاسم الكامل",
                      hint: "أدخل اسمك بالكامل",
                      prefixIcon: Icons.person_outline,
                      controller: authController.nameController,
                      validator: (v) => v!.isEmpty ? "الاسم مطلوب" : null,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "البريد الإلكتروني",
                      hint: "example@mail.com",
                      prefixIcon: Icons.email_outlined,
                      controller: authController.emailController,
                      validator: (v) => GetUtils.isEmail(v!) ? null : "بريد غير صحيح",
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "كلمة المرور",
                      hint: "أدخل كلمة مرور قوية",
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      controller: authController.passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "كلمة المرور مطلوبة";
                        // التحقق من الشروط: 8 أحرف، أرقام، رموز، حرف كبير
                        String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                        RegExp regExp = RegExp(pattern);
                        if (!regExp.hasMatch(value)) {
                          return "يجب أن تحتوي: 8 رموز، حرف كبير، رقم، ورمز خاص";
                        }
                        return null;
                      },                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "تأكيد كلمة المرور",
                      hint: "أعد كتابة كلمة المرور",
                      prefixIcon: Icons.lock_reset_outlined,
                      isPassword: true,
                      controller: authController.confirmPasswordController,
                      validator: (v) => v != authController.passwordController.text ? "كلمات المرور غير متطابقة" : null,
                    ),
                    const SizedBox(height: 35),
                    Obx(() => PrimaryButton(
                      text: "إنشاء حساب",
                      isLoading: authController.isLoading.value,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          authController.register();
                        }
                      },
                    )),
                    const SizedBox(height: 25),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                          children: [
                            TextSpan(text: "لديك حساب بالفعل؟ "),
                            TextSpan(text: "سجل دخولك", style: TextStyle(color: AppColors.tealGradientStart, fontWeight: FontWeight.bold)),
                          ],
                        ),
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
            border: Border.all(color: isSelected ? AppColors.accent : Colors.grey.shade200, width: 2),
            boxShadow: isSelected ? [BoxShadow(color: AppColors.accent.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4))] : [],
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.accent, size: 30),
              const SizedBox(height: 8),
              Text(title, style: TextStyle(color: isSelected ? AppColors.textPrimary : AppColors.textSecondary, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}