import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../pages/home/home_page.dart';
import '../pages/login/login_page.dart';
import '../pages/detail/detail_page.dart';

/// 路由 Provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/detail/:id',
        name: 'detail',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          final extra = state.extra as Map<String, dynamic>?;
          return DetailPage(
            id: id,
            title: extra?['title'] ?? '详情',
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('页面不存在: ${state.uri}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('返回首页'),
            ),
          ],
        ),
      ),
    ),
  );
});

/// 路由路径常量
class AppRoutes {
  AppRoutes._();
  
  static const String login = '/login';
  static const String home = '/home';
  static const String detail = '/detail';
  
  static String detailWithId(String id) => '/detail/$id';
}


