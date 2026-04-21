

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/main_navigation_controller.dart';
import '../core/theme/app_colors.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainNavigationController());

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true, // 🚀 هذه التي تسمح للشاشات بالنزول خلف البار العائم
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: controller.currentPages,
      )),

      // 🚀 البار العائم الفاخر
      bottomNavigationBar: Obx(() {
        int currentIndex = controller.currentIndex.value;
        bool isProvider = controller.userRole == 'provider';

        // تعريف الأيقونات والأسماء بناءً على الرول
        List<Map<String, dynamic>> items = isProvider ? [
          {'icon': Icons.explore_rounded, 'label': 'الفرص'},
          {'icon': Icons.chat_bubble_rounded, 'label': 'الدردشة'},
          {'icon': Icons.local_offer_rounded, 'label': 'عروضي'},
          {'icon': Icons.person_rounded, 'label': 'حسابي'},
        ] : [
          {'icon': Icons.grid_view_rounded, 'label': 'الخدمات'},
          {'icon': Icons.chat_bubble_rounded, 'label': 'رسائلي'},
          {'icon': Icons.assignment_rounded, 'label': 'العروض الواردة'},
          {'icon': Icons.person_rounded, 'label': 'حسابي'},
        ];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15), // 🚀 هوامش تجعله يطفو
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35), // 🚀 حواف دائرية بالكامل
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGradientStart.withOpacity(0.15), // ظل بنفسجي فاخر
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(items.length, (index) {
                  return _buildFloatingNavItem(
                    icon: items[index]['icon'],
                    label: items[index]['label'],
                    index: index,
                    currentIndex: currentIndex,
                    onTap: () => controller.changeIndex(index),
                  );
                }),
              ),
            ),
          ),
        );
      }),
    );
  }

  // 🚀 زر التنقل مع تأثير التمدد (Pill Animation)
  Widget _buildFloatingNavItem({
    required IconData icon,
    required String label,
    required int index,
    required int currentIndex,
    required VoidCallback onTap,
  }) {
    bool isSelected = index == currentIndex;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 20 : 12,
            vertical: 12
        ),
        decoration: BoxDecoration(
          // 🚀 لون خفيف للأيقونة المحددة
          color: isSelected ? AppColors.primaryGradientStart.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? AppColors.primaryGradientStart : Colors.grey.shade400,
            ),
            // 🚀 النص يظهر فقط عندما تكون الأيقونة محددة
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isSelected
                  ? Padding(
                padding: const EdgeInsets.only(right: 8), // مسافة للنص العربي
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.primaryGradientStart,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    fontFamily: 'Tajawal',
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}