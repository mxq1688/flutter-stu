import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';

import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'bindings/initial_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化 GetStorage
  await GetStorage.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Flutter GetX',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
          initialBinding: InitialBinding(),
          defaultTransition: Transition.cupertino,
        );
      },
    );
  }
}
