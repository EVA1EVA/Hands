/*import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/api_constants.dart';
import 'auth_controller.dart';

class SubCategoryController extends GetxController {
  var isLoading = true.obs;
  var subCategories = [].obs;

  // جلب الفئات الفرعية بناءً على ID الفئة الأب
  void fetchSubCategories(int parentId) async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse("${ApiConstants.baseUrl}/categories/$parentId/sub"),
        headers: {
          'Authorization': 'Bearer ${AuthController.token.value}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // بناءً على هيكلية لارافيل، البيانات غالباً تكون داخل مفتاح 'data' أو مباشرة
        subCategories.value = data['data'] ?? data;
      } else {
        Get.snackbar("خطأ", "فشل جلب البيانات من السيرفر");
      }
    } catch (e) {
      Get.snackbar("خطأ", "تأكد من اتصالك بالإنترنت");
    } finally {
      isLoading.value = false;
    }
  }
}*/



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/api_constants.dart';
import 'auth_controller.dart';

class SubCategoryController extends GetxController {
  var subCategories = <dynamic>[].obs;
  var isLoading = false.obs;
  var isPaginating = false.obs;

  int currentPage = 1;
  int lastPage = 1;
  int? currentParentId;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        if (currentParentId != null) {
          fetchSubCategories(currentParentId!, isLoadMore: true);
        }
      }
    });
  }

  Future<void> fetchSubCategories(int parentId, {bool isLoadMore = false}) async {

    if (currentParentId != parentId && !isLoadMore) {
      currentParentId = parentId;
      currentPage = 1;
      subCategories.clear();
      isLoading.value = true;
    }
    else if (isLoadMore) {
      if (isPaginating.value || currentPage >= lastPage) return;
      currentPage++;
      isPaginating.value = true;
    } else {
      currentPage = 1;
      isLoading.value = true;
    }

    try {
      final box = GetStorage();
      String? token = box.read('token');

      if (token == null || token.isEmpty) {
        print("⚠ لا يوجد توكن مخزن، سنحاول جلب التوكن من AuthController");
        token = AuthController.token.value;
      }
      final response = await http.get(
        Uri.parse("${ApiConstants.baseUrl}/categories/$parentId/sub?page=$currentPage"),
        headers: {
        //  'Authorization': 'Bearer ${AuthController.token.value}',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      print("🔍 [SubCategory Debug]");
      print("📂 Parent ID: $parentId | Page: $currentPage");
      print("📦 Body: ${response.body}");
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        List<dynamic> rawList =[];

        if (decodedData is List) {
          rawList = decodedData;
        } else if (decodedData is Map) {
          if (decodedData.containsKey('data')) {
            var dataField = decodedData['data'];
            if (dataField is List) {
              rawList = dataField;
              lastPage = decodedData['meta']?['last_page'] ?? decodedData['last_page'] ?? 1;
            } else if (dataField is Map && dataField.containsKey('data')) {
              var innerData = dataField['data'];
              if (innerData is List) {
                rawList = innerData;
              }
              lastPage = dataField['last_page'] ?? dataField['meta']?['last_page'] ?? 1;
            }
          }
        }

        if (isLoadMore) {
          subCategories.addAll(rawList);
        } else {
          subCategories.assignAll(rawList);
        }

        print("✅ تم استخراج ${rawList.length} فئة فرعية بنجاح.");
      } else {
        Get.snackbar("خطأ", "فشل جلب البيانات من السيرفر", backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      print(" Error SubCategories: $e");
      if (isLoadMore) currentPage--;
      Get.snackbar("خطأ", "حدث خطأ أثناء معالجة البيانات", backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
      isPaginating.value = false;
    }
  }
  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}