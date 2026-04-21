
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controller/auth_controller.dart';
import '../controller/provider_setup_controller.dart';
import '../controller/sub_category_controller.dart';
import '../core/theme/app_colors.dart';
import '../controller/home_controller.dart';
import 'main_screen.dart';

class ProviderSetupScreen extends StatelessWidget {
  const ProviderSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    final setupController = Get.put(ProviderSetupController());
    final homeController = Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() => Column(
        children: [
          // 🚀 الهيدر العضوي الفاخر الموحد
          _buildEliteHeader(setupController.currentStep.value),

          // هندسة الـ Expanded لمنع الـ Overflow ودعم الباجينيشن
          Expanded(
            child: setupController.currentStep.value == 0
                ? _buildCategorySelection(homeController, setupController)
                : _buildDocumentUpload(setupController),
          ),

          // 🚀 الأزرار السفلية الموحدة
          _buildBottomButtons(setupController),
        ],
      )),
    );
  }

  // 🚀 الهيدر العضوي (Organic Header) - مطابق للهوية الجديدة
  Widget _buildEliteHeader(int step) {
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
          // دوائر هندسية ناعمة لكسر الجمود
          Positioned(right: -40, top: -40, child: CircleAvatar(radius: 90, backgroundColor: Colors.white.withOpacity(0.04))),
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
                        Text(
                          step == 0 ? "الخطوة الأولى" : "الخطوة الأخيرة",
                          style: const TextStyle(color: AppColors.accent, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          step == 0 ? "تحديد التخصص" : "توثيق الحساب",
                          style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
                      child: CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.white,
                        child: Icon(step == 0 ? Icons.work_outline_rounded : Icons.verified_user_rounded, color: AppColors.primaryGradientStart, size: 28),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  step == 0 ? "ما هي الخدمات التي تتقنها وتود تقديمها؟" : "نحتاج للوثائق لضمان جودة وأمان المنصة للجميع.",
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, fontFamily: 'Tajawal', height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelection(HomeController home, ProviderSetupController setup) {
    final subController = Get.put(SubCategoryController());

    return Obx(() {
      if (setup.selectedParentId.value == null) {
        return _buildParentGrid(home, setup);
      } else {
        return _buildSubCategoryList(setup, subController);
      }
    });
  }

  // 🚀 شبكة الفئات الرئيسية (تم تحويلها لـ Premium Interactive Cards)
  Widget _buildParentGrid(HomeController home, ProviderSetupController setup) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: _buildInfoBanner("اختر الفئة الرئيسية أولاً للبدء بإعداد ملفك المهني"),
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!home.isLoading.value &&
                  !home.isPaginating.value &&
                  scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
                home.loadCategories(isLoadMore: true);
              }
              return false;
            },
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85, // متناسقة مع الهوم
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              itemCount: home.categories.length + (home.isPaginating.value ? 2 : 0),
              itemBuilder: (context, index) {
                if (index >= home.categories.length) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryGradientStart));
                }

                final cat = home.categories[index];
                final String catName = cat['name']?.toString() ?? "";

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
                      child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
                    );
                  },
                  child: _buildPremiumInteractiveCard(
                    title: catName,
                    categoryName: catName,
                    onTap: () => setup.selectParentCategory(cat['id']),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // 🚀 قائمة الفئات الفرعية
  Widget _buildSubCategoryList(ProviderSetupController setup, SubCategoryController subController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 20, 0),
          child: TextButton.icon(
            onPressed: () => setup.selectedParentId.value = null,
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.primaryGradientStart),
            label: const Text("تغيير الفئة الرئيسية", style: TextStyle(color: AppColors.primaryGradientStart, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildInfoBanner("يمكنك اختيار تخصص دقيق أو أكثر من القائمة التالية"),
        ),
        const SizedBox(height: 15),

        Expanded(
          child: Obx(() {
            if (subController.isLoading.value) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primaryGradientStart));
            }

            if (subController.subCategories.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.category_rounded, size: 60, color: Colors.grey.shade300),
                    const SizedBox(height: 15),
                    const Text("لا توجد تخصصات دقيقة حالياً", style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }

            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!subController.isLoading.value &&
                    !subController.isPaginating.value &&
                    scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
                  subController.fetchSubCategories(setup.selectedParentId.value!, isLoadMore: true);
                }
                return false;
              },
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                physics: const BouncingScrollPhysics(),
                itemCount: subController.subCategories.length + (subController.isPaginating.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == subController.subCategories.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryGradientStart)),
                    );
                  }

                  final sub = subController.subCategories[index];
                  final subId = sub['id'];

                  return Obx(() {
                    final isSelected = setup.selectedCategoryIds.contains(subId);
                    return _buildLuxurySubCard(sub, isSelected, () => setup.toggleCategory(subId));
                  });
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  // 🚀 الكارد التفاعلي الفاخر للفئات الرئيسية (متطابق مع الهوم)
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
          border: Border.all(color: AppColors.primaryGradientStart.withOpacity(0.08), width: 1.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 6)),
            BoxShadow(color: AppColors.primaryGradientStart.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(color: AppColors.primaryGradientStart.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: SvgPicture.string(svgData, width: 48, height: 48),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Tajawal', letterSpacing: 0.2),
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

  // 🚀 الكرت الفاخر للفئات الفرعية (Checklist Style)
  Widget _buildLuxurySubCard(dynamic item, bool isSelected, VoidCallback onTap) {
    String title = item['name']?.toString() ?? "خدمة";
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryGradientStart.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.primaryGradientStart : Colors.grey.shade200,
          width: isSelected ? 2 : 1.5,
        ),
        boxShadow: isSelected ? [
          BoxShadow(color: AppColors.primaryGradientStart.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))
        ] : [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : AppColors.background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isSelected ? AppColors.primaryGradientStart.withOpacity(0.3) : Colors.transparent),
          ),
          child: Center(child: Icon(_getServiceIcon(title), color: AppColors.primaryGradientStart, size: 22)),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            fontSize: 15,
            color: AppColors.textPrimary,
            fontFamily: 'Tajawal',
          ),
        ),
        trailing: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? AppColors.primaryGradientStart : Colors.transparent,
            border: Border.all(color: isSelected ? AppColors.primaryGradientStart : Colors.grey.shade300, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(Icons.check, size: 14, color: isSelected ? Colors.white : Colors.transparent),
          ),
        ),
      ),
    );
  }

  // 🚀 البانر الفاخر الموحد
  Widget _buildInfoBanner(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.08), // خلفية أكسينت فاتحة جداً
        borderRadius: BorderRadius.circular(12),
        // خط قوي في الجهة اليمنى يعطي شكل الملاحظة (RTL Language)
        border: const Border(
          right: BorderSide(color: AppColors.accent, width: 4),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.accent, size: 22),
          const SizedBox(width: 12),
          Expanded(
              child: Text(
                  text,
                  style: TextStyle(
                      color: AppColors.textPrimary.withOpacity(0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                      fontFamily: 'Tajawal'
                  )
              )
          ),
        ],
      ),
    );
  }
  // 🚀 واجهة رفع الوثائق
  Widget _buildDocumentUpload(ProviderSetupController controller) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoBanner("بياناتك مشفرة ومحمية بالكامل. لا نقوم بمشاركتها مع أي طرف ثالث."),
          const SizedBox(height: 30),

          const Text("الوثائق الرسمية", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Tajawal')),
          const SizedBox(height: 20),

          Obx(() => _buildUploadBox(
            title: "الهوية الوطنية / جواز السفر",
            subtitle: "صورة واضحة، بدون انعكاسات ضوئية",
            icon: Icons.badge_rounded,
            selectedFile: controller.idImage.value,
            onTap: () => _showPickOptions(Get.context!, true, controller),
            onClear: () => controller.clearImage(true),
          )),

          const SizedBox(height: 25),

          Obx(() => _buildUploadBox(
            title: "شهادة مزاولة المهنة",
            subtitle: "لإثبات تخصصك وزيادة ثقة العملاء",
            icon: Icons.workspace_premium_rounded,
            selectedFile: controller.certificateImage.value,
            onTap: () => _showPickOptions(Get.context!, false, controller),
            onClear: () => controller.clearImage(false),
          )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // 🚀 بطاقة الرفع Dropzone
  Widget _buildUploadBox({
    required String title,
    required String subtitle,
    required IconData icon,
    required File? selectedFile,
    required VoidCallback onTap,
    required VoidCallback onClear,
  }) {
    bool hasFile = selectedFile != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary, fontFamily: 'Tajawal')),
            const SizedBox(width: 5),
            const Text("*", style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontFamily: 'Tajawal')),
        const SizedBox(height: 12),

        Stack(
          clipBehavior: Clip.none,
          children: [
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  color: hasFile ? Colors.black : AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: hasFile ? AppColors.primaryGradientStart : AppColors.primaryGradientStart.withOpacity(0.2),
                    width: hasFile ? 2 : 1.5,
                  ),
                  boxShadow: hasFile ? [
                    BoxShadow(color: AppColors.primaryGradientStart.withOpacity(0.15), blurRadius: 15, offset: const Offset(0, 5))
                  ] : [],
                ),
                child: hasFile
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(selectedFile, fit: BoxFit.cover),
                      Positioned(
                        bottom: 0, left: 0, right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black87, Colors.transparent],
                              )
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.touch_app_rounded, color: Colors.white, size: 16),
                              SizedBox(width: 6),
                              Text("اضغط لتغيير الصورة", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
                    : Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.primaryGradientStart.withOpacity(0.1), width: 1),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [BoxShadow(color: AppColors.primaryGradientStart.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: Icon(icon, size: 32, color: AppColors.primaryGradientStart),
                      ),
                      const SizedBox(height: 15),
                      const Text("انقر هنا لرفع المرفق", style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Tajawal')),
                      const SizedBox(height: 4),
                      Text("يدعم JPG, PNG (حد أقصى 5MB)", style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontFamily: 'Tajawal')),
                    ],
                  ),
                ),
              ),
            ),

            if (hasFile)
              Positioned(
                top: -8,
                right: -8,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onClear,
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                          boxShadow: [BoxShadow(color: AppColors.error.withOpacity(0.3), blurRadius: 8, offset: const Offset(0,4))]
                      ),
                      child: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

