import 'package:get/get.dart';

import '../data/services/api_service.dart';
import '../data/repositories/auth_repository.dart';

/// 初始绑定 - 全局依赖注入
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // 服务
    Get.putAsync(() => ApiService().init());
    
    // 仓库
    Get.lazyPut(() => AuthRepository());
  }
}


