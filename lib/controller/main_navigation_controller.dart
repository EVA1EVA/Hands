import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../view/home_screen.dart';
import '../view/provider_requests_screen.dart';
import '../view/user_offers_screen.dart';
import 'auth_controller.dart';

class MainNavigationController extends GetxController {
  var currentIndex = 0.obs;
  var userRole = 'user'.obs;

  @override
  void onInit() {
    super.onInit();
    // جلب الرول الفعلي من الذاكرة لضمان عدم ضياعه
    userRole.value = GetStorage().read('role') ?? 'user';
  }

  // 🏠 صفحات المستخدم العادي
  final userPages = [
    const HomeScreen(),
    const Center(child: Text("المحادثات", style: TextStyle(fontSize: 20))),
    const UserOffersScreen(),
    const Center(child: Text("حسابي", style: TextStyle(fontSize: 20))),
  ];

  // 🛠️ صفحات مقدم الخدمة
  final providerPages = [
    const ProviderRequestsScreen(),
    const Center(child: Text("محادثات المزود", style: TextStyle(fontSize: 20))),
    const Center(child: Text("عروضي", style: TextStyle(fontSize: 20))),
    const Center(child: Text("حسابي", style: TextStyle(fontSize: 20))),
  ];

  List<Widget> get currentPages => userRole.value == 'provider' ? providerPages : userPages;

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}