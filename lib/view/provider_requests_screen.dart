import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/provider_requests_controller.dart';
import '../controller/home_controller.dart';
import '../core/theme/app_colors.dart';

class ProviderRequestsScreen extends StatelessWidget {
  const ProviderRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProviderRequestsController());
    final homeController = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 🚀 الهيدر الفاخر الموحد (مثل باقي صفحات التطبيق)
          _buildEliteHeader(),

          // 🚀 قائمة الطلبات
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.availableRequests.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryGradientStart));
              }

              if (controller.availableRequests.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchAvailableRequests(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  itemCount: controller.availableRequests.length,
                  itemBuilder: (context, index) {
                    final request = controller.availableRequests[index];
                    return _buildRequestCard(context, request, controller);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // 🚀 الهيدر الموحد بنفس تصميم صفحات الـ Setup والـ Home
  Widget _buildEliteHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(color: AppColors.primaryGradientStart.withOpacity(0.25), blurRadius: 25, offset: const Offset(0, 10))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 60, 25, 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "لوحة التحكم",
                  style: TextStyle(color: AppColors.accent, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                ),
                SizedBox(height: 6),
                Text(
                  "الطلبات المتاحة",
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
              child: const Icon(Icons.notifications_active_outlined, color: Colors.white, size: 26),
            ),
          ],
        ),
      ),
    );
  }

  // 🚀 كارد الطلب (الجميع يمكنه الضغط والتقديم)
  Widget _buildRequestCard(BuildContext context, dynamic request, ProviderRequestsController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.primaryGradientStart.withOpacity(0.08), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(15)),
                child: const Icon(Icons.handyman_rounded, color: AppColors.primaryGradientStart, size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request['category']?['name'] ?? "طلب صيانة عامة",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary, fontFamily: 'Tajawal'),
                    ),
                    Text(
                      "نشر منذ: ${request['created_at'] ?? 'دقائق'}",
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontFamily: 'Tajawal'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(height: 1, thickness: 0.5),
          ),
          ElevatedButton(
            onPressed: () => _showOfferSheet(context, request['id'], controller),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGradientStart,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              elevation: 0,
            ),
            child: const Text(
              "عرض التفاصيل وتقديم سعر",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'Tajawal'),
            ),
          ),
        ],
      ),
    );
  }

  // 🚀 واجهة تقديم السعر (BottomSheet)
  void _showOfferSheet(BuildContext context, int requestId, ProviderRequestsController controller) {
    final minPriceController = TextEditingController();
    final maxPriceController = TextEditingController();
    final msgController = TextEditingController();

    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 45, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 25),
              const Text("تقديم عرض سعر مخصص", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(child: _buildPriceInput("أقل سعر متوقع", minPriceController)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildPriceInput("أعلى سعر متوقع", maxPriceController)),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: msgController,
                maxLines: 3,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "أضف ملاحظات تجذب العميل لخدمتك...",
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  fillColor: AppColors.background,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(15),
                ),
              ),
              const SizedBox(height: 25),
              Obx(() => Container(
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd]),
                  boxShadow: [BoxShadow(color: AppColors.primaryGradientStart.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.submitOffer(
                    requestId: requestId,
                    minPrice: minPriceController.text,
                    maxPrice: maxPriceController.text,
                    message: msgController.text,
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                  child: controller.isLoading.value
                      ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("إرسال العرض للعميل", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                ),
              )),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceInput(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            suffixText: "ل.س",
            suffixStyle: const TextStyle(fontSize: 12, color: Colors.grey),
            fillColor: AppColors.background,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_late_outlined, size: 70, color: Colors.grey.shade300),
          const SizedBox(height: 15),
          const Text("لا توجد طلبات جديدة في تخصصك حالياً", style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Tajawal')),
        ],
      ),
    );
  }
}