// 🚀 الأزرار الذكية الموحدة (المنطق الإداري الدقيق)
  Widget _buildBottomButtons(ProviderSetupController setup) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 20), // تقليل الـ Padding السفلي ليناسب زر التخطي
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // مهم جداً لمنع انهيار الشاشة
        children: [
          Row(
            children: [
              if (setup.currentStep.value == 1 || setup.selectedParentId.value != null)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Obx(() => OutlinedButton(
                      onPressed: setup.isLoading.value ? null : () {
                        if (setup.currentStep.value == 1) {
                          setup.previousStep();
                        } else {
                          setup.selectedParentId.value = null;
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 58),
                        side: BorderSide(color: setup.isLoading.value ? Colors.grey : AppColors.primaryGradientStart, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      child: const Text("رجوع", style: TextStyle(color: AppColors.primaryGradientStart, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Tajawal')),
                    )),
                  ),
                ),
              Expanded(
                child: Obx(() => Container(
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: setup.isLoading.value ? null : const LinearGradient(colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd]),
                    color: setup.isLoading.value ? AppColors.primaryGradientStart.withOpacity(0.5) : null,
                    boxShadow: setup.isLoading.value ? null : [BoxShadow(color: AppColors.primaryGradientStart.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: ElevatedButton(
                    // 🚀 المنطق الذكي هنا:
                    // خطوة 0 (التخصصات) => حفظ التخصصات إجبارياً في السيرفر ثم الانتقال لخطوة 1
                    // خطوة 1 (الوثائق) => رفع الوثائق للسيرفر
                    onPressed: setup.isLoading.value
                        ? null
                        : () => setup.currentStep.value == 0
                        ? setup.submitCategoriesAndNext()
                        : setup.submitDocuments(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    child: setup.isLoading.value
                        ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(
                        setup.currentStep.value == 0 ? "حفظ ومتابعة" : "إرسال للتوثيق",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Tajawal')
                    ),
                  ),
                )),
              ),
            ],
          ),

          // 🚀 زر التخطي (يظهر فقط في خطوة رفع الوثائق وليس في خطوة التخصص)
          Obx(() => setup.currentStep.value == 1 && !setup.isLoading.value
              ? Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextButton(
              onPressed: () {
                Get.offAllNamed('/ProviderRequests');
                Get.snackbar(
                  "تم التأجيل",
                  "تم حفظ تخصصاتك. ستحتاج لرفع وثائقك لاحقاً لتتمكن من استقبال طلبات العمل.",
                  backgroundColor: Colors.orange.withOpacity(0.9),
                  colorText: Colors.white,
                  duration: const Duration(seconds: 4),
                  snackPosition: SnackPosition.TOP,
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "تخطي هذه الخطوة مؤقتاً",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Tajawal',
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
  // 🚀 الـ Bottom Sheet الفاخر (iOS Style)
  void _showPickOptions(BuildContext context, bool isIdCard, ProviderSetupController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 30),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(35))
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 20),
            const Text("اختر مصدر المرفق", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Tajawal')),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(icon: Icons.camera_alt_rounded, label: "التقاط صورة", onTap: () { Get.back(); controller.pickImage(isIdCard, ImageSource.camera); }),
                Container(height: 60, width: 1, color: Colors.grey.shade200),
                _buildSourceOption(icon: Icons.photo_library_rounded, label: "مكتبة الصور", onTap: () { Get.back(); controller.pickImage(isIdCard, ImageSource.gallery); }),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildSourceOption({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [BoxShadow(color: AppColors.primaryGradientStart.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Icon(icon, color: AppColors.primaryGradientStart, size: 32)
            ),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary, fontFamily: 'Tajawal')),
          ],
        ),
      ),
    );
  }

  // 🚀 الأيقونات العملاقة ثنائية اللون (Duotone SVGs)
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

  IconData _getServiceIcon(String name) {
    String n = name.toLowerCase();
    if (n.contains('تنظيف') || n.contains('clean')) return Icons.cleaning_services_rounded;
    if (n.contains('غسيل') || n.contains('wash')) return Icons.local_laundry_service_rounded;
    if (n.contains('كهرب') || n.contains('elect')) return Icons.electrical_services_rounded;
    if (n.contains('سباك') || n.contains('plumb')) return Icons.plumbing_rounded;
    return Icons.star_border_rounded;
  }
}