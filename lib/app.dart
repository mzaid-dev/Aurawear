import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_frame/device_frame.dart';
import 'core/theme/app_theme.dart';
import 'core/desktop/desktop_shell.dart';
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
        if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
          return child!;
        }

        final deviceFrame = DeviceFrame(
          device: Devices.ios.iPhone13ProMax,
          isFrameVisible: true,
          orientation: Orientation.portrait,
          screen: child!,
        );

        if (!kIsWeb &&
            (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
          return DesktopWindowWrapper(child: deviceFrame);
        }

        return deviceFrame;
      },
    );
  }
}
