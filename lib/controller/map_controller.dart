/*import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';

class MapPickerOptionsController extends GetxController {
  // الموقع الافتراضي (دمشق)
  var selectedLocation = const LatLng(33.5138, 36.2765).obs;
  var addressName = "جاري جلب العنوان...".obs; // متغير جديد للعنوان


  final MapController mapController = MapController();
  var isLoadingLocation = false.obs;

  @override
  void onInit() {
    super.onInit();
    determinePosition();
  }

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      isLoadingLocation.value = true;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar("خدمة الموقع", "يرجى تفعيل الـ GPS");
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );

      LatLng currentLatLng = LatLng(position.latitude, position.longitude);

      // تحديث القيمة وتحريك الكاميرا
      selectedLocation.value = currentLatLng;
      mapController.move(currentLatLng, 16.0);

    } catch (e) {
      Get.snackbar("خطأ", "تعذر جلب موقعك الحالي");
    } finally {
      isLoadingLocation.value = false;
    }
  }


  Future<void> getAddressFromLatLng(LatLng position) async {
    try {
      // الطريقة الصحيحة لضبط اللغة العربية في الإصدارات الحديثة
      await setLocaleIdentifier("ar");

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // بناء العنوان بشكل مفصل (شارع - حي - منطقة)
        String name = place.street ?? "";
        String subLocality = place.subLocality ?? "";
        String locality = place.locality ?? "";

        addressName.value = "$name, $subLocality, $locality"
            .replaceAll(", ,", ",") // تنظيف النص من الفواصل الزائدة
            .trim();

        if (addressName.value.startsWith(",")) {
          addressName.value = addressName.value.substring(1).trim();
        }
      }
    } catch (e) {
      addressName.value = "تعذر تحديد اسم الموقع بدقة";
      print("Geocoding Error: $e");
    }
  }

  void updateLocation(LatLng newPos) {
    selectedLocation.value = newPos;
    print("📍 الموقع الحالي في الكنترولر: ${newPos.latitude}, ${newPos.longitude}");
    getAddressFromLatLng(newPos); // استدعاء جلب العنوان

  }



}*/
import 'dart:async';
import 'dart:convert'; // 🚀 نحتاجه للتعامل مع الـ JSON
import 'package:http/http.dart' as http; // 🚀 نحتاجه للاتصال بالسيرفر
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';

class MapPickerOptionsController extends GetxController {
  var selectedLocation = const LatLng(33.5138, 36.2765).obs;
  var addressName = "جاري جلب العنوان...".obs;

  final MapController mapController = MapController();
  var isLoadingLocation = false.obs;

  Timer? _debounce;

  @override
  void onReady() {
    super.onReady();
    determinePosition();
  }

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      isLoadingLocation.value = true;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar("خدمة الموقع", "يرجى تفعيل الـ GPS في جهازك");
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar("صلاحيات", "تم رفض الوصول للموقع، فعلها من الإعدادات");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );

      selectedLocation.value = LatLng(position.latitude, position.longitude);
      mapController.move(selectedLocation.value, 16.0);

      _getAddressFromLatLng(selectedLocation.value);

    } catch (e) {
      print("❌ فشل جلب الموقع: $e");
    } finally {
      isLoadingLocation.value = false;
    }
  }

  void updateLocation(LatLng newPos) {
    selectedLocation.value = newPos;
    addressName.value = "جاري البحث عن العنوان...";

    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 800), () {
      _getAddressFromLatLng(newPos);
    });
  }


  // 🚀 المحرك الجديد (OpenStreetMap API) البديل عن مكتبة Geocoding
// 🚀 المحرك الجديد (OpenStreetMap API) بدقة عالية (Precision Geocoding)
  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&zoom=18&addressdetails=1'
      );

      final response = await http.get(url, headers: {
        'Accept-Language': 'ar',
        'User-Agent': 'com.hands.app',
      });

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        if (decodedData != null && decodedData['address'] != null) {
          final address = decodedData['address'];

          // 🚀 استخراج دقيق جداً (نبدأ من الأصغر للأكبر)
          String street = address['road'] ?? address['pedestrian'] ?? address['path'] ?? '';

          // البحث عن أصغر تجمع سكني (حي، قرية، بلدة)
          String localArea = address['neighbourhood'] ??
              address['suburb'] ??
              address['village'] ??
              address['hamlet'] ??
              address['town'] ?? '';

          // البحث عن المدينة أو المحافظة
          String cityOrState = address['city'] ??
              address['state'] ??
              address['region'] ?? '';

          // تجميع الأجزاء المكتشفة بذكاء
          List<String> parts = [];

          if (street.isNotEmpty) parts.add(street);
          if (localArea.isNotEmpty && localArea != street) parts.add(localArea); // منع التكرار
          if (cityOrState.isNotEmpty && cityOrState != localArea) parts.add(cityOrState);

          if (parts.isNotEmpty) {
            addressName.value = parts.join('، ');
          } else {
            // إذا فشل كل شيء، نأخذ أول جزءين من الـ display_name المعروض من السيرفر
            String fallback = decodedData['display_name'] ?? "موقع غير معروف";
            List<String> fallbackParts = fallback.split(',');
            if (fallbackParts.length > 2) {
              // نأخذ أدق تفصيلين فقط بدلاً من السلسلة الطويلة المزعجة
              addressName.value = "${fallbackParts[0]}, ${fallbackParts[1]}";
            } else {
              addressName.value = fallback;
            }
          }

          print("✅ العنوان المكتشف (OSM Precision): ${addressName.value}");
        } else {
          addressName.value = "منطقة غير مسجلة بالخريطة";
        }
      } else {
        addressName.value = "تعذر الاتصال بخادم الخرائط";
      }
    } catch (e) {
      print("❌ خطأ API الخرائط: $e");
      addressName.value = "موقع غير محدد";
    }
  }
}