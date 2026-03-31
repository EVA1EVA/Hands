import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_colors.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Get.offNamed(AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // الخلفية البيضاء
      body: Stack(
        children: [
          // 1. الجزء العلوي المتموج (كما في الصورة)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.45,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.background, AppColors.tealGradientEnd],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100), // تموج خفيف
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
          ),

          // 2. المحتوى الأبيض في الأسفل
          Positioned(
            top: MediaQuery.of(context).size.height * 0.45 - 60, // رفع المحتوى ليتداخل مع التموج
            left: 20,
            right: 20,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 30,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // الأيقونة الفيروزية
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.tealGradientStart.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.volunteer_activism_outlined,
                      size: 70,
                      color: AppColors.tealGradientStart,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "HANDS",
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      letterSpacing: 10,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "TRUSTED SERVICE MARKET",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // مؤشر التحميل السفلي
          const Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.tealGradientStart),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}