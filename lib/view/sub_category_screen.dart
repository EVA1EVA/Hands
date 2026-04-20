
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled1/view/question_screen.dart';
import '../controller/sub_category_controller.dart';
import '../core/theme/app_colors.dart';

class SubCategoryScreen extends StatelessWidget {
  final int parentId;
  final String categoryName;
  final Color categoryColor;

  const SubCategoryScreen({
    super.key,
    required this.parentId,
    required this.categoryName,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubCategoryController());
    controller.fetchSubCategories(parentId);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 🚀 الهيدر العضوي الفاخر الموحد
          _buildEliteHeader(context),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryGradientStart));
              }

              if (controller.subCategories.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                physics: const BouncingScrollPhysics(),
                itemCount: controller.subCategories.length,
                itemBuilder: (context, index) {
                  final subCat = controller.subCategories[index];
                  return _buildLuxuryServiceCard(subCat, index);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEliteHeader(BuildContext context) {
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
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(right: -40, top: -40, child: CircleAvatar(radius: 90, backgroundColor: Colors.white.withOpacity(0.04))),
          Positioned(left: -20, bottom: -50, child: CircleAvatar(radius: 70, backgroundColor: Colors.white.withOpacity(0.06))),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                    onPressed: () => Get.back(),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "الخدمات المتاحة في",
                        style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'Tajawal'),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        categoryName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLuxuryServiceCard(dynamic item, int index) {
    String title = item['name']?.toString() ?? "خدمة مميزة";
    int serviceId = item['id'] ?? 0;

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutBack,
      builder: (context, double value, child) {
        return Transform(
          transform: Matrix4.identity()..translate(0.0, 30 * (1 - value)),
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.primaryGradientStart.withOpacity(0.08), width: 1.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 6)),
            BoxShadow(color: categoryColor.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 8)),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            splashColor: AppColors.primaryGradientStart.withOpacity(0.05),
            onTap: () {
              Get.to(() => QuestionScreen(
                serviceId: serviceId,
                serviceName: title,
              ));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  _buildGlassIcon(_getServiceIcon(title)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary, fontFamily: 'Tajawal'),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.verified_user_rounded, size: 14, color: AppColors.textSecondary.withOpacity(0.8)),
                            const SizedBox(width: 4),
                            Text("خدمة معتمدة واحترافية", style: TextStyle(color: AppColors.textSecondary.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.w500, fontFamily: 'Tajawal')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.accent),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassIcon(IconData icon) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(color: AppColors.accent.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Center(
        child: Icon(icon, color: AppColors.accent, size: 26),
      ),
    );
  }

  IconData _getServiceIcon(String name) {
    String n = name.toLowerCase();
    if (n.contains('تنظيف')) return Icons.cleaning_services_rounded;
    if (n.contains('غسيل')) return Icons.local_laundry_service_rounded;
    if (n.contains('كهرباء')) return Icons.electrical_services_rounded;
    if (n.contains('تكييف') || n.contains('مكيف')) return Icons.ac_unit_rounded;
    if (n.contains('سباكة') || n.contains('مياه')) return Icons.plumbing_rounded;
    if (n.contains('دهان') || n.contains('طلاء')) return Icons.format_paint_rounded;
    if (n.contains('تصليح') || n.contains('صيانة')) return Icons.build_rounded;
    if (n.contains('نقل') || n.contains('عفش')) return Icons.local_shipping_rounded;
    return Icons.miscellaneous_services_rounded;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.widgets_rounded, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 15),
          const Text("لا توجد خدمات حالياً", style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}


