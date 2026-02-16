import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    await windowManager.ensureInitialized();


    final screenSize = await windowManager.getSize();
    final screenHeight = screenSize.height;


    final windowHeight = (screenHeight * 0.84).clamp(800.0, 1000.0);


    final windowWidth = (windowHeight * (9 / 19.5)).clamp(400.0, 500.0);

    WindowOptions windowOptions = WindowOptions(
      size: Size(windowWidth, windowHeight),
      minimumSize: const Size(300, 600), 
      center: true,
      backgroundColor: Colors.transparent, 
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setResizable(false); 
    });
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const AurawearApp());
}
