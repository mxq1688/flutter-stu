import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/counter_provider.dart';
import '../../router/app_router.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final counter = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // 用户信息卡片
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30.r,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          authState.user?.name.substring(0, 1).toUpperCase() ?? 'U',
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authState.user?.name ?? '用户',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              authState.user?.email ?? '',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // 计数器演示
              Card(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      Text(
                        'Riverpod 状态管理演示',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        '$counter',
                        style: TextStyle(
                          fontSize: 48.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton.filled(
                            onPressed: () {
                              ref.read(counterProvider.notifier).decrement();
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          SizedBox(width: 24.w),
                          IconButton.filled(
                            onPressed: () {
                              ref.read(counterProvider.notifier).reset();
                            },
                            icon: const Icon(Icons.refresh),
                          ),
                          SizedBox(width: 24.w),
                          IconButton.filled(
                            onPressed: () {
                              ref.read(counterProvider.notifier).increment();
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // 导航演示
              Card(
                child: ListTile(
                  leading: const Icon(Icons.arrow_forward),
                  title: const Text('go_router 路由演示'),
                  subtitle: const Text('点击跳转详情页'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.push(
                      AppRoutes.detailWithId('123'),
                      extra: {'title': '详情页标题'},
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


