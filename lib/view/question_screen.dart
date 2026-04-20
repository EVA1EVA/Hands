
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/question_controller.dart';
import '../core/theme/app_colors.dart';
import 'map_picker_screen.dart';

class QuestionScreen extends StatelessWidget {
  final int serviceId;
  final String serviceName;

  const QuestionScreen({super.key, required this.serviceId, required this.serviceName});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuestionController());
    controller.fetchQuestions(serviceId);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildEliteHeader(),
          _buildRequiredNote(),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryGradientStart, strokeWidth: 3));
              }

              if (controller.questions.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                physics: const BouncingScrollPhysics(),
                itemCount: controller.questions.length + (controller.isPaginating.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < controller.questions.length) {
                    return _buildQuestionCard(controller.questions[index], controller);
                  } else {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryGradientStart)),
                    );
                  }
                },
              );
            }),
          ),
          _buildSubmitButton(controller),
        ],
      ),
    );
  }

  Widget _buildRequiredNote() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 15, 25, 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.15), shape: BoxShape.circle),
            child: const Icon(Icons.star_rounded, size: 10, color: AppColors.accent),
          ),
          const SizedBox(width: 8),
          const Text("الحقول المشار إليها بـ (*) مطلوبة لإتمام الطلب", style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // 🚀 كرت السؤال الموحد
  Widget _buildQuestionCard(dynamic q, QuestionController controller) {
    String title = q['question'] ?? "بدون عنوان";
    bool isRequired = q['is_required'] == true || q['is_required'] == 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primaryGradientStart.withOpacity(0.08), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
                child: const Icon(Icons.help_outline_rounded, size: 18, color: AppColors.primaryGradientStart),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: RichText(
                    text: TextSpan(
                      text: title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary, fontFamily: 'Tajawal', height: 1.4),
                      children: [
                        if (isRequired) const TextSpan(text: " *", style: TextStyle(color: AppColors.accent, fontSize: 18)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInputField(q, controller),
        ],
      ),
    );
  }

  Widget _buildInputField(dynamic q, QuestionController controller) {
    String type = q['type']?.toString().toLowerCase().trim() ?? 'text';
    int qId = q['id'];

    switch (type) {
      case 'textarea': return _buildTextField(hint: "اكتب التفاصيل بدقة...", maxLines: 4, onChanged: (val) => controller.updateAnswer(qId, val));
      case 'number':
      case 'numbers': return _buildTextField(hint: "أدخل الرقم...", keyboardType: TextInputType.number, onChanged: (val) => controller.updateAnswer(qId, val));
      case 'select':
      case 'dropdown': return _buildDropdownField(qId, q['options'] ?? [], controller);
      case 'image':
      case 'file': return _buildImagePickerField(qId, controller);
      default: return _buildTextField(hint: "إجابتك هنا...", onChanged: (val) => controller.updateAnswer(qId, val));
    }
  }

  // 🚀 الحقول النصية المتطورة
  Widget _buildTextField({required String hint, int maxLines = 1, TextInputType keyboardType = TextInputType.text, required Function(String) onChanged}) {
    return TextField(
      onChanged: onChanged,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Tajawal', color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.normal),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primaryGradientStart, width: 1.5)),
      ),
    );
  }

  // 🚀 القائمة المنسدلة
  Widget _buildDropdownField(int qId, dynamic optionsData, QuestionController controller) {
    return Obx(() {
      List<String> items = [];
      try {
        if (optionsData is List) items = optionsData.map((e) => e.toString()).toList();
        else if (optionsData is String && optionsData.isNotEmpty) {
          var decoded = json.decode(optionsData);
          if (decoded is List) items = decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {}

      String? currentValue = controller.userAnswers[qId]?.toString();
      if (currentValue != null && !items.contains(currentValue)) currentValue = null;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text("اختر من القائمة", style: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontFamily: 'Tajawal')),
            value: currentValue,
            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primaryGradientStart),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(16),
            items: items.map((val) => DropdownMenuItem<String>(value: val, child: Text(val, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Tajawal', color: AppColors.textPrimary)))).toList(),
            onChanged: (val) { if (val != null) { controller.updateAnswer(qId, val); controller.userAnswers.refresh(); } },
          ),
        ),
      );
    });
  }

  // 🚀 حقل رفع الصور (يشبه Dropzone في الشاشة السابقة)
  Widget _buildImagePickerField(int qId, QuestionController controller) {
    return Obx(() {
      List<File> imageList = (controller.userAnswers[qId] is List<File>) ? controller.userAnswers[qId] : [];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageList.isNotEmpty)
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: imageList.map((file) => Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.primaryGradientStart.withOpacity(0.2), width: 2)),
                    child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(file, height: 80, width: 80, fit: BoxFit.cover)),
                  ),
                  Positioned(
                    top: -6, right: -6,
                    child: GestureDetector(
                      onTap: () { imageList.remove(file); controller.userAnswers.refresh(); },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                        child: const Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                  )
                ],
              )).toList(),
            ),

          if (imageList.isNotEmpty) const SizedBox(height: 15),

          InkWell(
            onTap: () => _showImageSourceDialog(qId, controller),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryGradientStart.withOpacity(0.3), style: BorderStyle.solid),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_rounded, color: AppColors.primaryGradientStart, size: 22),
                  SizedBox(width: 8),
                  Text("إرفاق صور توضيحية", style: TextStyle(color: AppColors.primaryGradientStart, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  // 🚀 Bottom Sheet فاخر لاختيار الصور
  void _showImageSourceDialog(int qId, QuestionController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 30),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            const Text("إدراج صورة من", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Tajawal')),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(icon: Icons.camera_alt_rounded, label: "الكاميرا", onTap: () { Get.back(); controller.pickImage(qId, ImageSource.camera); }),
                Container(height: 60, width: 1, color: Colors.grey.shade200),
                _buildSourceOption(icon: Icons.photo_library_rounded, label: "المعرض", onTap: () { Get.back(); controller.pickImage(qId, ImageSource.gallery); }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: AppColors.primaryGradientStart.withOpacity(0.08), shape: BoxShape.circle), child: Icon(icon, color: AppColors.primaryGradientStart, size: 32)),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary, fontFamily: 'Tajawal')),
        ],
      ),
    );
  }

  // 🚀 الهيدر العضوي
  Widget _buildEliteHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
        boxShadow: [BoxShadow(color: AppColors.primaryGradientStart.withOpacity(0.25), blurRadius: 25, offset: const Offset(0, 10))],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(right: -40, top: -40, child: CircleAvatar(radius: 90, backgroundColor: Colors.white.withOpacity(0.04))),
          Positioned(left: -20, bottom: -50, child: CircleAvatar(radius: 70, backgroundColor: Colors.white.withOpacity(0.06))),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 30),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
                  child: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20), onPressed: () => Get.back()),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("تكملة بيانات الطلب", style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'Tajawal')),
                      const SizedBox(height: 4),
                      Text(serviceName, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
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

  // 🚀 الزر السفلي الاحترافي باللون البنفسجي الموحد
  Widget _buildSubmitButton(QuestionController controller) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 35),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Obx(() => Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd]),
          boxShadow: [BoxShadow(color: AppColors.primaryGradientStart.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () {
            if (controller.validateAnswers()) {
              Get.to(() => MapPickerScreen(
                onLocationConfirmed: (lat, lng) {
                  controller.sendRequestToApi(serviceId, lat, lng);
                  Get.back();
                },
              ));
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: controller.isLoading.value
              ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("تحديد الموقع والمتابعة", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'Tajawal', color: Colors.white)),
              SizedBox(width: 10),
              Icon(Icons.location_on_rounded, size: 20, color: Colors.white),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_late_outlined, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          const Text("لا توجد متطلبات حالياً", style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}