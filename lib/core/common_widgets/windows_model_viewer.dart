import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';

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
  InAppLocalhostServer? _localhostServer;
  bool _isServerStarted = false;
  final int _port = 8080;

  @override
  void initState() {
    super.initState();
    _initServer();
  }

  Future<void> _initServer() async {
    try {
      final directory = await getTemporaryDirectory();
      _localhostServer = InAppLocalhostServer(
        port: _port,
        documentRoot: directory.path,
      );
      await _localhostServer!.start();

      if (mounted) {
        setState(() {
          _isServerStarted = true;
        });
      }
    } catch (e) {
      debugPrint("Local Server Start Error: $e");
      // If port is taken, try another one or handle it
      if (mounted) {
        setState(() {
          _isServerStarted = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _localhostServer?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isServerStarted) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFE35858)),
      );
    }

    final String fileName = widget.selectedModel
        .split(Platform.pathSeparator)
        .last;
    final String modelUrl = "http://localhost:$_port/$fileName";

    final String htmlContent =
        '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
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
        id="mv-element"
        src="$modelUrl" 
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
      initialData: InAppWebViewInitialData(
        data: htmlContent,
        mimeType: 'text/html',
        encoding: 'utf-8',
        baseUrl: WebUri("http://localhost:$_port/"),
      ),
      initialSettings: InAppWebViewSettings(
        transparentBackground: true,
        supportZoom: false,
        isInspectable: true,
        allowFileAccessFromFileURLs: true,
        allowUniversalAccessFromFileURLs: true,
      ),
      onWebViewCreated: (controller) {
        widget.controller?._setWebViewController(controller);
      },
      onConsoleMessage: (controller, consoleMessage) {
        debugPrint(
          'WebView Console [${consoleMessage.messageLevel}]: ${consoleMessage.message}',
        );
      },
      onLoadStop: (controller, url) {
        widget.controller?._setWebViewController(controller);
      },
    );
  }
}
