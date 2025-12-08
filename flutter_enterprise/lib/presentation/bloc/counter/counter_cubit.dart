import 'package:flutter_bloc/flutter_bloc.dart';

/// 计数器 Cubit - 简化版 Bloc
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  /// 增加
  void increment() => emit(state + 1);

  /// 减少
  void decrement() {
    if (state > 0) emit(state - 1);
  }

  /// 重置
  void reset() => emit(0);
}


