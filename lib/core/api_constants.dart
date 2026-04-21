class ApiConstants {
  static const String baseUrl = "http://192.168.1.113:8000/api/v1";
  static const String register = "$baseUrl/auth/user/register";
  static const String login = "$baseUrl/auth/user/login";
  static const String verifyEmail = "$baseUrl/auth/user/verify-email";
  static const String getCategories = "$baseUrl/categories";
  static const String getMainCategories = "$baseUrl/categoriey/main";
  static const String getCategoryQuestions = "$baseUrl/categories_questions/";
  static const String refresh = "$baseUrl/auth/user/refresh";
  static const String userOffers = "$baseUrl/user/offers";
}