import 'package:get/get.dart';

import 'home_controller.dart';
import '../auth/auth_controller.dart';

/// 首页模块绑定
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // 确保 AuthController 存在
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController());
    }
    Get.lazyPut(() => HomeController());
  }
}


