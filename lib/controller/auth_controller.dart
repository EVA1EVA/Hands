import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled1/controller/provider_setup_controller.dart';
import 'package:untitled1/controller/sub_category_controller.dart';
import '../api/api_service.dart';
import '../core/api_constants.dart';
import '../routes/app_routes.dart';
import 'package:http/http.dart' as http;

import '../view/main_screen.dart';
import '../view/map_picker_screen.dart';
import 'home_controller.dart';

class AuthController extends GetxController {

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var userType = 'user'.obs;
  var otpValues = List.filled(6, "").obs;
  static var token = "".obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final forgotEmailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final box = GetStorage();
    String? savedToken = box.read('token');
    if (savedToken != null && savedToken.isNotEmpty) {
      token.value = savedToken;
      print("🔁 Token restored from storage");
    }
  }

  void login() async {
    if (!_validateLogin()) return;
    isLoading.value = true;

    try {
      Map<String, dynamic> body = {
        "email": emailController.text.trim(),
        "password": passwordController.text,
      };

      final response = await ApiService.loginUser(body);
      final responseData = jsonDecode(response.body);


      if (response.statusCode == 200) {
        String serverToken = "";
        String roleFromServer = "user";

        if (responseData is List && responseData.isNotEmpty) {
          var firstElement = responseData[0];
          if (firstElement is Map) {
            serverToken = firstElement['access_token']?.toString() ??
                firstElement['token']?.toString() ?? "";
          }

          if (responseData.length > 1) {
            String rawRole = responseData[1].toString();
            if (rawRole.contains(':')) {
              roleFromServer = rawRole.split(':').last.trim();
            } else {
              roleFromServer = rawRole;
            }
          }
        }
        else if (responseData is Map) {
          serverToken = responseData['access_token']?.toString() ??
              responseData['token']?.toString() ?? "";

          if (responseData['user'] != null && responseData['user']['role'] != null) {
            roleFromServer = responseData['user']['role'].toString();
          } else if (responseData['role'] != null) {
            roleFromServer = responseData['role'].toString();
          }
        }

        // --- تنفيذ عملية تسجيل الدخول بعد استخراج البيانات ---
        if (serverToken.isNotEmpty) {
          token.value = serverToken;
          final box = GetStorage();
          box.write('token', serverToken);
          print("🎯 FINAL ROLE DETECTED: $roleFromServer");
          userType.value = roleFromServer;

          // حذف الـ HomeController لضمان إعادة بنائه بالبيانات الجديدة
          Get.delete<HomeController>(force: true);
          box.write('role', roleFromServer);

          // التوجيه بناءً على الرول
        //  navigateUserBasedOnRole(roleFromServer);
          Get.to(() => MapPickerScreen(
            onLocationConfirmed: (lat, lng) async {
              // 1. هنا تقومين بإرسال الموقع للباك إند (إذا كان مطلوباً)
              print("📍 Updating location for role: ${userType.value}");
              await updateUserProfileLocation(lat, lng);
              // 2. 🚀 هنا السر: التوجيه بناءً على الرول
              if (userType.value == 'provider') {
                // توجيه مزود الخدمة لشاشة التوثيق
                Get.offAllNamed('/providerSetup'); // تأكدي من اسم الـ Route الخاص بك
              } else {
                print("Full Response: ${response.body}");
                // توجيه المستخدم العادي للصفحة الرئيسية
                Get.offAllNamed('/home');
              }
            },
          ));
          Get.snackbar("نجاح", "أهلاً بك مجدداً ",
              backgroundColor: Colors.green.withOpacity(0.7), colorText: Colors.white);
        } else {
          Get.snackbar("خطأ", "فشل استخراج التوكن من السيرفر");
        }

      } else {
        // --- التعديل الجديد لمعالجة الأخطاء والـ Account Lock بناءً على الـ Service ---
        String errorMsg = "بيانات الدخول غير صحيحة";

        if (responseData is Map && responseData.containsKey('message')) {
          errorMsg = responseData['message'];
        }

        // 1. حالة الحساب المقفل (بناءً على رسالة الـ Exception أو كود 423)
        if (errorMsg.contains('locked') || response.statusCode == 423) {
          Get.defaultDialog(
            title: "حسابك مقيد مؤقتاً",
            middleText: "لقد تجاوزت حد المحاولات المسموح به. تم قفل الحساب لمدة 15 دقيقة لحمايتك، وتم إرسال إيميل تنبيه لك.",
            textConfirm: "فهمت",
            buttonColor: Colors.red,
            confirmTextColor: Colors.white,
            onConfirm: () => Get.back(),
          );
        }
        // 2. حالة الإيميل غير المفعل
        else if (errorMsg.contains('verified')) {
          Get.snackbar("تنبيه", "يرجى تأكيد بريدك الإلكتروني أولاً",
              backgroundColor: Colors.orange, colorText: Colors.white);
        }
        // 3. أي خطأ آخر (بيانات غلط، سيرفر، إلخ)
        else {
          Get.snackbar("خطأ في الدخول", errorMsg,
              backgroundColor: Colors.red.withOpacity(0.7), colorText: Colors.white);
        }
      }
    } catch (e) {
      print("❌ CRITICAL ERROR IN LOGIN: $e");
      Get.snackbar("خطأ", "حدث خطأ غير متوقع في معالجة البيانات");
    } finally {
      isLoading.value = false;
    }
  }

  void register() async {
    if (!_validateRegister()) return;
    isLoading.value = true;
    try {
      Map<String, dynamic> body = {
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text,
        "password_confirmation": confirmPasswordController.text,
        "role": userType.value,
      };
      final response = await ApiService.registerUser(body);
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final box = GetStorage();
        String? regToken = responseData['access_token'] ??
            responseData['token'] ??
            responseData['data']?['token'];
        if (regToken != null && regToken.isNotEmpty) {
          AuthController.token.value = regToken;
          token.value = regToken;
          final box = GetStorage();
          box.write('token', regToken);
          print("✅ REGISTER TOKEN SAVED: ${AuthController.token.value}");
        }
        Get.snackbar("نجاح", responseData['message'] ?? "تم إنشاء الحساب بنجاح");
        box.write('role', userType.value);
        Get.toNamed(AppRoutes.verification);
      } else {
        Get.snackbar("فشل التسجيل", responseData['message'] ?? "يرجى التحقق من البيانات");
      }
    } catch (e) {
      Get.snackbar("خطأ", "مشكلة في الاتصال أثناء التسجيل");
    } finally {
      isLoading.value = false;
    }
  }

  /*void verifyOTP() async {
    String fullOTP = otpValues.join();
    if (fullOTP.length < 6) {
      Get.snackbar("تنبيه", "يرجى إدخال الرمز كاملاً");
      return;
    }

    String targetEmail = emailController.text.trim().isNotEmpty
        ? emailController.text.trim()
        : forgotEmailController.text.trim();

    isLoading.value = true;

    try {
      Map<String, dynamic> body = {"email": targetEmail, "code": fullOTP};
      final response = await ApiService.verifyEmail(body);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final box = GetStorage();

        String? serverToken = responseData['access_token']?.toString() ??
            responseData['token']?.toString() ??
            responseData['data']?['token']?.toString();

        if (serverToken != null && serverToken.isNotEmpty) {
          final box = GetStorage();

          await box.write('token', serverToken); // استخدام await لضمان الكتابة
          token.value = serverToken; // تحديث القيمة التي يراقبها الـ HomeController
          AuthController.token.value = serverToken;
          print(" Token Sync Success: $serverToken");
        } else {
          String? backupToken = box.read('token');
          if (backupToken != null) {
            AuthController.token.value = backupToken;
            token.value = backupToken;
          }
        }

        if (Get.isRegistered<HomeController>()) {
          Get.delete<HomeController>(force: true);
        }

        await Future.delayed(const Duration(milliseconds: 300));

        Get.snackbar("نجاح", "تم تفعيل الحساب بنجاح",
            backgroundColor: Colors.green, colorText: Colors.white);

        String role = responseData['user']?['role']?.toString() ??
            responseData['role']?.toString() ??
            userType.value;
        box.write('role', role);
      //  navigateUserBasedOnRole(role);
        Get.to(() => MapPickerScreen(
          onLocationConfirmed: (lat, lng) async {
            print("📍 Updating location for role: ${userType.value}");

            if (userType.value == 'provider') {
              Get.offAllNamed('/providerSetup');
            } else {
              Get.offAllNamed('/home');
            }
          },
        ));
      } else {
        Get.snackbar("خطأ", responseData['message'] ?? "الرمز غير صحيح");
      }
    } catch (e) {
      print("❌ OTP ERROR: $e");
      Get.snackbar("خطأ", "فشل عملية التحقق");
    } finally {
      isLoading.value = false;
    }
  }*/

  void verifyOTP() async {
    String fullOTP = otpValues.join();
    if (fullOTP.length < 6) {
      Get.snackbar("تنبيه", "يرجى إدخال الرمز كاملاً");
      return;
    }

    String targetEmail = emailController.text.trim().isNotEmpty
        ? emailController.text.trim()
        : forgotEmailController.text.trim();

    isLoading.value = true;

    try {
      Map<String, dynamic> body = {"email": targetEmail, "code": fullOTP};
      final response = await ApiService.verifyEmail(body);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {

        // 🚀 1. استخراج التوكن النهائي وتأمين تخزينه
        String? serverToken = responseData['access_token']?.toString() ??
            responseData['token']?.toString() ??
            responseData['data']?['token']?.toString();

        final box = GetStorage();

        if (serverToken != null && serverToken.isNotEmpty) {
          // await هنا ضرورية جداً لمنع الـ Race Condition
          await box.write('token', serverToken);
          token.value = serverToken;
          AuthController.token.value = serverToken;
          print("✅ Token Sync Success: $serverToken");
        } else {
          // إذا لم يرسل الباك إند توكن في الـ OTP، نعتمد على توكن التسجيل
          String? backupToken = box.read('token');
          if (backupToken != null) {
            AuthController.token.value = backupToken;
            token.value = backupToken;
            print("⚠️ Using Backup Token from Register");
          }
        }

        // 🚀 2. عملية "تنظيف شامل" للذاكرة (Memory Wipe)
        // هذا يضمن أن أي شاشة تُفتح ستضطر لسحب التوكن الجديد الطازج
        Get.delete<HomeController>(force: true);
        Get.delete<SubCategoryController>(force: true);
        Get.delete<ProviderSetupController>(force: true);

        // انتظار بسيط لضمان تفريغ الرام
        await Future.delayed(const Duration(milliseconds: 300));

        Get.snackbar("نجاح", "تم تفعيل الحساب بنجاح",
            backgroundColor: Colors.green, colorText: Colors.white);

        String role = responseData['user']?['role']?.toString() ??
            responseData['role']?.toString() ??
            userType.value;

        await box.write('role', role);

        // 🚀 3. فتح شاشة الخريطة مع "إرسال حقيقي" للموقع
        Get.to(() => MapPickerScreen(
          onLocationConfirmed: (lat, lng) async {
            print("📍 تأكيد الموقع للرول: ${userType.value}");

            // ⚠️ السطر الذي كان مفقوداً! نرسل الموقع للباك إند وننتظر الرد
            await updateUserProfileLocation(lat, lng);

            // بعد حفظ الموقع بنجاح، نقوم بالتوجيه
            if (userType.value == 'provider') {
              Get.offAllNamed('/providerSetup');
            } else {
              Get.offAllNamed('/home');
            }
          },
        ));

      } else {
        Get.snackbar("خطأ", responseData['message'] ?? "الرمز غير صحيح");
      }
    } catch (e) {
      print("❌ OTP ERROR: $e");
      Get.snackbar("خطأ", "فشل عملية التحقق");
    } finally {
      isLoading.value = false;
    }
  }
  void sendPasswordResetCode() async {
    if (forgotEmailController.text.isEmpty || !GetUtils.isEmail(forgotEmailController.text)) {
      Get.snackbar("تنبيه", "يرجى إدخال بريد إلكتروني صحيح");
      return;
    }
    isLoading.value = true;
    try {
      Map<String, dynamic> body = {"email": forgotEmailController.text.trim()};
      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/auth/user/forgot-password"),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json", "Accept": "application/json"},
      );
      if (response.statusCode == 200) {
        Get.snackbar("نجاح", "تم إرسال رمز التحقق لبريدك");
        Get.toNamed(AppRoutes.resetPassword);
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar("خطأ", data['message'] ?? "فشل إرسال الرمز");
      }
    } catch (e) {
      Get.snackbar("خطأ", "تعذر الاتصال بالسيرفر");
    } finally {
      isLoading.value = false;
    }
  }

  void resetPassword() async {
    String code = otpValues.join();
    if (code.length < 6 || newPasswordController.text.isEmpty) {
      Get.snackbar("تنبيه", "أكمل البيانات المطلوبة");
      return;
    }
    isLoading.value = true;
    try {
      Map<String, dynamic> body = {
        "email": forgotEmailController.text.trim(),
        "code": code,
        "password": newPasswordController.text,
        "password_confirmation": confirmNewPasswordController.text,
      };
      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/auth/user/reset-password"),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json", "Accept": "application/json"},
      );
      if (response.statusCode == 200) {
        Get.snackbar("نجاح", "تم تغيير كلمة المرور");
        Get.offAllNamed(AppRoutes.login);
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar("خطأ", data['message'] ?? "فشل تحديث كلمة المرور");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ غير متوقع");
    } finally {
      isLoading.value = false;
    }
  }

  void sendPasswordResetCodeForVerification() async {
    String emailToSend = forgotEmailController.text.isNotEmpty
        ? forgotEmailController.text.trim()
        : emailController.text.trim();

    if (emailToSend.isEmpty) {
      Get.snackbar("تنبيه", "البريد الإلكتروني غير موجود");
      return;
    }

    isLoading.value = true;
    try {
      Map<String, dynamic> body = {"email": emailToSend};
      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/auth/user/forgot-password"),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json", "Accept": "application/json"},
      );

      if (response.statusCode == 200) {
        Get.snackbar("نجاح", "تم إعادة إرسال رمز التحقق لبريدك");
        otpValues.value = List.filled(6, "");
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar("خطأ", data['message'] ?? "فشل إرسال الرمز");
      }
    } catch (e) {
      Get.snackbar("خطأ", "تعذر الاتصال بالسيرفر");
    } finally {
      isLoading.value = false;
    }
  }

  void resendOTP() async {
    String targetEmail = emailController.text.trim().isNotEmpty
        ? emailController.text.trim()
        : forgotEmailController.text.trim();

    if (targetEmail.isEmpty) {
      Get.snackbar("تنبيه", "لا يوجد بريد إلكتروني لإرسال الرمز");
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/auth/user/forgot-password"),
        body: jsonEncode({"email": targetEmail}),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        otpValues.value = List.filled(6, "");

        Get.snackbar(
          "نجاح",
          "تم إرسال رمز جديد إلى $targetEmail",
          backgroundColor: Colors.green.withOpacity(0.7),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar("خطأ", data['message'] ?? "فشل إعادة الإرسال");
      }
    } catch (e) {
      Get.snackbar("خطأ", "مشكلة في الاتصال بالسيرفر");
    } finally {
      isLoading.value = false;
    }
  }
  void navigateUserBasedOnRole(String role) {
    userType.value = role;
    if (role.trim().toLowerCase() == 'provider') {
      Get.offAllNamed(AppRoutes.providerSetup);
    } else {
      Get.offAllNamed(AppRoutes.home);
    }
  }

  Future<bool> refreshToken() async {
    if (token.value.isEmpty) return false;
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.refresh),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        token.value = data['token'] ?? "";
        return true;
      }
      return false;
    } catch (e) { return false; }
  }

  void updateOTP(int index, String value) => otpValues[index] = value;
  void setUserType(String type) => userType.value = type;
  void togglePasswordVisibility() => isPasswordVisible.value = !isPasswordVisible.value;

  bool _validateLogin() {
    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar("تنبيه", "البريد الإلكتروني غير صحيح");
      return false;
    }
    return passwordController.text.length >= 8;
  }

  bool _validateRegister() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar("تنبيه", "الاسم مطلوب");
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar("تنبيه", "كلمات المرور غير متطابقة");
      return false;
    }
    return _validateLogin();
  }

  Future<void> updateUserProfileLocation(double lat, double lng) async {
    try {
      isLoading.value = true;
      final box = GetStorage();

      String? savedToken = box.read('token') ?? token.value;
      String currentRole = box.read('role') ?? userType.value;

      print("📍 Updating location for role: $currentRole");

      var response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/set/location'),
        headers: {
          'Authorization': 'Bearer $savedToken',
          'Accept': 'application/json',
        },
        body: {
          'lat': lat.toString(),
          'lng': lng.toString(),

        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        userType.value = currentRole;

        if (currentRole.trim().toLowerCase() == 'provider') {
          Get.delete<HomeController>(force: true);
          Get.delete<SubCategoryController>(force: true);

          await box.write('token', savedToken);
          Get.offAllNamed(AppRoutes.providerSetup);
        } else {
          Get.offAllNamed(AppRoutes.home);
        }

        Get.snackbar("نجاح", "تم حفظ موقعك بنجاح",
            backgroundColor: Colors.green.withOpacity(0.7), colorText: Colors.white);
      } else {
        final responseData = jsonDecode(response.body);
        Get.snackbar("خطأ", responseData['message'] ?? "فشل تحديث الموقع",
            backgroundColor: Colors.red.withOpacity(0.7), colorText: Colors.white);
      }
    } catch (e) {
      print("❌ LOCATION UPDATE ERROR: $e");
      Get.snackbar("خطأ", "تعذر الاتصال بالسيرفر لتحديث الموقع");
    } finally {
      isLoading.value = false;
    }
  }


  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

}

