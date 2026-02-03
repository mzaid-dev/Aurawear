import 'dart:ui_web' as ui; // Modern way to access platformViewRegistry
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web; // The modern web package

void main() => runApp(const MaterialApp(home: SketchfabWebIframe()));

class SketchfabWebIframe extends StatelessWidget {
  const SketchfabWebIframe({super.key});

  @override
  Widget build(BuildContext context) {
    const String viewID = 'sketchfab-airpods';

    // Register the factory using the modern dart:ui_web library
    ui.platformViewRegistry.registerViewFactory(
      viewID,
          (int viewId) {
        // Create the iframe using the 'web' package
        final web.HTMLIFrameElement iframe = web.document.createElement('iframe') as web.HTMLIFrameElement;

        iframe.src = 'https://sketchfab.com/models/05315717512c4089b2629a82e26bb121/embed?ui_theme=dark';
        iframe.style.border = 'none';
        iframe.style.width = '100%';
        iframe.style.height = '100%';

        return iframe;
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text("AirPods Max 3D (Web)")),
      body: const HtmlElementView(viewType: viewID),
    );
  }
}