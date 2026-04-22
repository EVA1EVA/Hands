/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../core/api_constants.dart';

class UserOffersController extends GetxController {
  var isLoading = true.obs;
  var isPaginating = false.obs;
  var offers = <dynamic>[].obs;
  int currentPage = 1;
  bool hasMoreData = true;
  final ScrollController scrollController = ScrollController();
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    print("🚀 UserOffersController Initialized");
    fetchOffers();

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        loadMoreOffers();
      }
    });
  }

  Future<void> fetchOffers() async {
    print("📡 [DEBUG] Attempting to fetch offers using existing backend routes...");
    try {
      isLoading(true);
      currentPage = 1;
      hasMoreData = true;

      final String? token = storage.read('token');

      // 🚀 التعديل الجوهري هنا: تغيير الرابط ليتوافق مع الـ api.php الموجود
      // جربنا 'offers/my' لأنه المسار المعرف في ملفك لجلب العروض
      final String url = "${ApiConstants.baseUrl}/offers/my?page=$currentPage";

      print("🌐 Calling URL: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      print("📥 [OFFERS RAW DATA]: ${response.body}");

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        List<dynamic> fetchedList = [];

        // لارفل غالباً يرجع البيانات في حقل 'data'
        var dataField = decodedData['data'];

        if (dataField is List) {
          fetchedList = dataField;
          hasMoreData = false;
        } else if (dataField is Map && dataField['data'] is List) {
          fetchedList = dataField['data'];
          hasMoreData = dataField['next_page_url'] != null;
        }

        offers.assignAll(fetchedList);
        print("✅ Successfully loaded ${offers.length} offers");
      } else {
        print("⚠️ Server Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("❌ Exception in fetchOffers: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadMoreOffers() async {
    if (isPaginating.value || !hasMoreData) return;

    try {
      isPaginating(true);
      currentPage++;
      final String? token = storage.read('token');
      // 🚀 نفس تعديل الرابط هنا أيضاً
      final String url = "${ApiConstants.baseUrl}/offers/my?page=$currentPage";

      final response = await http.get(Uri.parse(url), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        List<dynamic> newData = [];
        var dataField = decodedData['data'];

        if (dataField is List) {
          newData = dataField;
          hasMoreData = false;
        } else if (dataField is Map && dataField['data'] is List) {
          newData = dataField['data'];
          hasMoreData = dataField['next_page_url'] != null;
        }

        if (newData.isNotEmpty) offers.addAll(newData);
      }
    } catch (e) {
      print("❌ Pagination Error: $e");
      currentPage--;
    } finally {
      isPaginating(false);
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../core/api_constants.dart';

class UserOffersController extends GetxController {
  var isLoading = true.obs;
  var myOffers = <dynamic>[].obs;
  var nearbyOffers = <dynamic>[].obs;
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchAllOffers();
  }

  Future<void> fetchAllOffers() async {
    try {
      isLoading(true);
      // 💡 السطرين السحريين لحل المشكلة:
      myOffers.clear();
      nearbyOffers.clear();
      final String? token = storage.read('token');

      if (token == null) {
        isLoading(false);
        return;
      }
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final results = await Future.wait([
        http.get(Uri.parse("${ApiConstants.baseUrl}/offers/my"), headers: headers),
        http.get(Uri.parse("${ApiConstants.baseUrl}/offers/nearby"), headers: headers),
      ]);

      // معالجة عروضي الخاصة مع فحص الـ Pagination
      if (results[0].statusCode == 200) {
        var decoded = jsonDecode(results[0].body);
        var data = decoded['data'];
        if (data is Map && data.containsKey('data')) {
          myOffers.assignAll(data['data']); // حالة الـ Pagination
        } else {
          myOffers.assignAll(data is List ? data : []); // حالة المصفوفة العادية
        }
      }

      // معالجة العروض القريبة مع فحص الـ Pagination
      if (results[1].statusCode == 200) {
        var decoded = jsonDecode(results[1].body);
        var data = decoded['data'];
        if (data is Map && data.containsKey('data')) {
          nearbyOffers.assignAll(data['data']);
        } else {
          nearbyOffers.assignAll(data is List ? data : []);
        }
      }
    } catch (e) {
      debugPrint("❌ Error in fetchAllOffers: $e");
    } finally {
      isLoading(false);
    }
  }
}
