import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_colors.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/counter/counter_cubit.dart';
import '../../router/app_router.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
              context.router.replaceNamed(AppRoutes.login);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // 用户信息
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30.r,
                            backgroundColor: AppColors.primary,
                            child: Text(
                              state.user?.name.substring(0, 1).toUpperCase() ?? 'U',
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
                                  state.user?.name ?? '用户',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  state.user?.email ?? '',
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
                  );
                },
              ),

              SizedBox(height: 24.h),

              // 计数器
              Card(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      Text(
                        'Bloc / Cubit 状态管理演示',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      BlocBuilder<CounterCubit, int>(
                        builder: (context, count) {
                          return Text(
                            '$count',
                            style: TextStyle(
                              fontSize: 48.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton.filled(
                            onPressed: () => context.read<CounterCubit>().decrement(),
                            icon: const Icon(Icons.remove),
                          ),
                          SizedBox(width: 24.w),
                          IconButton.filled(
                            onPressed: () => context.read<CounterCubit>().reset(),
                            icon: const Icon(Icons.refresh),
                          ),
                          SizedBox(width: 24.w),
                          IconButton.filled(
                            onPressed: () => context.read<CounterCubit>().increment(),
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // 导航
              Card(
                child: ListTile(
                  leading: const Icon(Icons.arrow_forward),
                  title: const Text('auto_route 路由演示'),
                  subtitle: const Text('点击跳转详情页'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.router.pushNamed(
                      '${AppRoutes.detail}?id=123&title=详情页标题',
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


