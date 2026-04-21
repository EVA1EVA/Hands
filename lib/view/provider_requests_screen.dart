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

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
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
    final String categoryName = request['category']?['name'] ?? "صيانة عامة";
    final String date = request['created_at']?.split('T')[0] ?? 'اليوم';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // زوايا أنعم
        border: Border.all(color: AppColors.primaryGradientStart.withOpacity(0.08), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showOfferSheet(context, request, controller), // إذا ضغط على البطاقة يفتح له العرض
          child: Padding(
            padding: const EdgeInsets.all(16), // Padding مضغوط وناعم
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. حاوية الأيقونة الصافية والصغيرة
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.handyman_rounded, color: AppColors.accent, size: 24),
                ),
                const SizedBox(width: 14),

                // 2. معلومات الطلب
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.textPrimary,
                          fontFamily: 'Tajawal',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // صف المعلومات الثانوية (التاريخ ومكان وهمي)
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(date, style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontFamily: 'Tajawal')),

                          const SizedBox(width: 12),

                          Icon(Icons.location_on_rounded, size: 12, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text("بالقرب منك", style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontFamily: 'Tajawal')),
                        ],
                      ),
                    ],
                  ),
                ),

                // 3. زر تقديم العرض (مضغوط وعملي جداً)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                      color: AppColors.primaryGradientStart,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: AppColors.primaryGradientStart.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))
                      ]
                  ),
                  child: const Text(
                    "تقديم عرض",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal'
                    ),
                  ),
                ),
              ],
            ),
          ),
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
        height: MediaQuery.of(context).size.height * 0.85, // جعلناه يأخذ 85% من الشاشة ليرى كل التفاصيل
        padding: const EdgeInsets.fromLTRB(25, 15, 25, 25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 25),

            // 📑 قسم تفاصيل الطلب (السؤال والجواب)
            const Text("التفاصيل التقنية للطلب", style: TextStyle(fontSize: 16, color: AppColors.primaryGradientStart, fontWeight: FontWeight.w900, fontFamily: 'Tajawal')),
            const SizedBox(height: 15),

            // جعلنا قسم التفاصيل قابلاً للتمرير في حال كانت الأسئلة كثيرة
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRequestDetails(request),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: Divider(thickness: 1.5, color: AppColors.background),
                    ),
                    const Text("عرضك المالي", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Tajawal')),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(child: _buildPriceInput("من", minPrice)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildPriceInput("إلى", maxPrice)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text("ملاحظات العرض (اختياري)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Tajawal')),
                    const SizedBox(height: 10),
                    TextField(
                      controller: msg,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "مثال: السعر يشمل قطع الغيار، ويمكنني التنفيذ غداً صباحاً...",
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontFamily: 'Tajawal'),
                        fillColor: AppColors.background,
                        filled: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            _buildSubmitButton(controller, request['id'], minPrice, maxPrice, msg),
          ],
        ),
      ),
    );
  }

  // 🚀 المحلل الذكي للأسئلة والأجوبة (The Smart Q&A Parser)
  Widget _buildRequestDetails(dynamic request) {
    // التقاط بيانات الـ Answers من الباك إند
    var answersData = request['answers'];

    if (answersData == null) {
      return const Text("لم يقدم العميل تفاصيل إضافية", style: TextStyle(fontFamily: 'Tajawal', color: AppColors.textSecondary));
    }

    List<Widget> qnaWidgets = [];

    // 1. إذا كان الباك إند يرسل البيانات كمصفوفة (List of Objects)
    if (answersData is List && answersData.isNotEmpty) {
      for (var item in answersData) {
        // نحاول سحب نص السؤال من الحقل 'question' أو 'title' أو المفتاح مباشرة
        String question = item['question']?['question'] ?? item['question_text'] ?? "سؤال تفصيلي";
        String answer = item['answer']?.toString() ?? "بدون إجابة";

        qnaWidgets.add(_buildQnARow(question, answer));
      }
    }
    // 2. إذا كان الباك إند يرسل البيانات ككائن (Map/Object)
    else if (answersData is Map && answersData.isNotEmpty) {
      answersData.forEach((key, value) {
        String question = key.toString(); // المفتاح قد يكون الـ ID أو نص السؤال
        String answer = value.toString();

        // 🚀 خدعة تجميلية: إذا كان المفتاح عبارة عن رقم (ID السؤال)، نكتب "تفصيل رقم X"
        if (int.tryParse(question) != null) {
          question = "تفصيل رقم $question";
        }

        qnaWidgets.add(_buildQnARow(question, answer));
      });
    }

    if (qnaWidgets.isEmpty) {
      return const Text("لا توجد تفاصيل قابلة للقراءة", style: TextStyle(fontFamily: 'Tajawal', color: AppColors.textSecondary));
    }

    return Column(
      children: qnaWidgets,
    );
  }

  // 🚀 كرت السؤال والجواب المصغر (Q&A Card)
  Widget _buildQnARow(String question, String answer) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryGradientStart.withOpacity(0.05), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // نص السؤال (باهت قليلاً)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.help_outline_rounded, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                    question,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontFamily: 'Tajawal', fontWeight: FontWeight.w600)
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // نص الجواب (بارز وواضح)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.subdirectory_arrow_left_rounded, size: 16, color: AppColors.primaryGradientStart),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                    answer,
                    style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, fontFamily: 'Tajawal', fontWeight: FontWeight.bold)
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // 🚀 ويدجت لعرض إجابات العميل في الـ BottomSheet

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