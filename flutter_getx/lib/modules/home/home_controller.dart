import 'package:get/get.dart';

import '../auth/auth_controller.dart';

/// 首页控制器
class HomeController extends GetxController {
  // 获取 AuthController
  AuthController get authController => Get.find<AuthController>();

  // 计数器
  final RxInt counter = 0.obs;

  /// 增加
  void increment() => counter++;

  /// 减少
  void decrement() {
    if (counter > 0) counter--;
  }

  /// 重置
  void reset() => counter.value = 0;
}


