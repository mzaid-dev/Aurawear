import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_frame/device_frame.dart';
import 'core/theme/index.dart';
import 'core/device_simulator/device_simulator.dart';
import 'core/router/index.dart';

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
        if (!kIsWeb &&
            (defaultTargetPlatform == TargetPlatform.android ||
                defaultTargetPlatform == TargetPlatform.iOS)) {
          return child!;
        }
        final deviceFrame = DeviceFrame(
          device: Devices.ios.iPhone13ProMax,
          isFrameVisible: true,
          orientation: Orientation.portrait,
          screen: child!,
        );
        if (!kIsWeb &&
            (defaultTargetPlatform == TargetPlatform.windows ||
                defaultTargetPlatform == TargetPlatform.linux ||
                defaultTargetPlatform == TargetPlatform.macOS)) {
          return DeviceSimulatorFrame(child: deviceFrame);
        }
        return deviceFrame;
      },
    );
  }
}
