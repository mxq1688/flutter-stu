# Flutter 开发框架合集

## 项目列表

| 项目 | 状态管理 | 路由 | 适用场景 |
|------|---------|------|---------|
| `flutter_lite` | Provider | Navigator | 学习/小项目 |
| `flutter_getx` | GetX | GetX Router | 快速开发 |
| `flutter_standard` | Riverpod | go_router | **正规项目** ⭐ |
| `flutter_enterprise` | Bloc | auto_route | 大型团队 |

## 运行项目

```bash
# 方案一/二：直接运行
cd flutter_lite && flutter run
cd flutter_getx && flutter run

# 方案三/四：需要先生成代码
cd flutter_standard && flutter pub run build_runner build && flutter run
cd flutter_enterprise && flutter pub run build_runner build && flutter run
```

## 代码生成

方案三/四使用**注解 + 代码生成**，你写 10 行 → 工具自动生成 100 行。

### 常用注解

| 注解 | 来自 | 生成内容 |
|-----|------|---------|
| `@JsonSerializable()` | json_annotation | fromJson / toJson |
| `@RestApi()` | retrofit | HTTP 请求实现 |
| `@riverpod` | riverpod_annotation | Provider |
| `@freezed` | freezed_annotation | copyWith / == / hashCode |

### 生成文件

| 后缀 | 内容 |
|-----|------|
| `*.g.dart` | JSON转换、API实现、Provider |
| `*.freezed.dart` | 不可变数据类 |
| `*.gr.dart` | 路由配置 |

### 示例

```dart
part 'user.g.dart';  // ← 指定生成文件

@JsonSerializable()  // ← 注解
class User {
  final String id;
  final String name;
  User({required this.id, required this.name});
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

> ⚠️ 生成的文件不要手动修改，改源文件后重新运行 `build_runner`

## 目录结构

```
flutter_lite/       → core / data / providers / pages / widgets
flutter_getx/       → core / data / bindings / routes / modules
flutter_standard/   → core / data / presentation
flutter_enterprise/ → core / domain / data / presentation
```

## 包含功能

登录登出 · 状态管理 · 路由传参 · 网络请求 · 主题切换 · 屏幕适配
