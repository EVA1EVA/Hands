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
        Uri.parse('${ApiConstants.baseUrl}/provider/requests'), // تأكدي إن v1 مو مكررة هون
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      // تحويل البيانات القادمة
      var decodedData = json.decode(response.body);

      if (response.statusCode == 200) {
        // ✅ فحص نوع البيانات قبل الإسناد
        if (decodedData is List) {
          availableRequests.assignAll(decodedData);
        } else {
          // إذا السيرفر بعت Map (يعني رسالة خطأ مثل select cat first)
          availableRequests.clear();
          print("⚠️ السيرفر طلب متطلبات إضافية: ${decodedData['original']}");

          // تنبيه لليوزر (البروفايدر) يروح يكمل ملفه
          Get.snackbar("تنبيه", "يرجى تحديد تخصصاتك من الملف الشخصي أولاً");
        }
      }
    } catch (e) {
      print("❌ Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
  // تقديم عرض (v1/offers) - Logic Layer
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
        Uri.parse('${ApiConstants.baseUrl}/v1/offers'),
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