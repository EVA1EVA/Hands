import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/user_offers_controller.dart';
import '../core/theme/app_colors.dart';

class UserOffersScreen extends StatelessWidget {
  const UserOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن الكنترولر
    final controller = Get.put(UserOffersController());

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
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryGradientStart));
              }

              // حالة عدم وجود بيانات
              if (controller.offers.isEmpty) {
                return const Center(child: Text("لا توجد عروض حالياً", style: TextStyle(fontFamily: 'Tajawal')));
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchOffers(),
                child: ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 110), // مساحة للبار العائم
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

  Widget _buildOffersHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(25, 60, 25, 25),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd]),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("العروض المستلمة", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
          SizedBox(height: 5),
          Text("اختر العرض الأنسب لميزانيتك وموقعك", style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'Tajawal')),
        ],
      ),
    );
  }

  Widget _buildOfferCard(var offer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // صورة المزود
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: offer['provider']['profile'] != null && offer['provider']['profile']['avatar'] != null
                      ? NetworkImage(offer['provider']['profile']['avatar'])
                      : null,
                  child: offer['provider']['profile'] == null ? const Icon(Icons.person) : null,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(offer['provider']['name'] ?? "مزود خدمة", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Tajawal')),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(" ${offer['provider']['rating_avg'] ?? '0.0'}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                // السعر
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("${offer['min_price']} - ${offer['max_price']}", style: const TextStyle(color: AppColors.primaryGradientStart, fontWeight: FontWeight.bold, fontSize: 15)),
                    const Text("ل.س", style: TextStyle(color: AppColors.primaryGradientStart, fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),

          // شريط المسافة والوقت (تم حل الـ Overflow هنا)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: AppColors.background.withOpacity(0.5),
            child: Row(
              children: [
                _infoRow(Icons.directions_car_filled_outlined, "يبعد ${offer['distance'] ?? '--'} كم"),
                const SizedBox(width: 10),
                _infoRow(Icons.access_time_rounded, "يصل خلال ${offer['eta_minutes'] ?? '--'} دقيقة"),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // منطق قبول العرض
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGradientStart,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.symmetric(vertical: 15)
                    ),
                    child: const Text("قبول العرض", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                    icon: const Icon(Icons.chat_outlined, color: AppColors.accent),
                    onPressed: () {
                      // فتح المحادثة
                    }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت مساعد مرن لمنع الـ Overflow
  Widget _infoRow(IconData icon, String label) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _filterChip("الأقرب", Icons.location_on),
            _filterChip("الأرخص", Icons.sell),
            _filterChip("الأعلى تقييماً", Icons.star),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primaryGradientStart.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.primaryGradientStart),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(fontSize: 11, fontFamily: 'Tajawal')),
        ],
      ),
    );
  }
}