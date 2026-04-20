import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as box;
import '../api/api_service.dart';
import '../core/api_constants.dart';
import 'auth_controller.dart';

class HomeController extends GetxController {
  var userRole = 'user'.obs;
  var isProviderVerified = false.obs;
  var categories = <Map<String, dynamic>>[].obs;
  var availableRequests = <Map<String, dynamic>>[].obs;

  var isLoading = false.obs; // للتحميل الأولي
  var isPaginating = false.obs; // للباجينيشن

  // 3. محددات الصفحات
  int currentPage = 1;
  int lastPage = 1;

  // 4. القلب النابض للباجينيشن
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getVerificationStatus();
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        loadCategories(isLoadMore: true);
      }
    });
    final box = GetStorage();
    //String? freshToken = GetStorage().read('token');
    String? freshToken = box.read('token');
    if (freshToken != null && freshToken.isNotEmpty) {
      AuthController.token.value = freshToken;
      loadCategories();
    }
    else {
      // إذا كان الحساب جديداً والتوكن لم يُخزن بعد، ننتظر أول قيمة تسند للتوكن
      once(AuthController.token, (String value) {
        if (value.isNotEmpty) {
          loadCategories();
        }
      });
    }
    if (Get.isRegistered<AuthController>()) {
      userRole.value = Get.find<AuthController>().userType.value;
    }



   /* ever(AuthController.token, (value) {
      if (value.isNotEmpty) {
        currentPage = 1;
        categories.clear();
        loadCategories();
      }
    });
  }*/
  }


  Future<void> loadCategories({bool isLoadMore = false}) async {
    if (AuthController.token.value.isEmpty) {
      String? storedToken = GetStorage().read('token');
      if (storedToken != null&& storedToken.isNotEmpty) {
        AuthController.token.value = storedToken;
      } else {
        print("🚫 لا يوجد توكن، لن يتم جلب التصنيفات");
        return;
      }
    }
    if (isLoadMore) {
      if (isPaginating.value || currentPage >= lastPage) return;
      currentPage++;
      isPaginating.value = true;
    } else {
      currentPage = 1;
      isLoading.value = true;
    }

    try {
      String endpoint = ApiConstants.getCategories.contains('?')
          ? '${ApiConstants.getCategories}&page=$currentPage'
          : '${ApiConstants.getCategories}?page=$currentPage';
      final response = await ApiService.get(endpoint);
      print("🌐 [Pagination Debug] Response Body: ${response.body}");
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        List<dynamic> rawList =[];

        // 🚀 محرك الاستخراج الذكي (Smart JSON Parser)
        if (decodedData is List) {
          // السيناريو 1: بدون باجينيشن (مصفوفة مباشرة)
          rawList = decodedData;
        } else if (decodedData is Map) {
          if (decodedData.containsKey('data')) {
            var dataField = decodedData['data'];

            if (dataField is List) {
              // السيناريو 2: باجينيشن قياسي من Laravel
              rawList = dataField;
              // محاولة سحب رقم الصفحة الأخيرة من meta أو من الجذر
              lastPage = decodedData['meta']?['last_page'] ?? decodedData['last_page'] ?? 1;
            }
            else if (dataField is Map && dataField.containsKey('data')) {
              // السيناريو 3 (سبب الخطأ عندك): تغليف مزدوج! الباجينيشن داخل كائن data
              var innerData = dataField['data'];
              if (innerData is List) {
                rawList = innerData;
              }
              lastPage = dataField['last_page'] ?? dataField['meta']?['last_page'] ?? 1;
            }
          }
        }

        // تحويل البيانات المستخرجة
        var newItems = rawList.map((e) => e as Map<String, dynamic>).toList();

        if (isLoadMore) {
          categories.addAll(newItems);
        } else {
          categories.assignAll(newItems);
        }

        print("✅ تم استخراج ${newItems.length} تصنيف بنجاح. الصفحة الحالية: $currentPage من $lastPage");

      } else {
        print("⚠️ خطأ من السيرفر: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ خطأ في تحويل البيانات (Parsing): $e");
      if (isLoadMore) currentPage--;
    } finally {
      isLoading.value = false;
      isPaginating.value = false;
    }
  }
  Future<void> getVerificationStatus() async {
    String? token = GetStorage().read('token');

    // نرسل طلب للباك إند لنعرف معلومات المستخدم
    var response = await box.get(
      Uri.parse('${ApiConstants.baseUrl}/user/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // إذا كان الحقل في لارافل فيه تاريخ، نغير المفتاح لـ true
      isProviderVerified.value = data['provider_verified_at'] != null;
    }
  }
  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}