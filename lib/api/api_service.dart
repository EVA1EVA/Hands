import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_constants.dart';

class ApiService {
  static Future<http.Response> registerUser(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.register),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );
      return response;
    } catch (e) {
      throw Exception("فشل الاتصال بالسيرفر: $e");
    }
  }
  // دالة تسجيل الدخول
  static Future<http.Response> loginUser(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );
      return response;
    } catch (e) {
      throw Exception("فشل الاتصال بالسيرفر: $e");
    }
  }
  // دالة تحقق الإيميل (OTP)
  static Future<http.Response> verifyEmail(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.verifyEmail),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );
      return response;
    } catch (e) {
      throw Exception("فشل الاتصال بالسيرفر: $e");
    }
  }
}