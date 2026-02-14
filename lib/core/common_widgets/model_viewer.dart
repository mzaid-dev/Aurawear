import 'dart:async';
import 'dart:io' as io;
import 'package:aurawear/core/theme/app_colors.dart';
import 'package:aurawear/core/theme/text_styles.dart';
import 'package:aurawear/features/home/domain/models/product.dart';
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
  // UI State
  bool _isMenuOpen = false;

  // Loading State
  bool _isLoading = true;
  bool _hasError = false;
  Timer? _timeoutTimer;

  // Windows Server State
  io.HttpServer? _server;
  String? _localModelUrl;

  @override
  void initState() {
    super.initState();
    _initializeViewer();
  }

  Future<void> _initializeViewer() async {
    _startLoadingTimeout();

    if (!kIsWeb && io.Platform.isWindows) {
      await _startWindowsServer();
    }
  }

  Future<void> _startWindowsServer() async {
    try {
      final assetPath =
          widget.product.modelPath ?? 'assets/3d_models/headphone.glb';

      // 1. Get temp directory
      final tempDir = await getTemporaryDirectory();
      final tempFile = io.File('${tempDir.path}/${assetPath.split('/').last}');

      // 2. Extract asset to temp file (if needed)
      // Always write to ensure fresh copy or handle updates
      final byteData = await rootBundle.load(assetPath);
      await tempFile.writeAsBytes(
        byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
      );

      // 3. Start minimal HTTP server
      // Use loopbackIPv4 and port 0 (ephemeral/random available port)
      _server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);

      _server!.listen((io.HttpRequest request) async {
        // CORs headers to allow WebView access
        request.response.headers.add('Access-Control-Allow-Origin', '*');
        request.response.headers.contentType = io.ContentType.parse(
          'model/gltf-binary',
        );

        await tempFile.openRead().pipe(request.response);
      });

      if (mounted) {
        setState(() {
          _localModelUrl = 'http://localhost:${_server!.port}/model.glb';
        });
      }
    } catch (e) {
      debugPrint('Windows Server Error: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  void _startLoadingTimeout() {
    _timeoutTimer?.cancel();
    // 10-second timeout as requested
    _timeoutTimer = Timer(const Duration(seconds: 10), () {
      if (mounted && _isLoading) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    _server?.close(force: true);
    super.dispose();
  }

  void _onModelLoaded() {
    if (mounted) {
      setState(() {
        _isLoading = false;
        _hasError = false;
      });
      _timeoutTimer?.cancel();
    }
  }

  void _retry() {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
      if (!kIsWeb && io.Platform.isWindows && _localModelUrl == null) {
        _startWindowsServer();
      } else {
        _startLoadingTimeout();
      }
    }
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine asset URL
    String assetSrc =
        widget.product.modelPath ?? 'assets/3d_models/headphone.glb';

    if (!kIsWeb && io.Platform.isWindows) {
      if (_localModelUrl != null) {
        assetSrc = _localModelUrl!;
      } else {
        return Scaffold(
          backgroundColor: AppColors.homeBg,
          body: const Center(
            child: CircularProgressIndicator(color: AppColors.primaryRose),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColors.homeBg,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.textBlack,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: AppTextStyles.headlineLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Main Viewer Area
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: const BoxDecoration(
                      color: Color(0xffFFE7E4),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Center(
                      child: _hasError
                          ? _buildErrorState()
                          : Stack(
                              children: [
                                ModelViewer(
                                  key: ValueKey(assetSrc),
                                  src: assetSrc,
                                  alt: "3D Model of ${widget.product.name}",
                                  autoRotate: true,
                                  cameraControls: true,
                                  backgroundColor: Colors.transparent,
                                  interactionPrompt: InteractionPrompt.auto,
                                  onWebViewCreated: (controller) {
                                    // Inject a JS channel to detect the 'load' event
                                    // using dynamic to avoid strict type dependency on webview_flutter
                                    try {
                                      (controller as dynamic)
                                          .addJavaScriptChannel(
                                            'FlutterModelViewer',
                                            onMessageReceived: (message) {
                                              if (message.message == 'loaded') {
                                                _onModelLoaded();
                                              }
                                            },
                                          );
                                    } catch (e) {
                                      // Ignore if not supported
                                    }
                                  },
                                  relatedJs: """
                                    // Wait for model-viewer element to appear
                                    const findModelViewer = setInterval(() => {
                                      const modelViewer = document.querySelector('model-viewer');
                                      
                                      if (modelViewer) {
                                        clearInterval(findModelViewer);
                                        
                                        // Only listen for events - don't check existing state
                                        // This ensures loading indicator shows even for fast/cached models
                                        
                                        // 1. Listen for load event
                                        modelViewer.addEventListener('load', () => {
                                          notifyFlutter();
                                        });

                                        // 2. Listen for progress completion
                                        modelViewer.addEventListener('progress', (e) => {
                                          if (e.detail.totalProgress === 1) {
                                            notifyFlutter();
                                          }
                                        });
                                        
                                        // 3. Fallback: if still not notified after 2 seconds,
                                        // assume it's loaded (handles edge cases)
                                        setTimeout(() => {
                                          if (!hasNotified) {
                                            notifyFlutter();
                                          }
                                        }, 2000);
                                      }
                                    }, 100);

                                    // Track if we've already notified
                                    let hasNotified = false;
                                    let notifyCount = 0;
                                    
                                    function notifyFlutter() {
                                      if (window.FlutterModelViewer && !hasNotified) {
                                        window.FlutterModelViewer.postMessage('loaded');
                                        hasNotified = true;
                                        notifyCount++;
                                        
                                        // Send a few times to ensure delivery
                                        const confirmInterval = setInterval(() => {
                                          if (notifyCount < 3) {
                                            window.FlutterModelViewer.postMessage('loaded');
                                            notifyCount++;
                                          } else {
                                            clearInterval(confirmInterval);
                                          }
                                        }, 100);
                                      }
                                    }
                                  """,
                                ),
                                if (_isLoading)
                                  const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryRose,
                                    ),
                                  ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Controls (Only show if loaded successfully)
          if (!_hasError && !_isLoading) _buildControls(),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.sentiment_dissatisfied_outlined,
          color: AppColors.primaryRose.withValues(alpha: 0.7),
          size: 64,
        ),
        const SizedBox(height: 24),
        Text(
          "Taking longer than expected...",
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.textBlack,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            "We're having trouble loading the 3D model for this product right now.",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text("Go Back"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[700],
                side: BorderSide(color: Colors.grey[400]!),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _retry,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRose,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          FloatingActionButton(
            heroTag: "main_fab",
            onPressed: _toggleMenu,
            backgroundColor: AppColors.primaryRose,
            elevation: 4,
            child: AnimatedRotation(
              turns: _isMenuOpen ? 0.125 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                _isMenuOpen ? Icons.add : Icons.settings_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
