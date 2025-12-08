import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../routes/app_pages.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => controller.authController.logout(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // 用户信息
              Obx(() {
                final user = controller.authController.user.value;
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30.r,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            user?.name.substring(0, 1).toUpperCase() ?? 'U',
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
                                user?.name ?? '用户',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                user?.email ?? '',
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
              }),

              SizedBox(height: 24.h),

              // 计数器
              Card(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      Text(
                        'GetX 状态管理演示',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Obx(() => Text(
                            '${controller.counter.value}',
                            style: TextStyle(
                              fontSize: 48.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          )),
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton.filled(
                            onPressed: controller.decrement,
                            icon: const Icon(Icons.remove),
                          ),
                          SizedBox(width: 24.w),
                          IconButton.filled(
                            onPressed: controller.reset,
                            icon: const Icon(Icons.refresh),
                          ),
                          SizedBox(width: 24.w),
                          IconButton.filled(
                            onPressed: controller.increment,
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
                  title: const Text('GetX 路由演示'),
                  subtitle: const Text('点击跳转详情页'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.toNamed(
                      Routes.detail,
                      arguments: {'id': '123', 'title': '详情页标题'},
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


