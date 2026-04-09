import 'package:get/get.dart';
import '../view/ForgotPasswordScreen.dart';
import '../view/ResetPasswordScreen.dart';
import '../view/splash_screen.dart';
import '../view/login_screen.dart';
import '../view/register_screen.dart';
import '../view/verification_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String verification = '/verification';
  static const String forgotPassword = '/forgotPassword';
  static const String resetPassword = '/resetPassword';

  static final routes = [

    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: register, page: () => const RegisterScreen()),
    GetPage(name: verification, page: () => const VerificationScreen()),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(name: resetPassword, page: () => const ResetPasswordScreen()),
  ];
}