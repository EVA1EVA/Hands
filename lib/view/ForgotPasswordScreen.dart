import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controller/auth_controller.dart';

import '../core/theme/app_colors.dart';

import '../routes/app_routes.dart';

import '../widgets/custom_text_field.dart';

import '../widgets/primary_button.dart';

class ForgotPasswordScreen extends StatelessWidget {

  const ForgotPasswordScreen({super.key});



  @override

  Widget build(BuildContext context) {

    final authController = Get.find<AuthController>();



    return Scaffold(

      // إضافة AppBar شفاف مع زر رجوع متناسق

      appBar: AppBar(

        elevation: 0,

        backgroundColor: Colors.transparent,

        iconTheme: const IconThemeData(color: Colors.white), // ليكون الزر أبيض فوق التدرج

        leading: IconButton(

          icon: const Icon(Icons.arrow_back_ios_new_rounded), // شكل زر عصري

          onPressed: () => Get.back(),

        ),

      ),

      extendBodyBehindAppBar: true, // لجعل التدرج اللوني يمتد خلف زر الرجوع

      body: Container(

        width: double.infinity,

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            begin: Alignment.topRight,

            colors: [AppColors.tealGradientStart, AppColors.tealGradientEnd],

          ),

        ),

        child: Column(

          children: [

            const SizedBox(height: 100), // مسافة إضافية للزر

            const Icon(Icons.security_rounded, size: 80, color: Colors.white),

            const SizedBox(height: 20),

            const Text(

              "أمن الحساب",

              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),

            ),

            const SizedBox(height: 10),

            const Text("خطوة واحدة لاستعادة وصولك", style: TextStyle(color: Colors.white70)),

            const SizedBox(height: 50),



            Expanded(

              child: Container(

                decoration: const BoxDecoration(

                  color: AppColors.background,

                  borderRadius: BorderRadius.only(

                      topLeft: Radius.circular(60),

                      topRight: Radius.circular(60)

                  ),

                ),

                child: SingleChildScrollView(

                  padding: const EdgeInsets.all(30),

                  child: Column(

                    children: [

                      const SizedBox(height: 40),

                      // بطاقة معلومات (Info Card)

                      Container(

                        padding: const EdgeInsets.all(15),

                        decoration: BoxDecoration(

                          color: AppColors.tealGradientStart.withOpacity(0.1),

                          borderRadius: BorderRadius.circular(15),

                          border: Border.all(color: AppColors.tealGradientStart.withOpacity(0.2)),

                        ),

                        child: const Row(

                          children: [

                            Icon(Icons.info_outline, color: AppColors.tealGradientStart),

                            SizedBox(width: 10),

                            Expanded(child: Text("سنرسل كود مؤلف من 6 أرقام لبريدك الإلكتروني للتأكد من هويتك.")),

                          ],

                        ),

                      ),

                      const SizedBox(height: 40),

                      CustomTextField(

                        label: "البريد الإلكتروني",

                        hint: "mail@example.com",

                        prefixIcon: Icons.alternate_email,

                        controller: authController.forgotEmailController,

                      ),

                      const SizedBox(height: 50),

                      Obx(() => PrimaryButton(

                        text: "إرسال كود التحقق",

                        isLoading: authController.isLoading.value,

                        onPressed: () => authController.sendPasswordResetCode(),

                      )),

                    ],

                  ),

                ),

              ),

            ),

          ],

        ),

      ),

    );

  }

}