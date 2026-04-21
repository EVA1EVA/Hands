import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../core/api_constants.dart';

class UserOffersController extends GetxController {
  var isLoading = true.obs;
  var isPaginating = false.obs;
  var offers = [].obs;
  int currentPage = 1;
  bool hasMoreData = true;
  final ScrollController scrollController = ScrollController();
  final storage = GetStorage();

  @override
  void onInit() {
    fetchOffers();
    // مراقبة التمرير لتفعيل الباجينيشن عند الوصول للقاع
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        loadMoreOffers();
      }
    });
    super.onInit();
  }

  // الدالة الأساسية لجلب البيانات
  Future<void> fetchOffers() async {
    try {
      isLoading(true);
      currentPage = 1;
      hasMoreData = true;

      // 💡 التصحيح: دمج الـ BaseUrl مع المسار المطلوب بشكل صحيح
      final String url = "${ApiConstants.baseUrl}/user/offers?page=$currentPage";
      final String? token = storage.read('token');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        // 💡 انظري للـ Log الخاص بك:
        // الهيكل هو: {"status":true, "data": {"current_page":1, "data": [...]}}
        // لذا الوصول الصحيح للقائمة هو:
        final List fetchedList = decodedData['data']['data'];

        offers.assignAll(fetchedList);

        // تحديث حالة الباجينيشن
        if (fetchedList.length < 10) {
          hasMoreData = false;
        }
      }else {
        debugPrint("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching offers: $e");
      Get.snackbar("خطأ في الاتصال", "تأكدي من تشغيل السيرفر والاتصال بنفس الشبكة");
    } finally {
      isLoading(false); // 💡 ضمان توقف التحميل مهما حدث
    }
  }

  // دالة تحميل الصفحات التالية (Pagination)
  Future<void> loadMoreOffers() async {
    if (isPaginating.value || !hasMoreData) return;

    try {
      isPaginating(true);
      currentPage++;

      final String url = "${ApiConstants.baseUrl}/user/offers?page=$currentPage";
      final String? token = storage.read('token');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        final List newData = decodedData['data'];

        if (newData.isEmpty) {
          hasMoreData = false;
        } else {
          offers.addAll(newData);
          if (newData.length < 10) hasMoreData = false;
        }
      }
    } catch (e) {
      currentPage--;
      debugPrint("Pagination Error: $e");
    } finally {
      isPaginating(false);
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}