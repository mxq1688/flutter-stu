import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../routes/app_pages.dart';
import '../../core/utils/logger.dart';

/// 认证控制器
class AuthController extends GetxController {
  final AuthRepository _repository = Get.find<AuthRepository>();

  // 响应式状态
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // 表单控制器
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool get isLoggedIn => user.value != null;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// 登录
  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _repository.login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (result != null) {
        user.value = result;
        AppLogger.i('Login successful: ${result.name}');
        Get.offAllNamed(Routes.home);
      } else {
        errorMessage.value = '登录失败，请检查账号密码';
      }
    } catch (e) {
      errorMessage.value = '登录失败: ${e.toString()}';
      AppLogger.e('Login failed', e);
    } finally {
      isLoading.value = false;
    }
  }

  /// 登出
  Future<void> logout() async {
    isLoading.value = true;

    try {
      await _repository.logout();
      user.value = null;
      AppLogger.i('Logout successful');
      Get.offAllNamed(Routes.login);
    } catch (e) {
      AppLogger.e('Logout error', e);
      Get.offAllNamed(Routes.login);
    } finally {
      isLoading.value = false;
    }
  }

  /// 清除错误
  void clearError() {
    errorMessage.value = '';
  }
}


