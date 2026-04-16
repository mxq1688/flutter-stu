# 各平台调用 C 代码的方式

## 总览

| 平台 | 原生方式 | Flutter 方式 | 难度 |
|------|----------|-------------|------|
| iOS (ObjC) | 直接调用（ObjC 是 C 的超集） | Dart FFI | 最简单 |
| iOS (Swift) | Bridging Header | Dart FFI | 简单 |
| Android (Java/Kotlin) | JNI + NDK | Dart FFI | 较复杂 |
| macOS | 同 iOS | Dart FFI | 简单 |
| Linux | 直接 `dlopen` | Dart FFI | 简单 |
| Windows | `LoadLibrary` | Dart FFI | 简单 |

---

## iOS 调用 C

### 方式一：Objective-C 直接调用（零成本）

Objective-C 是 C 语言的超集，C 代码可以直接写在 `.m` 文件里，也可以通过头文件引入。

```c
// hello.h
int add(int a, int b);

// hello.c
int add(int a, int b) {
    return a + b;
}
```

```objectivec
// ViewController.m
#import "hello.h"

- (void)viewDidLoad {
    [super viewDidLoad];
    int result = add(3, 5); // 直接调用，无需任何桥接
    NSLog(@"结果: %d", result);
}
```

调用链：**ObjC → C**（直接调用，没有中间层）

### 方式二：Swift 通过 Bridging Header 调用

Swift 不是 C 的超集，需要一个桥接头文件来暴露 C 接口。

**第一步：创建桥接头文件**

```objectivec
// ProjectName-Bridging-Header.h
#import "hello.h"
```

**第二步：Swift 中直接使用**

```swift
let result = add(3, 5)
print("结果: \(result)")
```

调用链：**Swift → Bridging Header → C**

### 方式三：Flutter FFI（iOS 端）

iOS 不允许动态加载库（App Store 审核要求），所以 C 代码必须**静态链接**到 App 中。

```dart
final dylib = DynamicLibrary.process(); // 从当前进程查找符号

final int Function(int, int) add = dylib
    .lookup<NativeFunction<Int32 Function(Int32, Int32)>>('add')
    .asFunction();
```

调用链：**Dart → FFI → C**（静态链接）

### iOS 特殊限制

- **禁止动态加载** — App Store 不允许运行时加载 `.dylib`，只能静态链接
- **使用 `DynamicLibrary.process()`** — 因为 C 代码已编译进主进程
- **CocoaPods 集成** — Flutter 插件中的 C 代码通过 `.podspec` 配置编译

---

## Android 调用 C

### 方式一：JNI + NDK（原生方案）

Android 的 Java/Kotlin 与 C 语言没有直接关系，需要通过 **JNI（Java Native Interface）** 作为桥梁。

**第一步：Java/Kotlin 端声明 native 方法**

```kotlin
// Kotlin
class NativeLib {
    companion object {
        init { System.loadLibrary("hello") }
    }
    external fun add(a: Int, b: Int): Int
}
```

```java
// Java
public class NativeLib {
    static { System.loadLibrary("hello"); }
    public native int add(int a, int b);
}
```

**第二步：C 端实现（必须遵循 JNI 命名规则）**

```c
// hello.c
#include <jni.h>

// 函数名格式: Java_包名_类名_方法名（包名中的 . 换成 _）
JNIEXPORT jint JNICALL
Java_com_example_app_NativeLib_add(JNIEnv *env, jobject thiz, jint a, jint b) {
    return a + b;
}
```

**第三步：配置 CMake 编译**

```cmake
# app/src/main/cpp/CMakeLists.txt
cmake_minimum_required(VERSION 3.10)
project(hello)
add_library(hello SHARED hello.c)
```

```groovy
// app/build.gradle
android {
    externalNativeBuild {
        cmake {
            path "src/main/cpp/CMakeLists.txt"
        }
    }
}
```

调用链：**Kotlin/Java → JNI → C**

### JNI 的痛点

1. **命名规则严格** — 函数名必须是 `Java_包名_类名_方法名`，改个包名就要改 C 代码
2. **类型转换繁琐** — `jstring` ↔ `const char*` 需要手动转换
3. **胶水代码多** — 每个方法都需要写 JNI 对应的 C 函数
4. **调试困难** — JNI 层的错误信息不直观

### 方式二：Flutter FFI（Android 端）

```dart
final dylib = DynamicLibrary.open('libhello.so'); // Android 允许动态加载

final int Function(int, int) add = dylib
    .lookup<NativeFunction<Int32 Function(Int32, Int32)>>('add')
    .asFunction();
```

调用链：**Dart → FFI → C**（动态加载 `.so`）

---

## iOS vs Android 对比

| 对比项 | iOS | Android |
|--------|-----|---------|
| 原生语言与 C 的关系 | ObjC 是 C 的超集，**天然兼容** | Java/Kotlin 与 C 无关，需 **JNI 桥接** |
| 调用 C 的难度 | 非常简单 | 较复杂（写 JNI 胶水代码） |
| 动态库支持 | **不允许**动态加载 | 允许加载 `.so` |
| 库文件格式 | `.a`（静态库） | `.so`（动态库） |
| 编译工具 | Xcode / clang | NDK / CMake |
| Flutter FFI 加载 | `DynamicLibrary.process()` | `DynamicLibrary.open('libxxx.so')` |

---

## Desktop 平台调用 C

### macOS

与 iOS 类似，但**允许动态加载** `.dylib`：

```dart
final dylib = DynamicLibrary.open('libhello.dylib');
```

### Linux

加载 `.so` 文件：

```dart
final dylib = DynamicLibrary.open('libhello.so');
```

### Windows

加载 `.dll` 文件：

```dart
final dylib = DynamicLibrary.open('hello.dll');
```

---

## Flutter 跨平台统一写法

```dart
import 'dart:ffi';
import 'dart:io' show Platform;

DynamicLibrary loadNativeLibrary(String name) {
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$name.so');
  }
  if (Platform.isIOS) {
    return DynamicLibrary.process(); // 静态链接，不需要文件名
  }
  if (Platform.isMacOS) {
    return DynamicLibrary.open('lib$name.dylib');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$name.dll');
  }
  throw UnsupportedError('不支持的平台: ${Platform.operatingSystem}');
}
```

---

## 实际应用案例

这些知名项目都在移动端通过 C/C++ 实现核心逻辑：

| 项目 | 语言 | 用途 |
|------|------|------|
| SQLite | C | 本地数据库 |
| FFmpeg | C | 音视频编解码 |
| OpenCV | C++ | 图像处理 / 计算机视觉 |
| WebRTC | C++ | 实时音视频通信 |
| OpenSSL / BoringSSL | C | 加密 / TLS |
| Skia | C++ | 2D 渲染引擎（Flutter 自身就用它） |
| Realm | C++ | 移动端数据库 |

---

## 参考资料

- [Apple — Using C in Swift](https://developer.apple.com/documentation/swift/using-imported-c-functions-in-swift)
- [Android NDK 官方文档](https://developer.android.com/ndk/guides)
- [Dart FFI 官方文档](https://dart.dev/interop/c-interop)
