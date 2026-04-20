import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/api_constants.dart';
import 'package:get_storage/get_storage.dart';

class ProviderRequestsController extends GetxController {
  var isLoading = false.obs;
  var availableRequests = <dynamic>[].obs;
  final box = GetStorage();

  @override
  void onInit() {
    fetchAvailableRequests();
    super.onInit();
  }
  Future<void> fetchAvailableRequests() async {
    try {
      isLoading.value = true;
      String? token = box.read('token');

      var response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/provider/requests'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("Full Backend Response: ${response.body}"); // للبحث عن الـ data

      if (response.statusCode == 200) {
        var decodedData = json.decode(response.body);

        // الباك إند يغلف البيانات بـ ApiResponse::success (حقل data)
        // والباجينيشن يغلفها مرة أخرى بـ (حقل data)
        if (decodedData['status'] == true) {
          var paginationData = decodedData['data']; // هذا كائن الباجينيشن

          if (paginationData != null && paginationData['data'] is List) {
            List<dynamic> requests = paginationData['data'];
            availableRequests.assignAll(requests);
          } else {
            availableRequests.clear();
            print("⚠️ لا توجد طلبات في المصفوفة");
          }
        } else {
          // إذا كان السيرفر أرسل 'select cat first' أو غيره
          Get.snackbar("تنبيه", decodedData['message'] ?? "يرجى إكمال البيانات");
        }
      }
    } catch (e) {
      print("❌ Error: $e");
    } finally {
      isLoading.value = false;
    }
  }  // تقديم عرض (v1/offers) - Logic Layer
  Future<void> submitOffer({
    required int requestId,
    required String minPrice,
    required String maxPrice,
    required String message,
  }) async {
    // التحقق من المنطق قبل الإرسال (حسب شروط الباك إيند)
    double? min = double.tryParse(minPrice);
    double? max = double.tryParse(maxPrice);

    if (min == null || max == null) {
      Get.snackbar("خطأ", "يرجى إدخال أرقام صحيحة للأسعار");
      return;
    }

    if (min > max) {
      Get.snackbar("تنبيه", "يجب أن يكون السعر الأدنى أقل من أو يساوي السعر الأقصى");
      return;
    }

    try {
      isLoading.value = true;
      String? token = box.read('token');

      var response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/offers'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {
          'service_request_id': requestId.toString(),
          'min_price': min.toString(),
          'max_price': max.toString(),
          'message': message,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(); // إغلاق الـ BottomSheet
        Get.snackbar("نجاح", "تم إرسال عرضك بنجاح");
        fetchAvailableRequests(); // تحديث القائمة
      } else {
        var errorData = json.decode(response.body);
        Get.snackbar("خطأ", errorData['message'] ?? "فشل تقديم العرض");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ في الاتصال بالسيرفر");
    } finally {
      isLoading.value = false;
    }
  }
}