import 'package:get/get.dart';

/// 详情页控制器
class DetailController extends GetxController {
  String get id => Get.arguments?['id'] ?? '';
  String get title => Get.arguments?['title'] ?? '详情';
}


