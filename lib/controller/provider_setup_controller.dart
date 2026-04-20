/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/controller/sub_category_controller.dart';
import '../core/api_constants.dart';

class ProviderSetupController extends GetxController {
  var selectedCategoryIds = <int>[].obs;
  var isLoading = false.obs;
  var currentStep = 0.obs;
  var idImage = Rxn<File>();
  var certificateImage = Rxn<File>();
  var selectedParentId = Rxn<int>();

  final ImagePicker _picker = ImagePicker();

  void toggleCategory(int id) {
    if (selectedCategoryIds.contains(id)) {
      selectedCategoryIds.remove(id);
    } else {
      selectedCategoryIds.add(id);
    }
  }

  void nextStep() {
    if (selectedCategoryIds.isNotEmpty) {
      currentStep.value = 1;
    } else {
      Get.snackbar("تنبيه", "يرجى اختيار تخصص واحد على الأقل", backgroundColor: Colors.orange, colorText: Colors.white);
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value = 0;
    }
  }

  Future<void> pickImage(bool isIdCard, ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 50);
      if (pickedFile != null) {
        if (isIdCard) {
          idImage.value = File(pickedFile.path);
        } else {
          certificateImage.value = File(pickedFile.path);
        }
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل في الوصول للكاميرا أو المعرض");
    }
  }

  // 🚀 دالة جديدة لحذف الصورة المحددة
  void clearImage(bool isIdCard) {
    if (isIdCard) {
      idImage.value = null;
    } else {
      certificateImage.value = null;
    }
  }

  Future<void> submitProviderData() async {
    final File? file1 = idImage.value;
    final File? file2 = certificateImage.value;
    final List<int> cats = selectedCategoryIds.toList();

    if (file1 == null || file2 == null) {
      Get.snackbar("تنبيه", "يرجى اختيار الوثائق المطلوبة أولاً", backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final box = GetStorage();
      String? token = box.read('token');

      if (token == null || token.isEmpty) {
        Get.snackbar("خطأ", "التوكن غير موجود، يرجى إعادة تسجيل الدخول");
        return;
      }

      // 1. إرسال التخصصات
      var catResponse = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/provider/categories'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({"categories": cats}),
      );

      if (catResponse.statusCode != 200 && catResponse.statusCode != 201) {
        throw "فشل تحديث التخصصات";
      }

      // 2. إرسال الوثائق
      var requestUrl = Uri.parse('${ApiConstants.baseUrl}/verification/request');
      var request = http.MultipartRequest('POST', requestUrl);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.files.add(await http.MultipartFile.fromPath('id_document', file1.path));
      request.files.add(await http.MultipartFile.fromPath('work_document', file2.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      var responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.offAllNamed('/ProviderRequestsScreen');
        Get.snackbar("نجاح", "تم إرسال الطلب بنجاح", backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        // 🚀 محرك اعتراض الأخطاء الذكي
        String errorMsg = responseData['message']?.toString().toLowerCase() ?? "";

        // التحقق مما إذا كان الخطأ بسبب وجود طلب سابق (حسب كلمات الباك إند المعتادة)
        if (errorMsg.contains("pending") || errorMsg.contains("already") || errorMsg.contains("بالفعل") || errorMsg.contains("انتظار")) {
          // بدلاً من الخطأ، نعتبرها معلومة ونوجهه للشاشة الصحيحة
          Get.offAllNamed('/ProviderRequestsScreen'); // تأكدي أن هذا هو اسم الشاشة الصحيح لديك
          Get.snackbar(
            "حالة الطلب",
            "لديك طلب توثيق قيد المراجعة بالفعل من قبل الإدارة.",
            backgroundColor: Colors.blueAccent,
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
          );
        } else {
          // أي خطأ آخر طبيعي (مثل صورة كبيرة جداً وغيرها)
          Get.snackbar("تنبيه", responseData['message'] ?? "حدث خطأ في الرفع", backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
      }
    } catch (e) {
      Get.snackbar("خطأ", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void selectParentCategory(int id) {
    selectedParentId.value = id;
    Get.find<SubCategoryController>().fetchSubCategories(id);
  }
}*/


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/controller/sub_category_controller.dart';
import '../core/api_constants.dart';

class ProviderSetupController extends GetxController {
  var selectedCategoryIds = <int>[].obs;
  var isLoading = false.obs;
  var currentStep = 0.obs;
  var idImage = Rxn<File>();
  var certificateImage = Rxn<File>();
  var selectedParentId = Rxn<int>();

  final ImagePicker _picker = ImagePicker();

  void toggleCategory(int id) {
    if (selectedCategoryIds.contains(id)) {
      selectedCategoryIds.remove(id);
    } else {
      selectedCategoryIds.add(id);
    }
  }

  // 🚀 الخطوة الأولى: إرسال التخصصات (إجباري) ثم الانتقال للخطوة الثانية
  Future<void> submitCategoriesAndNext() async {
    final List<int> cats = selectedCategoryIds.toList();

    if (cats.isEmpty) {
      Get.snackbar("تنبيه", "يرجى اختيار تخصص دقيق واحد على الأقل", backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final box = GetStorage();
      String? token = box.read('token');

      if (token == null || token.isEmpty) {
        Get.snackbar("خطأ", "التوكن غير موجود، يرجى تسجيل الدخول");
        return;
      }

      // 🚀 إرسال التخصصات للباك إند (مهم جداً قبل التوثيق)
      var catResponse = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/provider/categories'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json', // إجبار Laravel على التعامل معه كـ API
        },
        body: jsonEncode({"categories": cats}),
      );

      if (catResponse.statusCode == 200 || catResponse.statusCode == 201) {
        // إذا نجحنا، ننتقل فوراً لخطوة رفع الهوية
        currentStep.value = 1;
      } else {
        var errorData = jsonDecode(catResponse.body);
        throw errorData['message'] ?? "فشل في حفظ التخصصات";
      }
    } catch (e) {
      Get.snackbar("خطأ", e.toString(), backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value = 0;
    }
  }

  Future<void> pickImage(bool isIdCard, ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 50);
      if (pickedFile != null) {
        if (isIdCard) {
          idImage.value = File(pickedFile.path);
        } else {
          certificateImage.value = File(pickedFile.path);
        }
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل في الوصول للكاميرا أو المعرض");
    }
  }

  void clearImage(bool isIdCard) {
    if (isIdCard) idImage.value = null;
    else certificateImage.value = null;
  }

  // 🚀 الخطوة الثانية: رفع الوثائق
  Future<void> submitDocuments() async {
    final File? file1 = idImage.value;
    final File? file2 = certificateImage.value;

    if (file1 == null || file2 == null) {
      Get.snackbar("تنبيه", "يرجى إرفاق الهوية وشهادة المهنة معاً", backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final box = GetStorage();
      String? token = box.read('token');

      // 🚀 تجهيز الـ MultipartRequest بطريقة يفهمها Laravel
      var requestUrl = Uri.parse('${ApiConstants.baseUrl}/verification/request');
      var request = http.MultipartRequest('POST', requestUrl);

      // 🔥 السر هنا: إضافة X-Requested-With تمنع Laravel من تضييع الـ Role
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest', // هذه الترويسة سحرية مع Laravel!
      });

      request.files.add(await http.MultipartFile.fromPath('id_document', file1.path));
      request.files.add(await http.MultipartFile.fromPath('work_document', file2.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      var responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.offAllNamed('/ProviderRequests'); // نوجهه للرئيسية بعد النجاح
        Get.snackbar(
          "تم الإرسال بنجاح",
          "وثائقك الآن قيد المراجعة من قبل الإدارة. يمكنك تصفح الطلبات بانتظار التفعيل.",
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );      } else {
        String errorMsg = responseData['message']?.toString().toLowerCase() ?? "";

        if (errorMsg.contains("pending") || errorMsg.contains("already")) {
          Get.offAllNamed('/ProviderRequests');
          Get.snackbar("حالة الطلب", "لديك طلب توثيق قيد المراجعة بالفعل.", backgroundColor: Colors.blueAccent, colorText: Colors.white);
        } else {
          throw responseData['message'] ?? "حدث خطأ غير متوقع في الرفع";
        }
      }
    } catch (e) {
      Get.snackbar("فشل الرفع", e.toString(), backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void selectParentCategory(int id) {
    selectedParentId.value = id;
    Get.find<SubCategoryController>().fetchSubCategories(id);
  }
}