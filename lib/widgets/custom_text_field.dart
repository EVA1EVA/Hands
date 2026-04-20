/*import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final String label; // اسم الحقل من فوق
  final bool isPassword;
  final TextEditingController controller;
  final IconData prefixIcon;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.label,
    required this.controller,
    required this.prefixIcon,
    this.isPassword = false,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // متغير محلي للتحكم برؤية كلمة المرور داخل الويدجت نفسها
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      validator: widget.validator,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
      decoration: InputDecoration(
        // 1. اسم الحقل والـ Hint
        labelText: widget.label,
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        hintText: widget.hint,
        hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5), fontSize: 14),
        floatingLabelBehavior: FloatingLabelBehavior.always, // يبقى الاسم بالأعلى دائماً

        // 2. الأيقونات (Prefix و Suffix)
        prefixIcon: Icon(widget.prefixIcon, color: AppColors.primaryGradientStart, size: 22),
        // أيقونة العين تظهر فقط إذا كان الحقل كلمة مرور
        suffixIcon: widget.isPassword
            ? GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: AppColors.textSecondary,
            size: 22,
          ),
        )
            : null,

        // 3. التصميم (Filled & Border) كما في الصورة
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGradientStart, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final String label;
  final bool isPassword;
  final TextEditingController controller;
  final IconData prefixIcon;
  final Color? iconColor; // 👈 إضافة هذا السطر لاستقبال اللون
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.label,
    required this.controller,
    required this.prefixIcon,
    this.iconColor, // 👈 إضافته هنا في الـ Constructor
    this.isPassword = false,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      validator: widget.validator,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        hintText: widget.hint,
        hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5), fontSize: 14),
        floatingLabelBehavior: FloatingLabelBehavior.always,

        // 🚀 تعديل هنا لاستخدام اللون الممرر أو اللون الافتراضي
        prefixIcon: Icon(
            widget.prefixIcon,
            color: widget.iconColor ?? AppColors.primaryGradientStart,
            size: 22
        ),

        suffixIcon: widget.isPassword
            ? GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: AppColors.textSecondary,
            size: 22,
          ),
        )
            : null,

        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            // إذا مررنا لون للأيقونة نستخدمه أيضاً للإطار عند التركيز ليعطي تناسق
              color: widget.iconColor ?? AppColors.primaryGradientStart,
              width: 1.5
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }
}