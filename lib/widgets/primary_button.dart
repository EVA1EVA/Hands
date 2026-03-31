import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55, // ارتفاعElegant
      child: DecoratedBox(
        // تطبيق تدرج الألوان على الزر
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [
              AppColors.tealGradientStart,
              AppColors.tealGradientEnd,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.tealGradientStart.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 5), // ظل سفلي يعطي ارتفاعاً
            )
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, // جعل الخلفية شفافة ليظهر التدرج
            shadowColor: Colors.transparent, // إزالة ظل الزر الأصلي
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onPressed,
          child: isLoading
              ? const SizedBox(
            width: 25,
            height: 25,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}