import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view/home_screen.dart';
import '../view/provider_requests_screen.dart';
import 'auth_controller.dart';

class MainNavigationController extends GetxController {
  var currentIndex = 0.obs;

  String get userRole => Get.find<AuthController>().userType.value;

  final userPages = [
    const HomeScreen(),      // الصفحة الرئيسية لليوزر
   // const UserChatScreen(),      // محادثات اليوزر
   // const UserOrdersScreen(),    // طلبات اليوزر
    //const ProfileScreen(),       // البروفايل المشترك
  ];

  final providerPages = [
   // const ProviderHomeScreen(),   // إحصائيات البروفايدر
    const ProviderRequestsScreen(), // الطلبات الواردة (صفحة خاصة)
   // const ProviderChatScreen(),   // محادثات البروفايدر
   // const ProfileScreen(),        // البروفايل المشترك
  ];

  List<Widget> get currentPages => userRole == 'provider' ? providerPages : userPages;

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}