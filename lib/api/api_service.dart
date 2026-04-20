import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../core/api_constants.dart';
import 'api_client.dart';

class ApiService {
  static final ApiClient _client = ApiClient();

  // ================= AUTH =================

  static Future<http.Response> registerUser(Map<String, dynamic> data) {
    return http.post(
      Uri.parse(ApiConstants.register),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> loginUser(Map<String, dynamic> data) {
    return http.post(
      Uri.parse(ApiConstants.login),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> verifyEmail(Map<String, dynamic> data) {
    return http.post(
      Uri.parse(ApiConstants.verifyEmail),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );
  }

  // ================= AUTO AUTH =================
/*
  static Future<http.Response> get(String url) {
    return _client.get(url);
  }*/
  static Future<http.Response> get(String url) async {
    final box = GetStorage();
    // 1. تأكدي من قراءة التوكن المخزن بعد اللوكن الجديد
    String? token = box.read('token');

    print("🔑 SENDING TOKEN: $token"); // سطر للتأكد من وجود التوكن في اللوج

    return await http.get(
      Uri.parse(url),
      headers: {
        // 2. أهم سطرين لإقناع السيرفر بعدم التحويل لصفحة HTML
        'Accept': 'application/json',
        'Content-Type': 'application/json',

        // 3. إرسال الهوية (التوكن)
        'Authorization': 'Bearer $token',
      },
    );
  }

  static Future<http.Response> post(String url, Map<String, dynamic> data) {
    return _client.post(url, data);
  }
}