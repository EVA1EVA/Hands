import 'package:get/get.dart';
import 'package:untitled1/view/provider_setup_screen.dart';
import '../AppBindings/initial_binding.dart';
import '../view/auth/ForgotPasswordScreen.dart';
import '../view/auth/ResetPasswordScreen.dart';
import '../view/provider_requests_screen.dart';
import '../view/splash_screen.dart';
import '../view/auth/login_screen.dart';
import '../view/auth/register_screen.dart';
import '../view/auth/verification_screen.dart';
import '../view/home_screen.dart';
class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String verification = '/verification';
  static const String forgotPassword = '/forgotPassword';
  static const String resetPassword = '/resetPassword';
  static const String home = '/home';
  static const String providerSetup = '/providerSetup';
  static const String ProviderRequests= '/ProviderRequests';


  static final routes = [

    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(name: login, page: () => const LoginScreen(),binding: AuthBinding(),),
    GetPage(name: register, page: () => const RegisterScreen()),
    GetPage(name: verification, page: () => const VerificationScreen()),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(name: resetPassword, page: () => const ResetPasswordScreen()),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      transition: Transition.fadeIn, // إضافة تأثير ظهور ناعم للرئيسية
    ),
    GetPage(name: providerSetup, page: () => const ProviderSetupScreen()),
    GetPage(name: ProviderRequests, page: () => const ProviderRequestsScreen()),


  ];
}