# Dart FFI（Foreign Function Interface）

## 什么是 FFI

FFI（Foreign Function Interface，外部函数接口）是 Dart 提供的一种**直接调用原生 C 代码**的机制。通过 `dart:ffi` 库，Dart/Flutter 代码可以同步调用 C 函数、访问 C 结构体、操作原生内存，无需经过平台通道（Platform Channel）。

## 为什么需要 FFI

| 场景 | 说明 |
|------|------|
| 性能敏感 | 图像处理、加密解密等计算密集型任务，C 比 Dart 快得多 |
| 复用现有库 | 直接调用成熟的 C/C++ 库（SQLite、FFmpeg、OpenSSL 等） |
| 系统级操作 | 访问操作系统底层 API |
| 跨平台共享 | 同一份 C 代码可在 Android、iOS、Desktop 上复用 |

## FFI vs Platform Channel

| 对比项 | Dart FFI | Platform Channel |
|--------|----------|-----------------|
| 调用方式 | 同步 | 异步 |
| 目标语言 | C / C++ | Java/Kotlin (Android)、Swift/ObjC (iOS) |
| 性能开销 | 低（直接调用） | 高（消息序列化/反序列化） |
| 适用场景 | 高频调用、计算密集 | 平台特定 API、系统服务 |
| 跨平台性 | 一份 C 代码通用 | 每个平台单独实现 |

## 核心概念

### 1. 动态库加载

```dart
import 'dart:ffi';

// Android / Linux
final dylib = DynamicLibrary.open('libhello.so');

// iOS（静态链接到 App）
final dylib = DynamicLibrary.process();

// macOS
final dylib = DynamicLibrary.open('libhello.dylib');

// Windows
final dylib = DynamicLibrary.open('hello.dll');
```

### 2. 原生类型映射

| C 类型 | Dart FFI 类型 | Dart 类型 |
|--------|--------------|-----------|
| `int8_t` | `Int8` | `int` |
| `int32_t` | `Int32` | `int` |
| `int64_t` | `Int64` | `int` |
| `float` | `Float` | `double` |
| `double` | `Double` | `double` |
| `char*` | `Pointer<Utf8>` | `String` |
| `void*` | `Pointer<Void>` | — |
| `struct` | `Struct` 子类 | — |

### 3. 函数签名绑定

FFI 需要两个签名：一个描述 C 函数，一个描述对应的 Dart 函数。

```dart
// C 端原型: int add(int a, int b)

// 原生签名（NativeFunction）
typedef AddNative = Int32 Function(Int32 a, Int32 b);

// Dart 签名
typedef AddDart = int Function(int a, int b);

// 查找并绑定
final AddDart add = dylib
    .lookup<NativeFunction<AddNative>>('add')
    .asFunction<AddDart>();

print(add(3, 5)); // 8
```

### 4. 结构体

```dart
// C 端:
// struct Point { double x; double y; };

final class Point extends Struct {
  @Double()
  external double x;

  @Double()
  external double y;
}

// 使用
final Pointer<Point> p = calloc<Point>();
p.ref.x = 1.0;
p.ref.y = 2.0;
calloc.free(p);
```

### 5. 字符串传递

```dart
import 'package:ffi/ffi.dart'; // 来自 package:ffi

// Dart String → C char*
final Pointer<Utf8> cStr = 'Hello'.toNativeUtf8();

// C char* → Dart String
final String dartStr = cStr.toDartString();

// 用完释放
calloc.free(cStr);
```

### 6. 回调（Dart → C）

```dart
// C 端期望: void (*callback)(int result)
typedef CallbackNative = Void Function(Int32 result);

void myCallback(int result) {
  print('收到回调: $result');
}

final callbackPointer = Pointer.fromFunction<CallbackNative>(myCallback);
// 把 callbackPointer 传给 C 函数
```

## 完整示例：Flutter 中使用 FFI

### 第一步：编写 C 代码

```c
// native/hello.c
#include <stdint.h>

int32_t add(int32_t a, int32_t b) {
    return a + b;
}

int32_t factorial(int32_t n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}
```

### 第二步：配置编译（以 Android 为例）

```cmake
# android/app/CMakeLists.txt
cmake_minimum_required(VERSION 3.10)
add_library(hello SHARED ../native/hello.c)
```

在 `android/app/build.gradle` 中添加：

```groovy
android {
    externalNativeBuild {
        cmake {
            path "CMakeLists.txt"
        }
    }
}
```

### 第三步：Dart 端绑定

```dart
import 'dart:ffi';
import 'dart:io' show Platform;

class NativeHello {
  static final DynamicLibrary _lib = _loadLibrary();

  static DynamicLibrary _loadLibrary() {
    if (Platform.isAndroid) return DynamicLibrary.open('libhello.so');
    if (Platform.isIOS) return DynamicLibrary.process();
    if (Platform.isMacOS) return DynamicLibrary.open('libhello.dylib');
    if (Platform.isWindows) return DynamicLibrary.open('hello.dll');
    throw UnsupportedError('不支持的平台');
  }

  static final int Function(int, int) add = _lib
      .lookup<NativeFunction<Int32 Function(Int32, Int32)>>('add')
      .asFunction();

  static final int Function(int) factorial = _lib
      .lookup<NativeFunction<Int32 Function(Int32)>>('factorial')
      .asFunction();
}

// 使用
print(NativeHello.add(10, 20));       // 30
print(NativeHello.factorial(10));     // 3628800
```

## ffigen：自动生成绑定

手写绑定容易出错，`package:ffigen` 可以从 C 头文件自动生成 Dart 绑定代码。

### 配置 `pubspec.yaml`

```yaml
dev_dependencies:
  ffigen: ^14.0.0

ffigen:
  name: HelloBindings
  description: 自动生成的 hello 库绑定
  output: lib/src/hello_bindings.dart
  headers:
    entry-points:
      - native/hello.h
```

### 运行生成

```bash
dart run ffigen
```

自动生成的 `hello_bindings.dart` 包含所有函数签名和结构体定义，无需手写。

## 注意事项

1. **内存管理** — C 分配的内存必须手动释放，Dart GC 不会管理原生内存
2. **线程安全** — FFI 调用在 Dart 的主 isolate 中是同步的，耗时操作应放到单独的 isolate
3. **平台差异** — 不同平台的动态库格式不同（`.so` / `.dylib` / `.dll`），需分别处理
4. **调试困难** — C 代码的崩溃会导致整个 App 崩溃，没有 Dart 层的异常保护
5. **iOS 限制** — iOS 不允许动态加载库，只能使用静态链接（`DynamicLibrary.process()`）

## 常用包

| 包名 | 用途 |
|------|------|
| `dart:ffi` | FFI 核心库（内置） |
| `package:ffi` | 内存分配、字符串转换等工具 |
| `package:ffigen` | 从 C 头文件自动生成 Dart 绑定 |
| `package:sqlite3` | 基于 FFI 的 SQLite 绑定（实际案例） |

## 参考资料

- [Dart FFI 官方文档](https://dart.dev/interop/c-interop)
- [ffigen 文档](https://pub.dev/packages/ffigen)
- [package:ffi](https://pub.dev/packages/ffi)
