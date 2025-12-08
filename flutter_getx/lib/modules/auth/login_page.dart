import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import 'auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 60.h),

                      // Logo
                      Icon(
                        Icons.bolt,
                        size: 80.sp,
                        color: AppColors.primary,
                      ),

                      SizedBox(height: 24.h),

                      Text(
                        'Flutter GetX',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      Text(
                        '快速开发框架 - GetX 全家桶',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      SizedBox(height: 60.h),

                      TextFormField(
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: '邮箱',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入邮箱';
                          }
                          if (!value.contains('@')) {
                            return '请输入有效的邮箱地址';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16.h),

                      TextFormField(
                        controller: controller.passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: '密码',
                          prefixIcon: Icon(Icons.lock_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入密码';
                          }
                          if (value.length < 6) {
                            return '密码至少6位';
                          }
                          return null;
                        },
                      ),

                      if (controller.errorMessage.isNotEmpty) ...[
                        SizedBox(height: 16.h),
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            controller.errorMessage.value,
                            style: TextStyle(
                              color: AppColors.error,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],

                      SizedBox(height: 32.h),

                      ElevatedButton(
                        onPressed: controller.login,
                        child: const Text('登录'),
                      ),

                      SizedBox(height: 16.h),

                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          '⚡ 演示模式：输入任意邮箱和密码（6位以上）即可登录',
                          style: TextStyle(
                            color: AppColors.info,
                            fontSize: 12.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Loading
            if (controller.isLoading.value)
              Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}


