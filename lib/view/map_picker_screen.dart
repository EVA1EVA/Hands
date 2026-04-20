import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import '../controller/map_controller.dart';
import '../core/theme/app_colors.dart';

class MapPickerScreen extends StatelessWidget {
  final Function(double lat, double lng) onLocationConfirmed;

  const MapPickerScreen({super.key, required this.onLocationConfirmed});

  @override
  Widget build(BuildContext context) {
    // استخدام Get.put لجلب الكنترولر الذي يحتوي على ميزة جلب اسم العنوان
    final controller = Get.put(MapPickerOptionsController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "تحديد الموقع على الخريطة",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: 'Tajawal',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      body: PopScope(
        canPop: false,
        child: Stack(
          children: [
            // 1. الخريطة الأساسية
            FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                initialCenter: controller.selectedLocation.value,
                initialZoom: 16.0,
                onPositionChanged: (position, hasGesture) {
                  if (hasGesture && position.center != null) {
                    controller.updateLocation(position.center!);
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.untitled1',
                ),
              ],
            ),

            // 2. مؤشر الدبوس (Marker) الثابت في المنتصف
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 45), // لرفعه قليلاً ليكون الرأس على النقطة
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.textPrimary.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "اسحب لتحديد الموقع",
                        style: TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'Tajawal'),
                      ),
                    ),
                    const Icon(
                      Icons.location_on,
                      size: 55,
                      color: AppColors.tealGradientStart,
                    ),
                  ],
                ),
              ),
            ),

            // 3. زر العودة للموقع الحالي
            Positioned(
              bottom: 140, // رفعناه قليلاً لكي لا يختفي خلف الكرت السفلي
              right: 20,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white,
                elevation: 4,
                child: const Icon(Icons.my_location, color: AppColors.tealGradientStart),
                onPressed: () => controller.determinePosition(),
              ),
            ),

            // 4. الحاوية السفلية المدمجة والنظيفة (تم إزالة التكرار)
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25, 20, 25, 35),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, -5)
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // عرض العنوان الحالي
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: AppColors.tealGradientStart, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "العنوان المختار:",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                                // 🚀 Obx الصحيحة 100%: تغلف النص التفاعلي فقط!
                                Obx(() => Text(
                                  controller.addressName.value,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontFamily: 'Tajawal',
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // زر التأكيد
                    Container(
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: const LinearGradient(
                          colors: [AppColors.primaryGradientStart, AppColors.tealGradientEnd],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.tealGradientStart.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          onLocationConfirmed(
                            controller.selectedLocation.value.latitude,
                            controller.selectedLocation.value.longitude,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        child: const Text(
                          "تأكيد الموقع والبدء",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal'
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 5. شاشة التحميل (تظهر فقط عند جلب الموقع الأول)
            Obx(() => controller.isLoadingLocation.value
                ? Container(
              color: Colors.white.withOpacity(0.7),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.tealGradientStart),
                ),
              ),
            )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}