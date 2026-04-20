/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/provider_requests_controller.dart';
import '../core/theme/app_colors.dart';

class ProviderRequestsScreen extends StatelessWidget {
  const ProviderRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProviderRequestsController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: const Text("الطلبات المتاحة لتقديم عرض",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
        centerTitle: true,
        backgroundColor: AppColors.tealGradientStart,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.availableRequests.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppColors.tealGradientStart));
        }

        if (controller.availableRequests.isEmpty) {
          return const Center(child: Text("لا توجد طلبات متاحة حالياً"));
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchAvailableRequests(),
          child: ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: controller.availableRequests.length,
            itemBuilder: (context, index) {
              final request = controller.availableRequests[index];
              return _buildRequestCard(context, request, controller);
            },
          ),
        );
      }),
    );
  }

  Widget _buildRequestCard(BuildContext context, dynamic request, ProviderRequestsController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.tealGradientStart.withOpacity(0.1),
                child: const Icon(Icons.handyman_outlined, color: AppColors.tealGradientStart),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("طلب في قسم: ${request['category_id']}", // يفضل جلب اسم القسم
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text("منذ: ${request['created_at'] ?? 'الآن'}",
                        style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 30),
          ElevatedButton(
            onPressed: () => _showOfferSheet(context, request['id'], controller),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tealGradientStart,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 0,
            ),
            child: const Text("عرض التفاصيل وتقديم سعر",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

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
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("تقديم عرض سعر",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(child: _buildPriceInput("أقل سعر", minPriceController)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildPriceInput("أعلى سعر", maxPriceController)),
                ],
              ),
              const SizedBox(height: 15),
              TextField(
                controller: msgController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "اكتب ملاحظاتك للعميل هنا...",
                  fillColor: Colors.grey.shade50,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 25),
              Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.submitOffer(
                  requestId: requestId,
                  minPrice: minPriceController.text,
                  maxPrice: maxPriceController.text,
                  message: msgController.text,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tealGradientStart,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("إرسال العرض الآن", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              )),
              const SizedBox(height: 15),
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
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            suffixText: "ل.س",
            fillColor: Colors.grey.shade100,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}*/


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/provider_requests_controller.dart';
import '../controller/home_controller.dart';
import '../core/theme/app_colors.dart';

class ProviderRequestsScreen extends StatelessWidget {
  const ProviderRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استدعاء الكونترولرز اللازمة
    final controller = Get.put(ProviderRequestsController());
    final homeController = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: const Text(
          "الطلبات المتاحة",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
        ),
        centerTitle: true,
        backgroundColor: AppColors.tealGradientStart,
        elevation: 0,
        actions: [
          // شارة توضح حالة التوثيق في البار العلوي
          Obx(() => Icon(
            homeController.isProviderVerified.value ? Icons.verified : Icons.pending_actions,
            color: homeController.isProviderVerified.value ? Colors.white : Colors.orangeAccent,
          )),
          const SizedBox(width: 15),
        ],
      ),
      body: Column(
        children: [
          // 🚀 1. بانر حالة الحساب (يظهر فقط إذا كان الحساب غير موثق)
          Obx(() => _buildVerificationStatusBar(homeController)),

          // 🚀 2. قائمة الطلبات
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.availableRequests.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: AppColors.tealGradientStart));
              }

              if (controller.availableRequests.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchAvailableRequests(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: controller.availableRequests.length,
                  itemBuilder: (context, index) {
                    final request = controller.availableRequests[index];
                    return _buildRequestCard(context, request, controller, homeController);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // 🚀 بانر تنبيه للمزود غير الموثق
  Widget _buildVerificationStatusBar(HomeController home) {
    if (home.isProviderVerified.value) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border(bottom: BorderSide(color: Colors.orange.shade200, width: 1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.orange, size: 22),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "حسابك قيد المراجعة. يمكنك تصفح الطلبات، لكن تقديم العروض يتطلب توثيق الحساب.",
              style: TextStyle(fontSize: 12, color: Colors.orange, fontWeight: FontWeight.bold, fontFamily: 'Tajawal', height: 1.4),
            ),
          ),
          TextButton(
            onPressed: () => Get.toNamed('/providerSetup'),
            child: const Text("أكمل الوثائق", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
          )
        ],
      ),
    );
  }

  // 🚀 كارد الطلب مع منطق الحماية
  Widget _buildRequestCard(BuildContext context, dynamic request, ProviderRequestsController controller, HomeController home) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.tealGradientStart.withOpacity(0.1),
                child: const Icon(Icons.handyman_outlined, color: AppColors.tealGradientStart),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "طلب خدمة: ${request['category']?['name'] ?? 'قسم عام'}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Tajawal'),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "تاريخ الطلب: ${request['created_at'] ?? 'الآن'}",
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
              // عرض ميزانية تقريبية إذا وجدت
              if (request['budget'] != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(10)),
                  child: Text("${request['budget']} ل.س", style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const Divider(height: 30, thickness: 0.8),

          // 💡 الزر يتفاعل بناءً على حالة التوثيق
          ElevatedButton(
            onPressed: () {
              if (home.isProviderVerified.value) {
                _showOfferSheet(context, request['id'], controller);
              } else {
                _showBlockedDialog();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: home.isProviderVerified.value ? AppColors.tealGradientStart : Colors.grey.shade400,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 0,
            ),
            child: Text(
              home.isProviderVerified.value ? "تقديم عرض سعر الآن" : "التوثيق مطلوب للتقديم",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
            ),
          ),
        ],
      ),
    );
  }

  // 🚀 ديالوج التنبيه في حال عدم التوثيق
  void _showBlockedDialog() {
    Get.defaultDialog(
      title: "تفعيل ميزات العمل",
      titleStyle: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
      middleText: "نعتذر منك، لا يمكنك تقديم عروض أسعار حتى يتم مراجعة وثائقك وتوثيق حسابك من قبل الإدارة لضمان أمان المنصة.",
      middleTextStyle: const TextStyle(fontFamily: 'Tajawal'),
      textConfirm: "رفع/متابعة الوثائق",
      confirmTextColor: Colors.white,
      buttonColor: AppColors.tealGradientStart,
      onConfirm: () {
        Get.back();
        Get.toNamed('/providerSetup');
      },
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
              Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              const Text("تقديم عرض سعر مخصص", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
              const SizedBox(height: 10),
              const Text("حدد ميزانيتك المقترحة لهذا الطلب", style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(child: _buildPriceInput("أقل سعر", minPriceController)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildPriceInput("أعلى سعر", maxPriceController)),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: msgController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "اكتب رسالة مقنعة للعميل (اختياري)...",
                  hintStyle: const TextStyle(fontSize: 13),
                  fillColor: Colors.grey.shade50,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 25),
              Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.submitOffer(
                  requestId: requestId,
                  minPrice: minPriceController.text,
                  maxPrice: maxPriceController.text,
                  message: msgController.text,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tealGradientStart,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("إرسال العرض الآن", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              )),
              const SizedBox(height: 15),
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
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            suffixText: "ل.س",
            fillColor: Colors.grey.shade100,
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
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 15),
          const Text("لا توجد طلبات متاحة لمجالك حالياً", style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Tajawal')),
        ],
      ),
    );
  }
}