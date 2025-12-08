import 'package:get/get.dart';

import 'auth_controller.dart';

/// 认证模块绑定
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
  }
}


