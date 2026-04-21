
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled1/view/sub_category_screen.dart';
import '../controller/home_controller.dart';
import '../core/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final HomeController controller = Get.find();
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildEliteHeader(context),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.categories.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryGradientStart));
              }

              if (controller.categories.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.category_rounded, size: 60, color: Colors.grey.shade300),
                      const SizedBox(height: 15),
                      const Text("لا توجد تصنيفات متاحة حالياً", style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => controller.loadCategories(isLoadMore: false),
                      color: AppColors.primaryGradientStart,
                      child: GridView.builder(
                        controller: controller.scrollController,
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 0.85, // مساحة واسعة لراحة العين والأيقونات العملاقة
                        ),
                        itemCount: controller.categories.length,
                        itemBuilder: (context, index) {
                          final cat = controller.categories[index];
                          final String categoryName = cat['name']?.toString() ?? "خدمة";

                          int animationDelay = 300 + ((index % 6) * 100);

                          return TweenAnimationBuilder(
                            duration: Duration(milliseconds: animationDelay),
                            tween: Tween<double>(begin: 0, end: 1),
                            curve: Curves.easeOutBack,
                            builder: (context, double value, child) {
                              return Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..scale(0.8 + (0.2 * value))
                                  ..translate(0.0, 30 * (1 - value)),
                                child: Opacity(
                                    opacity: value.clamp(0.0, 1.0),
                                    child: child
                                ),
                              );
                            },
                            child: _buildPremiumInteractiveCard(
                              title: categoryName,
                              categoryName: categoryName,
                              onTap: () {
                                Get.to(() => SubCategoryScreen(
                                  parentId: cat['id'],
                                  categoryName: categoryName,
                                  categoryColor: AppColors.primaryGradientStart,
                                ));
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  if (controller.isPaginating.value)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: const CircularProgressIndicator(strokeWidth: 3, color: AppColors.primaryGradientStart),
                    ),
                ],
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
          BoxShadow(color: AppColors.primaryGradientStart.withOpacity(0.29), blurRadius: 25, offset: const Offset(0, 10))
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(right: -40, top: -40, child: CircleAvatar(radius: 90, backgroundColor: Colors.white.withOpacity(0.07))),
          Positioned(left: -20, bottom: -50, child: CircleAvatar(radius: 70, backgroundColor: Colors.white.withOpacity(0.06))),

          Padding(
            padding: const EdgeInsets.fromLTRB(25, 65, 25, 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("مرحباً بك 👋", style: TextStyle(color: Colors.white70, fontSize: 14, fontFamily: 'Tajawal')),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                            children: [
                              const TextSpan(text: "تطبيق ", style: TextStyle(color: Colors.white)),
                              TextSpan(text: "Hands", style: TextStyle(color: AppColors.accent, shadows: [Shadow(color: AppColors.accent.withOpacity(0.6), blurRadius: 12)])),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
                      child: const CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person_rounded, color: AppColors.primaryGradientStart, size: 28),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                Container(
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "عن ماذا تبحث اليوم؟",
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14, fontFamily: 'Tajawal', fontWeight: FontWeight.w600),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primaryGradientEnd, size: 26),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.tune_rounded, color: AppColors.accent, size: 20),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🚀 الكارد التفاعلي الفاخر (مع إطار ناعم جداً وبدون سهم)
  Widget _buildPremiumInteractiveCard({required String title, required String categoryName, required VoidCallback onTap}) {
    final String svgData = _getDuotoneSvg(categoryName, AppColors.primaryGradientStart, AppColors.accent);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      splashColor: AppColors.primaryGradientStart.withOpacity(0.05),
      highlightColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AppColors.primaryGradientStart.withOpacity(0.08),
            width: 1.8,
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 15,
                offset: const Offset(0, 6)
            ),
            BoxShadow(
                color: AppColors.primaryGradientStart.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 10)
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🚀 حاوية الأيقونة العملاقة مع إطار داخلي يعطي عمقاً (Engraved Look)
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white, // إطار أبيض يفصل الدائرة
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(color: AppColors.primaryGradientStart.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: SvgPicture.string(
                  svgData,
                  width: 48, // حجم عملاق واحترافي
                  height: 48,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    letterSpacing: 0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🚀 الأيقونات العملاقة ثنائية اللون (Duotone Dynamic SVGs)
  String _getDuotoneSvg(String category, Color primaryColor, Color accentColor) {
    String p = '#${primaryColor.value.toRadixString(16).substring(2, 8)}';
    String a = '#${accentColor.value.toRadixString(16).substring(2, 8)}';
    String n = category.toLowerCase();

    if (n.contains('منزلية') || n.contains('تنظيف')) {
      return '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M4 10L12 4L20 10V20C20 20.5523 19.5523 21 19 21H5C4.44772 21 4 20.5523 4 20V10Z" fill="$p" fill-opacity="0.12"/>
        <path d="M4 10L12 4L20 10M19 21H5C4.44772 21 4 20.5523 4 20V10M19 21V10" stroke="$p" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        <path d="M9 21V14C9 13.4477 9.44772 13 10 13H14C14.5523 13 15 13.4477 15 14V21" stroke="$p" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        <path d="M19 5L20 4M21 6L22 5" stroke="$a" stroke-width="2" stroke-linecap="round"/>
      </svg>''';
    }

    if (n.contains('سيارات')) {
      return '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M5 11L7 6H17L19 11V18C19 18.5523 18.5523 19 18 19H6C5.44772 19 5 18.5523 5 18V11Z" fill="$p" fill-opacity="0.12"/>
        <path d="M5 11L7 6H17L19 11M5 11V18C5 18.5523 5.44772 19 6 19H18C18.5523 19 19 18.5523 19 18V11M5 11H19" stroke="$p" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        <circle cx="8.5" cy="15.5" r="1.5" fill="$a"/>
        <circle cx="15.5" cy="15.5" r="1.5" fill="$a"/>
      </svg>''';
    }

    if (n.contains('تقنية') || n.contains('صيانة')) {
      return '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <rect x="5" y="5" width="14" height="14" rx="3" fill="$p" fill-opacity="0.12"/>
        <rect x="5" y="5" width="14" height="14" rx="3" stroke="$p" stroke-width="1.5"/>
        <path d="M10 10H14V14H10V10Z" stroke="$a" stroke-width="2" stroke-linejoin="round"/>
        <path d="M12 2V5M12 19V22M2 12H5M19 12H22M7 5V2M17 5V2M7 22V19M17 22V19M2 7H5M19 7H22M2 17H5M19 17H22" stroke="$p" stroke-width="1.5" stroke-linecap="round"/>
      </svg>''';
    }

    if (n.contains('تعليمية') || n.contains('تدريس')) {
      return '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M12 14L4 9L12 4L20 9L12 14Z" fill="$p" fill-opacity="0.12"/>
        <path d="M12 14L4 9L12 4L20 9L12 14Z" stroke="$p" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        <path d="M6 10.5V16C6 17.5 9 19 12 19C15 19 18 17.5 18 16V10.5" stroke="$p" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        <path d="M20 9V17" stroke="$a" stroke-width="2" stroke-linecap="round"/>
      </svg>''';
    }

    if (n.contains('صحية') || n.contains('جمال')) {
      return '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M12 20.5C12 20.5 4 14.5 4 8.5C4 5.5 6.5 3 9.5 3C10.8 3 11.8 3.5 12 4.2C12.2 3.5 13.2 3 14.5 3C17.5 3 20 5.5 20 8.5C20 14.5 12 20.5 12 20.5Z" fill="$p" fill-opacity="0.12"/>
        <path d="M12 20.5C12 20.5 4 14.5 4 8.5C4 5.5 6.5 3 9.5 3C10.8 3 11.8 3.5 12 4.2C12.2 3.5 13.2 3 14.5 3C17.5 3 20 5.5 20 8.5C20 14.5 12 20.5 12 20.5Z" stroke="$p" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        <path d="M9 10.5H11.5L12 8L13 13L13.5 10.5H15" stroke="$a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
      </svg>''';
    }

    if (n.contains('مناسبات') || n.contains('حفلات')) {
      return '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <rect x="4" y="9" width="16" height="12" rx="1" fill="$p" fill-opacity="0.12"/>
        <rect x="4" y="9" width="16" height="12" rx="1" stroke="$p" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        <path d="M12 9V21M3 9H21" stroke="$p" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        <path d="M12 9V5C12 3.5 10.5 2 9 2C7.5 2 6 3 6 4.5C6 6.5 9 9 12 9ZM12 9V5C12 3.5 13.5 2 15 2C16.5 2 18 3 18 4.5C18 6.5 15 9 12 9Z" stroke="$a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
      </svg>''';
    }

    if (n.contains('لوجستية') || n.contains('نقل')) {
      return '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M3 6H14V17H3V6Z" fill="$p" fill-opacity="0.12"/>
        <path d="M3 6H14V17H3V6Z" stroke="$p" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        <path d="M14 9H18L21 12V17H14" stroke="$p" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        <circle cx="7" cy="17" r="2" fill="$a"/>
        <circle cx="17" cy="17" r="2" fill="$a"/>
      </svg>''';
    }

    return '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
      <rect x="4" y="4" width="6" height="6" rx="1.5" fill="$p" fill-opacity="0.12"/>
      <rect x="14" y="4" width="6" height="6" rx="1.5" stroke="$p" stroke-width="1.5"/>
      <rect x="4" y="14" width="6" height="6" rx="1.5" stroke="$p" stroke-width="1.5"/>
      <rect x="14" y="14" width="6" height="6" rx="1.5" fill="$a" fill-opacity="0.5" stroke="$a" stroke-width="1.5"/>
    </svg>''';
  }
}