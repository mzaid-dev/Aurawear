import 'package:flutter/material.dart';
import 'package:device_frame/device_frame.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
class AurawearApp extends StatelessWidget {
  const AurawearApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Aurawear',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      builder: (context, child) {
        return DeviceFrame(
          device: Devices.ios.iPhone13ProMax,
          isFrameVisible: true,
          orientation: Orientation.portrait,
          screen: child!,
        );
      },
    );
  }
}
