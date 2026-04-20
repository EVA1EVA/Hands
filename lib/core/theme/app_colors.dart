/*
import 'package:flutter/material.dart';

class AppColors {
  static const primaryGradientStart = Color(0xFF1E3A8A); // أزرق غامق عميق
  static const primaryGradientEnd = Color(0xFF3B82F6);   // أزرق مشرق وحيوي

  // 2. تدرج الفيروزي (Teal Gradient) للأزرار والحركات - مستوحى من image_1.png
  static const tealGradientStart = Color(0xFF1875A6);
  static const tealGradientEnd = Color(0xFF45A195);

  // 3. ألوان الخلفية والنصوص (الفاتحة والأنيقة)
  static const background = Color(0xFFF8FAFC); // الأبيض المائل للرمادي
  static const card = Color(0xFFFFFFFF);    // ناصع البياض للحقول
  static const textPrimary = Color(0xFF0F172A); // أسود كربوني
  static const textSecondary = Color(0xFF64748B); // رمادي للنصوص الفرعية
  static const accent = Color(0xFFF59E0B);  // البرتقالي الذهبي
  static const error = Color(0xFFEF4444);
}*/
import 'package:flutter/material.dart';

class AppColors {
  // 1. تدرج البنفسجي الأساسي (الأصلي كان أزرق) - مستوحى من عمق ألوان الأزرار في image_2.png و image_3.png
  static const primaryGradientStart = Color(0xFF2E136C); // بنفسجي غامق جداً (إنديغو)
  static const primaryGradientEnd = Color(0xFF5A45A0);   // بنفسجي مشرق ومتوسط

  // 2. تدرج البنفسجي الفاتح للأزرار الثانوية (الأصلي كان فيروزي) - مستوحى من الأزرار الفاتحة مثل 'BACK TO LOGIN'
  static const tealGradientStart = Color(0xFF9180C4); // بنفسجي فاتح متوسط
  static const tealGradientEnd = Color(0xFFD3C8F0);   // بنفسجي لافندر فاتح جداً

  // 3. ألوان الخلفية والنصوص (الفاتحة والأنيقة)
  // قد نعدلها لتكون مائلة قليلاً للبنفسجي بدلاً من الأبيض الصرف
  static const background = Color(0xFFFBF8FF); // أبيض مائل جداً لللافندر
  static const card = Color(0xFFFFFFFF);    // ناصع البياض للحقول
  static const textPrimary = Color(0xFF0C081A); // أسود كربوني مائل للبنفسجي الغامق
  static const textSecondary = Color(0xFF7A708F); // رمادي مائل لللافندر للنصوص الفرعية
  static const accent = Color(0xFFF59E0B);  // البرتقالي الذهبي (يحافظ على التباين)
  static const error = Color(0xFFEF4444);
}