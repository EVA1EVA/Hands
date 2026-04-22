/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/user_offers_controller.dart';
import '../core/theme/app_colors.dart';

class UserOffersScreen extends StatelessWidget {
  const UserOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 💡 تصحيح: التأكد من عدم تكرار حقن الكنترولر إذا كان موجوداً مسبقاً
    /*final controller = Get.isRegistered<UserOffersController>()
        ? Get.find<UserOffersController>()
        : Get.put(UserOffersController());*/
// استخدمي fenix: true أو permanent: true إذا استمر الحذف تلقائياً
    final controller = Get.put(UserOffersController(), permanent: false);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildOffersHeader(),
          _buildFilterChips(),
          Expanded(
            child: Obx(() {
              // حالة التحميل الأولية
              if (controller.isLoading.value && controller.offers.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primaryGradientStart),
                );
              }

              // حالة عدم وجود بيانات
              if (controller.offers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_offer_outlined, size: 70, color: Colors.grey.withOpacity(0.3)),
                      const SizedBox(height: 10),
                      const Text("لا توجد عروض حالياً",
                          style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey)),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchOffers(),
                color: AppColors.primaryGradientStart,
                child: ListView.builder(
                  controller: controller.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
                  itemCount: controller.offers.length + (controller.hasMoreData ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.offers.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }
                    return _buildOfferCard(controller.offers[index]);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // 1️⃣ الـ Header الاحترافي
  Widget _buildOffersHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(25, 60, 25, 25),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("العروض المستلمة",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
          SizedBox(height: 5),
          Text("اختر العرض الأنسب لميزانيتك وموقعك",
              style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'Tajawal')),
        ],
      ),
    );
  }

  // 2️⃣ الـ Filter Chips للفرز
  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _filterChip("الأقرب", Icons.location_on_outlined),
            _filterChip("الأرخص", Icons.sell_outlined),
            _filterChip("الأعلى تقييماً", Icons.star_border_rounded),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primaryGradientStart.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5, offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.primaryGradientStart),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12, fontFamily: 'Tajawal', fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // 3️⃣ الـ Offer Card مع الأزرار المفقودة
  Widget _buildOfferCard(dynamic offer) {
    final provider = offer['provider'] ?? {};
    final profile = provider['profile'] ?? {};
    final String name = provider['name'] ?? "مزود خدمة";
    final String avatar = profile['avatar'] ?? "";

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[100],
                  child: ClipOval(
                    child: avatar.isNotEmpty
                        ? Image.network(
                      avatar,
                      fit: BoxFit.cover,
                      width: 60, height: 60,
                      errorBuilder: (context, e, s) => const Icon(Icons.person, color: Colors.grey),
                    )
                        : const Icon(Icons.person, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Tajawal')),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(" ${provider['rating_avg']?.toString() ?? '0.0'}",
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("${offer['min_price']?.toString() ?? '0'} - ${offer['max_price']?.toString() ?? '0'}",
                        style: const TextStyle(color: AppColors.primaryGradientStart, fontWeight: FontWeight.bold, fontSize: 14)),
                    const Text("ل.س", style: TextStyle(color: AppColors.primaryGradientStart, fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),

          // شريط المعلومات التقنية (Distance & Time)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: AppColors.background.withOpacity(0.5),
            child: Row(
              children: [
                _infoRow(Icons.directions_car_filled_outlined, "يبعد ${offer['distance']?.toString() ?? '--'} كم"),
                const SizedBox(width: 10),
                _infoRow(Icons.access_time_rounded, "يصل خلال ${offer['eta_minutes']?.toString() ?? '--'} دقيقة"),
              ],
            ),
          ),

          // 4️⃣ أزرار الأكشن (قبول العرض والمحادثة)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // منطق قبول العرض (سيتم ربطه بـ API Accept لاحقاً)
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGradientStart,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.symmetric(vertical: 15)
                    ),
                    child: const Text("قبول العرض",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: IconButton(
                      icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primaryGradientStart),
                      onPressed: () {
                        // فتح المحادثة مع المزود
                      }
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 5),
          Flexible(
            child: Text(label,
                style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}*/


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/user_offers_controller.dart';
import '../core/theme/app_colors.dart';

class UserOffersScreen extends StatelessWidget {
  const UserOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserOffersController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            _buildFilterChips(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryGradientStart));
                }
                return TabBarView(
                  children: [
                    _buildTabList(controller.myOffers, "لا توجد عروض مستلمة", controller),
                    _buildTabList(controller.nearbyOffers, "لا توجد عروض قريبة", controller),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(25, 60, 25, 25),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("مركز العروض", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
          SizedBox(height: 5),
          Text("تتبع عروضك واستكشف الخدمات المحيطة", style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'Tajawal')),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        indicatorColor: AppColors.primaryGradientStart,
        labelColor: AppColors.primaryGradientStart,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
        tabs: const [Tab(text: "عروضي الخاصة"), Tab(text: "عروض قريبة")],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: ["الأقرب", "الأرخص", "الأعلى تقييماً"].map((label) => Container(
            margin: const EdgeInsets.only(left: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade100)),
            child: Text(label, style: const TextStyle(fontSize: 12, fontFamily: 'Tajawal')),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildTabList(List<dynamic> list, String emptyMsg, UserOffersController controller) {
    if (list.isEmpty) {
      return Center(child: Text(emptyMsg, style: const TextStyle(fontFamily: 'Tajawal', color: Colors.grey)));
    }
    return RefreshIndicator(
      onRefresh: () => controller.fetchAllOffers(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: list.length,
        itemBuilder: (context, index) => _buildOfferCard(list[index]),
      ),
    );
  }

  Widget _buildOfferCard(dynamic offer) {
    final provider = offer['provider'] ?? {};
    final String name = provider['name'] ?? "مزود خدمة";

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(15),
            leading: CircleAvatar(radius: 25, backgroundColor: Colors.grey.shade100, child: const Icon(Icons.person)),
            title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  offer['price'] != null ? "${offer['price']}" : "${offer['min_price'] ?? '0'}-${offer['max_price'] ?? '0'}",
                  style: const TextStyle(color: AppColors.primaryGradientStart, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Text("ل.س", style: TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
          // 💡 هنا حل مشكلة الـ Overflow باستخدام Expanded
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            color: AppColors.background.withOpacity(0.4),
            child: Row(
              children: [
                Expanded(child: _iconInfo(Icons.location_on_outlined, "${offer['distance'] ?? '--'} كم")),
                Expanded(child: _iconInfo(Icons.timer_outlined, "${offer['eta_minutes'] ?? '--'} دقيقة")),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGradientStart, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 12)),
                    child: const Text("قبول العرض", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(icon: const Icon(Icons.chat_bubble_outline, color: AppColors.primaryGradientStart), onPressed: () {}),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _iconInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 5),
        Flexible(
          child: Text(text, style: const TextStyle(fontSize: 11, color: Colors.grey, fontFamily: 'Tajawal'), overflow: TextOverflow.ellipsis, maxLines: 1),
        ),
      ],
    );
  }
}