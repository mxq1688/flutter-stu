import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter_provider.g.dart';

/// 计数器 Provider - 使用 Riverpod Generator
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  /// 增加
  void increment() => state++;

  /// 减少
  void decrement() {
    if (state > 0) state--;
  }

  /// 重置
  void reset() => state = 0;
}


