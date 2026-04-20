/*import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../core/api_constants.dart';

class ApiClient {
  final GetStorage _box = GetStorage();

  // 🔥 GET request
  Future<http.Response> get(String url) async {
    final token = _box.read('token');

    return await http.get(
      Uri.parse(url),
      headers: _headers(token),
    );
  }

  // 🔥 POST request
  Future<http.Response> post(String url, dynamic body) async {
    final token = _box.read('token');

    return await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: _headers(token),
    );
  }

  // 🔥 Headers auto include token
  Map<String, String> _headers(String? token) {
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null && token.isNotEmpty)
        "Authorization": "Bearer $token",
    };
  }
}*/
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../core/api_constants.dart';

class ApiClient {
  final GetStorage _box = GetStorage();

  Future<http.Response> get(String url) async {
    var response = await _get(url);
    if (response.statusCode == 401) {
      final refreshed = await _tryRefresh();
      if (refreshed) return await _get(url);
      _logout();
    }
    return response;
  }

  Future<http.Response> post(String url, dynamic body) async {
    var response = await _post(url, body);
    if (response.statusCode == 401) {
      final refreshed = await _tryRefresh();
      if (refreshed) return await _post(url, body);
      _logout();
    }
    return response;
  }

  Future<http.Response> _get(String url) async {
    return await http.get(Uri.parse(url), headers: _headers());
  }

  Future<http.Response> _post(String url, dynamic body) async {
    return await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: _headers(),
    );
  }

  Map<String, String> _headers() {
    final token = _box.read<String>('token') ?? '';
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  Future<bool> _tryRefresh() async {
    final token = _box.read<String>('token') ?? '';
    if (token.isEmpty) return false;

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.refresh),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newToken = data['access_token'] ?? data['token'] ?? '';
        if (newToken.isNotEmpty) {
          _box.write('token', newToken);
          try {
            final auth = Get.find<dynamic>(tag: 'auth');
            auth.token.value = newToken;
          } catch (_) {}
          return true;
        }
      }
    } catch (_) {}

    return false;
  }


  void _logout() {
    _box.erase();
    Get.offAllNamed('/login');
    Get.snackbar("انتهت الجلسة", "يرجى تسجيل الدخول من جديد");
  }
}