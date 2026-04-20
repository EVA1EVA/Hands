import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

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
          // الفقاعة العلوية للتصميم
          Positioned(
            top: -80,
            left: -50,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.tealGradientStart.withOpacity(0.4),
                    AppColors.primaryGradientEnd.withOpacity(0.2)
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100), // مساحة لإنزال المحتوى للأسفل
                    const Text(
                      "إنشاء حساب جديد",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGradientStart,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const Text(
                      "أدخل بياناتك للبدء في استخدام تطبيق Hands",
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 35),

                    const Text("أرغب في التسجيل كـ:",
                        style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 15),

                    Obx(() => Row(
                      children: [
                        _buildTypeCard("طالب خدمة", Icons.person_search_outlined,
                            authController.userType.value == 'user', () => authController.setUserType('user')),
                        const SizedBox(width: 15),
                        _buildTypeCard("مقدم خدمة", Icons.engineering_outlined,
                            authController.userType.value == 'provider', () => authController.setUserType('provider')),
                      ],
                    )),

                    const SizedBox(height: 30),
                    CustomTextField(
                      label: "الاسم الكامل",
                      hint: "أدخل اسمك بالكامل",
                      prefixIcon: Icons.person_outline,
                      iconColor: AppColors.accent,

                      controller: authController.nameController,
                      validator: (v) => v!.isEmpty ? "الاسم مطلوب" : null,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "البريد الإلكتروني",
                      hint: "example@mail.com",
                      prefixIcon: Icons.email_outlined,
                      iconColor: AppColors.accent,

                      controller: authController.emailController,
                      validator: (v) => GetUtils.isEmail(v!) ? null : "بريد غير صحيح",
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      label: "كلمة المرور",
                      hint: "أدخل كلمة مرور قوية",
                      prefixIcon: Icons.lock_outline,
                      iconColor: AppColors.accent,

                      isPassword: true,
                      controller: authController.passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "كلمة المرور مطلوبة";
                        String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                        RegExp regExp = RegExp(pattern);
                        if (!regExp.hasMatch(value)) {
                          return "يجب أن تحتوي: 8 رموز، حرف كبير، رقم، ورمز خاص";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "تأكيد كلمة المرور",
                      hint: "أعد كتابة كلمة المرور",
                      prefixIcon: Icons.lock_reset_outlined,
                      iconColor: AppColors.accent,

                      isPassword: true,
                      controller: authController.confirmPasswordController,
                      validator: (v) => v != authController.passwordController.text ? "كلمات المرور غير متطابقة" : null,
                    ),

                    const SizedBox(height: 40),
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
                    Center(
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                            children: [
                              TextSpan(text: "لديك حساب بالفعل؟ "),
                              TextSpan(text: "سجل دخولك", style: TextStyle(color: AppColors.primaryGradientStart, fontWeight: FontWeight.bold)),
                            ],
                          ),
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
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryGradientStart : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                color: isSelected ? AppColors.tealGradientEnd : Colors.grey.shade200,
                width: 1.5
            ),
            boxShadow: isSelected ? [BoxShadow(color: AppColors.primaryGradientStart.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))] : [],
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : AppColors.primaryGradientStart, size: 28),
              const SizedBox(height: 8),
              Text(title, style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  fontFamily: 'Tajawal'
              )),
            ],
          ),
        ),
      ),
    );
  }
}