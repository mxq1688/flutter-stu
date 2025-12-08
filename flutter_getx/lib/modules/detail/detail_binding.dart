import 'package:get/get.dart';

import 'detail_controller.dart';

/// 详情模块绑定
class DetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DetailController());
  }
}


