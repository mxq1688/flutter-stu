import 'package:get/get.dart';

import '../modules/auth/login_page.dart';
import '../modules/auth/auth_binding.dart';
import '../modules/home/home_page.dart';
import '../modules/home/home_binding.dart';
import '../modules/detail/detail_page.dart';
import '../modules/detail/detail_binding.dart';

part 'app_routes.dart';

/// 路由页面配置
class AppPages {
  AppPages._();

  static const initial = Routes.login;

  static final routes = [
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.detail,
      page: () => const DetailPage(),
      binding: DetailBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}


