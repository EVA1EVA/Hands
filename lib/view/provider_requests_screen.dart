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
    // تأكدي أن HomeController موجود في الـ main بـ permanent: true
    final homeController = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 🚀 الهيدر المطور مع الدوائر والـ Accent
          _buildEliteHeader(),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.availableRequests.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryGradientStart));
              }

              if (controller.availableRequests.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                color: AppColors.primaryGradientStart,
                onRefresh: () => controller.fetchAvailableRequests(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
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

  Widget _buildEliteHeader() {
    return Container(
      width: double.infinity,
      height: 190,
      child: Stack(
        children: [
          // الخلفية المتدرجة
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(45),
                bottomRight: Radius.circular(45),
              ),
            ),
          ),
          // 🌚 الدوائر الديكورية لكسر الرتابة (نفس ستايل باقي الصفحات)
          PositionNavigator(top: -40, left: -30, size: 150, color: Colors.white.withOpacity(0.07)),
          PositionNavigator(bottom: 20, right: -20, size: 100, color: AppColors.accent.withOpacity(0.15)),

          Padding(
            padding: const EdgeInsets.fromLTRB(25, 65, 25, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "مركز الفرص",
                          style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "طلبات الزبائن",
                      style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                    ),
                  ],
                ),
                _buildNotificationIcon(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 28),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: AppColors.accent, border: Border.all(color: AppColors.primaryGradientStart, width: 1.5), shape: BoxShape.circle),
          ),
        )
      ],
    );
  }

  Widget _buildRequestCard(BuildContext context, dynamic request, ProviderRequestsController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: AppColors.primaryGradientStart.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: [
            // شريط علوي ملون بسيط
            Container(height: 5, width: double.infinity, color: AppColors.accent),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                        child: const Icon(Icons.flash_on_rounded, color: AppColors.accent, size: 24),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              request['category']?['name'] ?? "صيانة عامة",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppColors.textPrimary, fontFamily: 'Tajawal'),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "تاريخ النشر: ${request['created_at']?.split('T')[0] ?? 'اليوم'}",
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontFamily: 'Tajawal'),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _showOfferSheet(context, request, controller),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGradientStart,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 0,
                    ),
                    child: const Text("تقديم عرض سعر", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOfferSheet(BuildContext context, dynamic request, ProviderRequestsController controller) {
    final minPrice = TextEditingController();
    final maxPrice = TextEditingController();
    final msg = TextEditingController();

    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        padding: const EdgeInsets.fromLTRB(25, 15, 25, 25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 25),

              // 📑 قسم تفاصيل الطلب (المعلومات التي طلبها الزبون)
              const Text("تفاصيل الطلب المختصرة", style: TextStyle(fontSize: 14, color: AppColors.accent, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildRequestDetails(request),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(thickness: 1, color: AppColors.background),
              ),

              const Text("عرضك المالي", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: _buildPriceInput("من", minPrice)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildPriceInput("إلى", maxPrice)),
                ],
              ),
              const SizedBox(height: 20),
              const Text("ملاحظات إضافية للزبون", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 10),
              TextField(
                controller: msg,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "مثلاً: يمكنني الحضور اليوم، السعر يشمل قطع الغيار...",
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  fillColor: AppColors.background,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 30),
              _buildSubmitButton(controller, request['id'], minPrice, maxPrice, msg),
            ],
          ),
        ),
      ),
    );
  }

  // 🚀 ويدجت لعرض إجابات العميل في الـ BottomSheet
  Widget _buildRequestDetails(dynamic request) {
    // نفترض أن الباك إند يرسل الإجابات في حقل 'answers'
    Map<String, dynamic> answers = request['answers'] ?? {};

    if (answers.isEmpty) return const Text("لا توجد تفاصيل إضافية");

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: answers.entries.map((e) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 6, color: AppColors.accent),
                const SizedBox(width: 10),
                Expanded(child: Text("${e.value}", style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSubmitButton(controller, id, min, max, msg) {
    return Obx(() => Container(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: controller.isLoading.value ? null : () => controller.submitOffer(
            requestId: id, minPrice: min.text, maxPrice: max.text, message: msg.text
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGradientStart,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: controller.isLoading.value
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("إرسال العرض الآن", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    ));
  }

  Widget _buildPriceInput(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        suffixText: "ل.س",
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        fillColor: AppColors.background,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: AppColors.accent.withOpacity(0.3)),
          const SizedBox(height: 20),
          const Text("لا توجد طلبات مطابقة حالياً", style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          const Text("سوف نخطرك عند توفر فرص جديدة", style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

// ويدجت مساعدة لرسم الدوائر في الهيدر
class PositionNavigator extends StatelessWidget {
  final double? top, left, right, bottom, size;
  final Color color;
  const PositionNavigator({super.key, this.top, this.left, this.right, this.bottom, this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top, left: left, right: right, bottom: bottom,
      child: Container(width: size, height: size, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
    );
  }
}