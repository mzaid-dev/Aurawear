import 'dart:async';
import 'dart:io' as io;

import 'package:aurawear/core/theme/index.dart';
import 'package:aurawear/features/home/domain/home_domain.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:path_provider/path_provider.dart';



class ModelViewerWidget extends StatefulWidget {
  final Product product;
  const ModelViewerWidget({super.key, required this.product});

  @override
  State<ModelViewerWidget> createState() => _ModelViewerWidgetState();
}

class _ModelViewerWidgetState extends State<ModelViewerWidget> {
  bool _isLoading = true;
  bool _hasError = false;
  Timer? _timeoutTimer;


  io.HttpServer? _server;
  String? _localModelUrl;

  @override
  void initState() {
    super.initState();
    _initViewer();
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    _server?.close(force: true);
    super.dispose();
  }

  Future<void> _initViewer() async {
    _resetState();
    try {
      _startTimeout();
      if (!kIsWeb && io.Platform.isWindows) {
        await _setupWindowsServer();
      }
    } catch (e) {
      debugPrint('3D Viewer Error: $e');
      _setErrorState();
    }
  }

  void _resetState() => setState(() {
    _isLoading = true;
    _hasError = false;
  });

  void _setErrorState() => setState(() {
    _isLoading = false;
    _hasError = true;
  });

  void _startTimeout() {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(const Duration(seconds: 12), () {
      if (mounted && _isLoading) {
        _setErrorState();
      }
    });
  }

  Future<void> _setupWindowsServer() async {
    final assetPath =
        widget.product.modelPath ?? 'assets/3d_models/headphone.glb';
    final tempDir = await getTemporaryDirectory();
    final tempFile = io.File('${tempDir.path}/${assetPath.split('/').last}');

    final data = await rootBundle.load(assetPath);
    await tempFile.writeAsBytes(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    );

    _server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    _server!.listen((request) async {
      request.response.headers.add('Access-Control-Allow-Origin', '*');
      request.response.headers.contentType = io.ContentType.parse(
        'model/gltf-binary',
      );
      await tempFile.openRead().pipe(request.response);
    });

    if (mounted) {
      setState(
        () => _localModelUrl = 'http://localhost:${_server!.port}/model.glb',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBg,
      body: Stack(
        children: [
          _buildMainContent(),
          if (_isLoading && !_hasError) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 18),
          _buildViewerContainer(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
          ),
          Text(
            widget.product.name,
            style: AppTextStyles.headlineLarge.copyWith(fontSize: 24),
          ),
          const SizedBox(width: 40), 
        ],
      ),
    );
  }

  Widget _buildViewerContainer() {
    final assetSrc = _getAssetSource();
    if (_isWindowsWaiting) {
      return const Center(child: CircularProgressIndicator());
    }

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xffFFE7E4),
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: _hasError ? _buildErrorState() : _buildModelViewer(assetSrc),
      ),
    );
  }

  String _getAssetSource() => (io.Platform.isWindows && _localModelUrl != null)
      ? _localModelUrl!
      : (widget.product.modelPath ?? "");

  bool get _isWindowsWaiting =>
      !kIsWeb && io.Platform.isWindows && _localModelUrl == null;

  Widget _buildModelViewer(String src) {
    if (src.isEmpty) {
      return _buildErrorState();
    }
    return ModelViewer(
      key: ValueKey(src),
      src: src,
      alt: "3D Model",
      autoRotate: true,
      cameraControls: true,
      backgroundColor: Colors.transparent,
      onWebViewCreated: (c) {
        try {
          (c as dynamic).addJavaScriptChannel(
            'FlutterChannel',
            onMessageReceived: (m) {
              if (m.message == 'loaded' && mounted) {
                setState(() => _isLoading = false);
                _timeoutTimer?.cancel();
              }
            },
          );
        } catch (_) {}
      },
      relatedJs:
          "document.querySelector('model-viewer')?.addEventListener('load', () => window.FlutterChannel?.postMessage('loaded'));",
    );
  }

  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      top: 100, 
      child: Container(
        color: const Color(0xffFFE7E4),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primaryRose),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 64, color: AppColors.primaryRose),
        const SizedBox(height: 16),
        const Text(
          "Unable to load 3D model",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _initViewer,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryRose,
            foregroundColor: Colors.white,
          ),
          child: const Text("Retry Connection"),
        ),
      ],
    );
  }
}
