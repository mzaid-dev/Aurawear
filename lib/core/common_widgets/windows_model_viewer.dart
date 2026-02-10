import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Windows3DController {
  InAppWebViewController? _webViewController;

  void _setWebViewController(InAppWebViewController controller) {
    _webViewController = controller;
  }

  Future<void> setCameraOrbit(
    double theta,
    double phi,
    double radiusDelta,
  ) async {
    if (_webViewController == null) return;

    await _webViewController!.evaluateJavascript(
      source:
          """
      (function() {
        const mv = document.querySelector('model-viewer');
        if (mv) {
          const orbit = mv.getCameraOrbit();
          // radius is the 3rd element in the orbit object
          mv.cameraOrbit = `\${orbit.theta}rad \${orbit.phi}rad \${orbit.radius + $radiusDelta}m`;
        }
      })();
    """,
    );
  }

  Future<void> setAutoRotate(bool enabled) async {
    if (_webViewController == null) return;
    await _webViewController!.evaluateJavascript(
      source:
          """
      (function() {
        const mv = document.querySelector('model-viewer');
        if (mv) {
          mv.autoRotate = $enabled;
        }
      })();
    """,
    );
  }
}

class WindowsModelViewer extends StatefulWidget {
  final String selectedModel;
  final Windows3DController? controller;
  final bool autoRotate;

  const WindowsModelViewer({
    super.key,
    required this.selectedModel,
    this.controller,
    this.autoRotate = true,
  });

  @override
  State<WindowsModelViewer> createState() => _WindowsModelViewerState();
}

class _WindowsModelViewerState extends State<WindowsModelViewer> {
  @override
  Widget build(BuildContext context) {
    final String fileUri = Uri.file(widget.selectedModel).toString();

    final String htmlContent =
        '''
<!DOCTYPE html>
<html>
<head>
    <script type="module" src="https://ajax.googleapis.com/ajax/libs/model-viewer/3.4.0/model-viewer.min.js"></script>
    <style>
        body, html { 
            margin: 0; 
            padding: 0; 
            width: 100%; 
            height: 100%; 
            overflow: hidden; 
            background-color: transparent; 
        }
        model-viewer { 
            width: 100%; 
            height: 100%; 
            background-color: transparent; 
            --progress-bar-color: transparent;
        }
    </style>
</head>
<body>
    <model-viewer 
        src="$fileUri" 
        ${widget.autoRotate ? 'auto-rotate' : ''}
        camera-controls 
        interaction-prompt="auto"
        shadow-intensity="1"
        environment-image="neutral"
        exposure="1"
        touch-action="pan-y">
    </model-viewer>
</body>
</html>
''';

    return InAppWebView(
      initialData: InAppWebViewInitialData(data: htmlContent),
      initialSettings: InAppWebViewSettings(
        transparentBackground: true,
        supportZoom: false,
        isInspectable: true,
      ),
      onWebViewCreated: (controller) {
        widget.controller?._setWebViewController(controller);
      },
      onConsoleMessage: (controller, consoleMessage) {
        debugPrint('WebView Console: ${consoleMessage.message}');
      },
      onLoadStop: (controller, url) {
        widget.controller?._setWebViewController(controller);
      },
    );
  }
}
