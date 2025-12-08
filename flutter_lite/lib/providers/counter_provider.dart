import 'package:flutter/material.dart';

/// 计数器 Provider - 演示用
class CounterProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  /// 增加
  void increment() {
    _count++;
    notifyListeners();
  }

  /// 减少
  void decrement() {
    if (_count > 0) {
      _count--;
      notifyListeners();
    }
  }

  /// 重置
  void reset() {
    _count = 0;
    notifyListeners();
  }

  /// 设置值
  void setValue(int value) {
    _count = value;
    notifyListeners();
  }
}


