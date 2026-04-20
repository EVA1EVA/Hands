
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.find<AuthController>();

  // 🔑 مفتاح النموذج للتحقق من الحقول
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // فقاعات الخلفية لتعزيز الاندماج
          Positioned(top: -80, right: -50, child: _buildCircle(300, AppColors.primaryGradientStart.withOpacity(0.15))),
          Positioned(top: -40, left: -60, child: _buildCircle(200, AppColors.tealGradientStart.withOpacity(0.1))),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey, // ربط الفورم بالمفتاح
                child: Column(
                  children: [
                    const SizedBox(height: 60),

                    // 🎯 قسم الشعار المدمج والاسم الفخم مع البوردر الناعم
                    _buildLogoSection(),

                    const SizedBox(height: 50),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "مرحباً بك مجدداً",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryGradientStart, fontFamily: 'Tajawal'),
                          ),
                          Text(
                            "سجل دخولك لمتابعة خدماتك في Hands",
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 14, fontFamily: 'Tajawal'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    CustomTextField(
                      label: "البريد الإلكتروني",
                      hint: "mail@example.com",
                      prefixIcon: Icons.alternate_email_rounded,
                      iconColor: AppColors.accent,
                      controller: authController.emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "يرجى إدخال البريد الإلكتروني";
                        if (!GetUtils.isEmail(value)) return "صيغة البريد الإلكتروني غير صحيحة";
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    CustomTextField(
                      label: "كلمة المرور",
                      hint: "••••••••",
                      prefixIcon: Icons.lock_outline_rounded,
                      iconColor: AppColors.accent,
                      isPassword: true,
                      controller: authController.passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "كلمة المرور مطلوبة";
                        }

                        final passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');

                        if (!passwordRegExp.hasMatch(value)) {
                          return "يجب أن تحتوي: 8 رموز، حرف كبير، رقم، ورمز خاصً";
                        }

                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                        child: const Text("نسيت كلمة المرور؟", style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
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

                    const SizedBox(height: 40),

                    Center(
                      child: GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.register),
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
                            children: [
                              TextSpan(text: "ليس لديك حساب؟ "),
                              TextSpan(
                                text: "سجل الآن",
                                style: TextStyle(color: AppColors.primaryGradientStart, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
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

  // ميثود بناء الشعار المدمج والاسم
  Widget _buildLogoSection() {
    return Column(
      children: [
        // أيقونة تعبر عن المساعدة أو التلاقي (يد تحمل قلباً أو يد ممدودة)
        Stack(
          alignment: Alignment.center,
          children: [
            // هالة خلفية ناعمة
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryGradientStart.withOpacity(0.05),
              ),
            ),
            // الأيقونة الأساسية (اخترت لك volunteer_activism لأنها تمثل اليد التي تعطي)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGradientStart.withOpacity(0.15),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                  Icons.volunteer_activism_rounded, // أيقونة يد مع قلب (رمز العطاء والخدمة)
                  size: 55,
                  color: AppColors.primaryGradientStart
              ),
            ),
            // لمسة الأكسينت الصغيرة على جانب الأيقونة
            Positioned(
              right: 5,
              bottom: 5,
              child: Icon(Icons.auto_awesome, color: AppColors.accent, size: 25),
            ),
          ],
        ),
        const SizedBox(height: 20),

        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              fontFamily: 'Tajawal',
              letterSpacing: 4,
            ),
            children: [
              TextSpan(
                text: "HAN",
                style: TextStyle(
                  color: AppColors.primaryGradientStart,
                  shadows: [
                    // هذا الظل يعمل كإطار ناعم جداً حول الحرف
                    Shadow(
                      blurRadius: 3.0,
                      color: AppColors.primaryGradientStart.withOpacity(0.2),
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
              ),
              TextSpan(
                text: "DS",
                style: TextStyle(
                  color: AppColors.accent,
                  shadows: [
                    Shadow(
                      blurRadius: 2.0,
                      color: AppColors.accent.withOpacity(0.2),
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 5),
        // شعار صغير (Tagline) تحت الاسم
        Text(
          "خدماتك بين يديك",
          style: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.7),
            fontSize: 12,
            letterSpacing: 1,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCircle(double size, Color color) {
    return Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: color));
  }
}