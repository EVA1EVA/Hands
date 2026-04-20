import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
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
      body: Obx(() => controller.currentPages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(() => CurvedNavigationBar(
        index: controller.currentIndex.value,
        height: 75,
        // لون الخلفية وراء البار (نفس لون خلفية الشاشة)
        backgroundColor: Colors.transparent,
        // لون البار نفسه (أبيض كما في الصورة)
        color: Colors.white,
        // لون الدائرة العائمة (Emerald Green من الثيم تبعنا)
        buttonBackgroundColor: AppColors.tealGradientStart,
        items: controller.userRole == 'provider'
            ? _buildProviderItems()
            : _buildUserItems(),
        onTap: (index) => controller.changeIndex(index),
        animationDuration: const Duration(milliseconds: 300),
      )),
    );
  }

  // أيقونات مقدم الخدمة (Provider)
  List<CurvedNavigationBarItem> _buildProviderItems() {
    return [
      const CurvedNavigationBarItem(child: Icon(Icons.home_outlined), label: 'الرئيسية'),
      const CurvedNavigationBarItem(child: Icon(Icons.assignment_outlined), label: 'الطلبات'),
      const CurvedNavigationBarItem(child: Icon(Icons.chat_bubble_outline), label: 'المحادثة'),
      const CurvedNavigationBarItem(child: Icon(Icons.person_outline), label: 'حسابي'),
    ];
  }

  // أيقونات المستخدم (User)
  List<CurvedNavigationBarItem> _buildUserItems() {
    return [
      const CurvedNavigationBarItem(child: Icon(Icons.grid_view), label: 'الخدمات'),
      const CurvedNavigationBarItem(child: Icon(Icons.chat_bubble_outline), label: 'محادثاتي'),
      const CurvedNavigationBarItem(child: Icon(Icons.history), label: 'طلباتي'),
      const CurvedNavigationBarItem(child: Icon(Icons.person_outline), label: 'حسابي'),
    ];
  }
}