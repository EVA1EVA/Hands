/*import 'package:get/get.dart';
import '../view/splash_screen.dart';
import '../view/login_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';

  static List<GetPage> routes = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: login,
      page: () =>  LoginScreen(),
      transition: Transition.fadeIn, // إضافة تأثير انتقال سلس
    ),
  ];
}*/
import 'package:get/get.dart';
import '../view/login_screen.dart';
import '../view/register_screen.dart';
import '../view/splash_screen.dart';
import '../view/verification_screen.dart';

class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const verification = '/verification';
  static final routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: register, page: () => RegisterScreen()),
    GetPage(name: verification, page: () => const VerificationScreen()),
  ];
}