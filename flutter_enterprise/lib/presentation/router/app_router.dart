import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../pages/home/home_page.dart';
import '../pages/login/login_page.dart';
import '../pages/detail/detail_page.dart';

part 'app_router.gr.dart';

/// 应用路由 - auto_route
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page, initial: true),
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: DetailRoute.page),
      ];
}

/// 路由路径常量
class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String home = '/home';
  static const String detail = '/detail';
}


