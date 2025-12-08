import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// BuildContext 扩展
extension ContextExtension on BuildContext {
  // 主题相关
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  // 尺寸相关
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get padding => MediaQuery.of(this).padding;
  
  // 路由相关
  void pushPage(String path, {Object? extra}) => GoRouter.of(this).push(path, extra: extra);
  void goPage(String path, {Object? extra}) => GoRouter.of(this).go(path, extra: extra);
  void popPage<T extends Object?>([T? result]) => GoRouter.of(this).pop(result);
  
  // SnackBar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : null,
      ),
    );
  }
}


