/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../core/api_constants.dart';
import '../model/question_model.dart';
import 'dart:io'; // إلزامي للتعامل مع الملفات
import 'package:image_picker/image_picker.dart';

class QuestionController extends GetxController {
  var isLoading = true.obs;
  var questions = <dynamic>[].obs;
  var userAnswers = <int, dynamic>{}.obs;

  final box = GetStorage();
  void fetchQuestions(int serviceId) async {
    try {
      isLoading(true);
      String? token = box.read('token');

      final response = await http.get(
        Uri.parse("${ApiConstants.getCategoryQuestions}$serviceId"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        List<dynamic> fetchedQuestions = [];

        // 🔥 هنا التحليل الجذري لرد الباك إند الخاص بكِ
        if (decodedData is Map && decodedData.containsKey('questions')) {
          // إذا كان الباك إند يعيد التصنيف وبداخله الأسئلة: {id:1, name: "...", questions: [...]}
          fetchedQuestions = decodedData['questions'];
        } else if (decodedData is List) {
          // إذا كان يعيد قائمة مباشرة
          fetchedQuestions = decodedData;
        } else if (decodedData is Map && decodedData.containsKey('data')) {
          // إذا كان هناك تغليف إضافي بكلمة data
          var innerData = decodedData['data'];
          if (innerData is Map && innerData.containsKey('questions')) {
            fetchedQuestions = innerData['questions'];
          } else if (innerData is List) {
            fetchedQuestions = innerData;
          }
        }

        questions.assignAll(fetchedQuestions);
        print("✅ تم استخراج ${questions.length} سؤال من بيانات التصنيف");

      } else {
        print("⚠️ خطأ من السيرفر: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ خطأ في الـ Parsing: $e");
    } finally {
      isLoading(false);
    }
  }

  void updateAnswer(int questionId, dynamic value) {
    userAnswers[questionId] = value;
  }

  // دالة التحقق مطابقة للـ Model (is_required)
  bool validateAnswers() {
    for (var q in questions) {
      // تعديل المسمى ليتطابق مع Model: ServiceQuestion
      bool isRequired = q['is_required'] == true || q['is_required'] == 1;
      var answer = userAnswers[q['id']];

      if (isRequired) {
        if (answer == null || answer.toString().trim().isEmpty) {
          Get.snackbar(
            "حقل مطلوب",
            "يرجى الإجابة على السؤال: ${q['question']}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            margin: const EdgeInsets.all(15),
          );
          return false;
        }
      }
    }
    return true;
  }

// داخل كلاس QuestionController
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(int qId, ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 50, // لتقليل حجم الصورة المرسلة للباك إند
      );

      if (pickedFile != null) {
        // تخزين مسار الصورة في الإجابات
        userAnswers[qId] = File(pickedFile.path);
        userAnswers.refresh(); // لتحديث الواجهة فوراً
        print("✅ Image Selected: ${pickedFile.path}");
      }
    } catch (e) {
      print("❌ Error picking image: $e");
      Get.snackbar("خطأ", "فشل في اختيار الصورة");
    }
  }
  // داخل QuestionController
  Future<void> sendRequestToApi(int categoryId) async {
    try {
      isLoading.value = true;
      var request = http.MultipartRequest('POST', Uri.parse('${ApiConstants.baseUrl}/v1/service-requests'));

      // إضافة التوكن
      request.headers['Authorization'] = 'Bearer ${box.read('token')}';

      // إرسال الـ category_id
      request.fields['category_id'] = categoryId.toString();

      // تحويل الأجوبة لـ JSON وإرسالها (حسب طلب الباك إيند answers => array)
      // ملاحظة: الباك إيند بيتوقع الأجوبة بكي اسمه answers
      Map<String, String> formattedAnswers = {};
      userAnswers.forEach((key, value) {
        if (value is! File) {
          formattedAnswers[key.toString()] = value.toString();
        }
      });
      request.fields['answers'] = json.encode(formattedAnswers);

      // إرسال الصور (إذا كان في صور ضمن الأجوبة)
      for (var entry in userAnswers.entries) {
        if (entry.value is File) {
          request.files.add(await http.MultipartFile.fromPath('images[]', entry.value.path));
        }
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        Get.offAllNamed('/home');
        Get.snackbar("نجاح", "تم إرسال طلبك بنجاح وسيصلك عروض قريباً");
      }
    } finally {
      isLoading.value = false;
    }
  }
}*/
/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../core/api_constants.dart';
import '../model/question_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class QuestionController extends GetxController {
  var isLoading = true.obs;
  var questions = <dynamic>[].obs;
  var userAnswers = <int, dynamic>{}.obs;

  final box = GetStorage();

 /* void fetchQuestions(int serviceId) async {
    try {
      isLoading(true);
      String? token = box.read('token');

      final response = await http.get(
        Uri.parse("${ApiConstants.getCategoryQuestions}$serviceId"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        List<dynamic> fetchedQuestions = [];

        if (decodedData is Map && decodedData.containsKey('questions')) {
          fetchedQuestions = decodedData['questions'];
        } else if (decodedData is List) {
          fetchedQuestions = decodedData;
        } else if (decodedData is Map && decodedData.containsKey('data')) {
          var innerData = decodedData['data'];
          if (innerData is Map && innerData.containsKey('questions')) {
            fetchedQuestions = innerData['questions'];
          } else if (innerData is List) {
            fetchedQuestions = innerData;
          }
        }

        questions.assignAll(fetchedQuestions);
        print("✅ تم استخراج ${questions.length} سؤال من بيانات التصنيف");

      } else {
        print("⚠️ خطأ من السيرفر: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ خطأ في الـ Parsing: $e");
    } finally {
      isLoading(false);
    }
  }
*/
  void fetchQuestions(int serviceId) async {
    try {
      isLoading(true);
      String? token = box.read('token');

      final response = await http.get(
        Uri.parse("${ApiConstants.getCategoryQuestions}$serviceId"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        List<dynamic> fetchedQuestions = [];

        // 1. فحص إذا كان الرد يحتوي على مفتاح 'questions'
        if (decodedData is Map && decodedData.containsKey('questions')) {
          var qData = decodedData['questions'];

          // 2. إذا كان داخل 'questions' باجينيشن (يحتوي على مفتاح data)
          if (qData is Map && qData.containsKey('data')) {
            fetchedQuestions = qData['data'];
          }
          // 3. إذا كان 'questions' هو القائمة مباشرة
          else if (qData is List) {
            fetchedQuestions = qData;
          }
        }
        // 4. حالة احتياطية: إذا كان الرد كاملاً هو كائن باجينيشن
        else if (decodedData is Map && decodedData.containsKey('data')) {
          fetchedQuestions = decodedData['data'];
        }
        // 5. حالة احتياطية: إذا كان الرد قائمة مباشرة
        else if (decodedData is List) {
          fetchedQuestions = decodedData;
        }

        questions.assignAll(fetchedQuestions);
        print("✅ تم استخراج ${questions.length} سؤال بنجاح");
      } else {
        print("⚠️ خطأ من السيرفر: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ خطأ في الـ Parsing: $e");
    } finally {
      isLoading(false);
    }
  }
  void updateAnswer(int questionId, dynamic value) {
    userAnswers[questionId] = value;
  }

  bool validateAnswers() {
    for (var q in questions) {
      bool isRequired = q['is_required'] == true || q['is_required'] == 1;
      var answer = userAnswers[q['id']];

      if (isRequired) {
        if (answer == null || answer.toString().trim().isEmpty) {
          Get.snackbar(
            "حقل مطلوب",
            "يرجى الإجابة على السؤال: ${q['question']}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            margin: const EdgeInsets.all(15),
          );
          return false;
        }
      }
    }
    return true;
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(int qId, ImageSource source) async {
    try {
      final List<XFile> pickedFiles = [];

      if (source == ImageSource.gallery) {
        pickedFiles.addAll(await _picker.pickMultiImage());
      } else {
        final XFile? camFile = await _picker.pickImage(source: source);
        if (camFile != null) pickedFiles.add(camFile);
      }

      if (pickedFiles.isNotEmpty) {
        List<File> validFiles = [];
        for (var xFile in pickedFiles) {
          File file = File(xFile.path);
          int sizeInBytes = await file.length();

          // التحقق من الحجم (2MB)
          if (sizeInBytes <= 2048 * 1024) {
            validFiles.add(file);
          } else {
            Get.snackbar("حجم كبير", "تم تجاهل ملف لتجاوزه 2MB", backgroundColor: Colors.orange);
          }
        }

        if (validFiles.isNotEmpty) {
          // نتحقق إذا كانت الإجابة الحالية هي أصلاً مصفوفة، إذا لا نحولها لمصفوفة
          if (userAnswers[qId] is! List<File>) {
            userAnswers[qId] = <File>[];
          }
          userAnswers[qId].addAll(validFiles);
          userAnswers.refresh();
        }
      }
    } catch (e) {
      print("❌ Error picking image: $e");
    }
  }
  Future<void> sendRequestToApi(int categoryId) async {
    try {
      isLoading.value = true;
      String? token = box.read('token');

      // تأكدي من المسار الصحيح للـ URL كما هو في الباك إيند
// إزالة الـ /v1 المكررة
      var request = http.MultipartRequest('POST', Uri.parse('${ApiConstants.baseUrl}/service-requests'));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.fields['category_id'] = categoryId.toString();

      // 1. إرسال الأجوبة النصية
      userAnswers.forEach((key, value) {
        if (value is! List<File> && value is! File) {
          request.fields['answers[$key]'] = value.toString();
        }
      });

// 2. إرسال الصور (الحل المزدوج)
      for (var entry in userAnswers.entries) {
        if (entry.value is List<File>) {
          for (File file in entry.value) {

            // الإرسال الأول: عشان يرضي الـ Validation (images[])
            request.files.add(await http.MultipartFile.fromPath(
              'images[]',
              file.path,
            ));

            // الإرسال الثاني: عشان يرضي الـ Service (السطر 56 اللي عم يشتكي)
            // عم نبعت الصورة داخل رقم السؤال نفسه
            request.files.add(await http.MultipartFile.fromPath(
              'answers[${entry.key}]',
              file.path,
            ));

            print("📤 Sent image for question ${entry.key} in both fields");
          }
        }
      }
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        userAnswers.clear(); // تنظيف الأجوبة بعد النجاح
        Get.offAllNamed('/home');
        Get.snackbar("نجاح", "تم إرسال طلبك بنجاح");
      } else {
        // طباعة الخطأ القادم من الباك إيند (Validation Errors)
        print("❌ Server Error: ${response.body}");
        Get.snackbar("خطأ", "لم يتم قبول البيانات، تحقق من الحقول المكتوبة");
      }
    } catch (e) {
      print("❌ Connection Error: $e");
    } finally {
      isLoading.value = false;
    }
  }}*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../core/api_constants.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class QuestionController extends GetxController {
  var isLoading = false.obs;      // للتحميل الأول
  var isPaginating = false.obs;   // لتحميل الصفحات التالية
  var questions = <dynamic>[].obs;
  var userAnswers = <int, dynamic>{}.obs;

  final box = GetStorage();

  // متغيرات الباجينيشن
  int currentPage = 1;
  int lastPage = 1;
  int? currentServiceId;

  // متحكم التمرير
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    // مراقبة التمرير لتحميل الصفحات التالية تلقائياً
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        if (currentServiceId != null && !isPaginating.value && currentPage < lastPage) {
          fetchQuestions(currentServiceId!, isLoadMore: true);
        }
      }
    });
  }

  // دالة جلب الأسئلة مع دعم الباجينيشن
  void fetchQuestions(int serviceId, {bool isLoadMore = false}) async {
    try {
      if (!isLoadMore) {
        currentServiceId = serviceId;
        currentPage = 1;
        questions.clear();
        isLoading(true);
      } else {
        isPaginating(true);
        currentPage++;
      }

      String? token = box.read('token');
      final response = await http.get(
        Uri.parse("${ApiConstants.getCategoryQuestions}$serviceId?page=$currentPage"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print("❓ [Questions API] Response: ${response.body}");
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        List<dynamic> rawList = [];

        if (decodedData['status'] == true && decodedData['data'] != null) {
          var categoryData = decodedData['data'];

          if (categoryData is Map && categoryData.containsKey('questions')) {
            rawList = categoryData['questions'];
          }
        }
        if (isLoadMore) {
          questions.addAll(rawList);
        } else {
          questions.assignAll(rawList);
        }
       // questions.assignAll(rawList);
        print("✅ تم استخراج ${questions.length} سؤال بنجاح.");
      } else {
        print("⚠️ خطأ من السيرفر: ${response.statusCode}");
      }
    } catch (e) {
      if (isLoadMore) currentPage--;
      print("❌ خطأ في الـ Parsing: $e");
    } finally {
      isLoading(false);
      isPaginating(false);
    }
  }

  // تحديث الإجابات
  void updateAnswer(int questionId, dynamic value) {
    userAnswers[questionId] = value;
  }

  // التحقق من الحقول المطلوبة
  bool validateAnswers() {
    for (var q in questions) {
      bool isRequired = q['is_required'] == true || q['is_required'] == 1;
      var answer = userAnswers[q['id']];

      if (isRequired) {
        if (answer == null || answer.toString().trim().isEmpty) {
          Get.snackbar("حقل مطلوب", "يرجى الإجابة على: ${q['question']}",
              backgroundColor: Colors.redAccent, colorText: Colors.white);
          return false;
        }
      }
    }
    return true;
  }

  // اختيار الصور (يدعم اختيار صور متعددة)
  final ImagePicker _picker = ImagePicker();
  Future<void> pickImage(int qId, ImageSource source) async {
    try {
      final List<XFile> pickedFiles = [];
      if (source == ImageSource.gallery) {
        pickedFiles.addAll(await _picker.pickMultiImage());
      } else {
        final XFile? camFile = await _picker.pickImage(source: source);
        if (camFile != null) pickedFiles.add(camFile);
      }

      if (pickedFiles.isNotEmpty) {
        if (userAnswers[qId] is! List<File>) {
          userAnswers[qId] = <File>[];
        }
        for (var xFile in pickedFiles) {
          userAnswers[qId].add(File(xFile.path));
        }
        userAnswers.refresh();
      }
    } catch (e) {
      print("❌ Error picking image: $e");
    }
  }

  // إرسال الطلب النهائي للسيرفر
  /*Future<void> sendRequestToApi(int categoryId) async {
    try {
      isLoading.value = true;
      var request = http.MultipartRequest('POST', Uri.parse('${ApiConstants.baseUrl}/service-requests'));
      request.headers.addAll({
        'Authorization': 'Bearer ${box.read('token')}',
        'Accept': 'application/json',
      });

      request.fields['category_id'] = categoryId.toString();

      userAnswers.forEach((key, value) {
        if (value is! List<File> && value is! File) {
          request.fields['answers[$key]'] = value.toString();
        }
      });

      for (var entry in userAnswers.entries) {
        if (entry.value is List<File>) {
          for (File file in entry.value) {
            request.files.add(await http.MultipartFile.fromPath('images[]', file.path));
            request.files.add(await http.MultipartFile.fromPath('answers[${entry.key}][]', file.path));
          }
        }
      }

      var response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.offAllNamed('/home');
        Get.snackbar("نجاح", "تم إرسال طلبك بنجاح");
      } else {
        print("❌ Server Error: ${response.body}");
        Get.snackbar("خطأ", "فشل إرسال الطلب");
      }
    } finally {
      isLoading.value = false;
    }
  }
*/


  // أضيفي lat و lng كبارامترات للدالة
  Future<void> sendRequestToApi(int categoryId, double lat, double lng) async {
    try {
      isLoading.value = true;
      var request = http.MultipartRequest('POST', Uri.parse('${ApiConstants.baseUrl}/service-requests'));

      request.headers.addAll({
        'Authorization': 'Bearer ${box.read('token')}',
        'Accept': 'application/json',
      });

      // 1. إضافة المعرفات الأساسية والموقع الجغرافي
      request.fields['category_id'] = categoryId.toString();
      request.fields['latitude'] = lat.toString();   // إرسال الـ Latitude
      request.fields['longitude'] = lng.toString(); // إرسال الـ Longitude

      request.fields['lng'] = lng.toString();
     // request.fields['longitude'] = lng.toString();
      // 2. إرسال الأجوبة النصية
      userAnswers.forEach((key, value) {
        if (value is! List<File> && value is! File) {
          request.fields['answers[$key]'] = value.toString();
        }
      });

      // 3. إرسال ملفات الصور
      for (var entry in userAnswers.entries) {
        if (entry.value is List<File>) {
          for (File file in entry.value) {
            request.files.add(await http.MultipartFile.fromPath('images[]', file.path));
            request.files.add(await http.MultipartFile.fromPath('answers[${entry.key}][]', file.path));
          }
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("📤 [Send Request] Status Code: ${response.statusCode}");
      print("📦 [Send Request] Full Response: ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.offAllNamed('/home');
        Get.snackbar("نجاح", "تم إرسال طلبك بنجاح مع تحديد الموقع");
      } else {
        print("❌ Server Error: ${response.body}");
        Get.snackbar("خطأ", "فشل إرسال الطلب للسيرفر");
      }
    } catch (e) {
      print("❌ Connection Error: $e");
      Get.snackbar("خطأ", "تأكد من اتصال الإنترنت");
    } finally {
      isLoading.value = false;
    }
  }
  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}