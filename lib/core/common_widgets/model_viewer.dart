import 'dart:async';
import 'dart:io' as io;
import 'dart:math' as math;

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

class _ModelViewerWidgetState extends State<ModelViewerWidget>
    with SingleTickerProviderStateMixin {
  bool _isAutoRotate = true;
  double _fov = 30;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  bool _isMenuOpen = false;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  String? _localModelPath;
  Timer? _loadingTimeout;
  static const int _maxLoadingSeconds = 30;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInBack,
    );
    _prepareModel();
  }

  Future<void> _prepareModel() async {
    _loadingTimeout = Timer(Duration(seconds: _maxLoadingSeconds), () {
      if (mounted && _isLoading) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage =
              'The 3D model took too long to load.\n'
              'This could be due to a slow connection or limited device memory.\n'
              'Please try again.';
        });
      }
    });

    final String assetPath =
        widget.product.modelPath ?? 'assets/3d_models/headphone.glb';

    if (kIsWeb) {
      if (mounted) {
        setState(() {
          _localModelPath = assetPath;
          _isLoading = false;
        });
        _loadingTimeout?.cancel();
      }
      return;
    }

    if (assetPath.startsWith('assets/')) {
      try {
        final byteData = await DefaultAssetBundle.of(context).load(assetPath);
        final file = await _createTempFile(assetPath, byteData);

        if (mounted) {
          final String normalizedPath = file.path.replaceAll('\\', '/');
          setState(() {
            _localModelPath = 'file:///$normalizedPath';
            _isLoading = false;
          });
          _loadingTimeout?.cancel();
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _localModelPath = assetPath;
            _isLoading = false;
          });
          _loadingTimeout?.cancel();
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _localModelPath = assetPath;
          _isLoading = false;
        });
        _loadingTimeout?.cancel();
      }
    }
  }

  Future<io.File> _createTempFile(String name, ByteData data) async {
    final directory = await getTemporaryDirectory();
    final fileName = name.split('/').last;
    final file = io.File('${directory.path}/$fileName');
    await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
    return file;
  }

  @override
  void dispose() {
    _loadingTimeout?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      if (_isMenuOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _zoomIn() {
    setState(() {
      _fov = (_fov - 5).clamp(10, 60).toDouble();
    });
  }

  void _zoomOut() {
    setState(() {
      _fov = (_fov + 5).clamp(10, 60).toDouble();
    });
  }

  void _toggleAutoRotate() {
    setState(() {
      _isAutoRotate = !_isAutoRotate;
    });
  }

  void _retryLoading() {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
      _localModelPath = null;
    });
    _prepareModel();
  }

  @override
  Widget build(BuildContext context) {
    final String modelSrc =
        _localModelPath ??
        widget.product.modelPath ??
        'assets/3d_models/headphone.glb';

    final bool arEnabled = !kIsWeb && !io.Platform.isWindows;

    return Scaffold(
      backgroundColor: AppColors.homeBg,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                    child: Stack(
                      children: [
                        if (!_isLoading && !_hasError)
                          Center(
                            child: ModelViewer(
                              key: ValueKey(modelSrc),
                              backgroundColor: Colors.transparent,
                              src: modelSrc,
                              alt: "A 3D model of ${widget.product.name}",
                              autoRotate: _isAutoRotate,
                              cameraControls: true,
                              ar: arEnabled,
                              autoPlay: true,
                              disableZoom: false,
                              fieldOfView: "${_fov}deg",
                            ),
                          ),
                        if (_isLoading) _buildLoadingOverlay(),
                        if (_hasError) _buildErrorScreen(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!_isLoading && !_hasError)
            Positioned(
              bottom: 16,
              right: 16,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  _buildCircularButton(
                    index: 0,
                    icon: Icons.zoom_in,
                    onPressed: _zoomIn,
                    tooltip: "Zoom In",
                  ),
                  _buildCircularButton(
                    index: 1,
                    icon: Icons.zoom_out,
                    onPressed: _zoomOut,
                    tooltip: "Zoom Out",
                  ),
                  _buildCircularButton(
                    index: 2,
                    icon: _isAutoRotate
                        ? Icons.stop_circle
                        : Icons.rotate_right,
                    onPressed: _toggleAutoRotate,
                    tooltip: _isAutoRotate ? "Stop Rotation" : "Auto Rotate",
                  ),
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
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primaryRose),
          const SizedBox(height: 24),
          Text(
            "Loading 3D Model...",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primaryRose,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Preparing ${widget.product.name}",
            style: TextStyle(
              fontSize: 12,
              color: AppColors.primaryRose.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 64,
              color: AppColors.primaryRose,
            ),
            const SizedBox(height: 16),
            Text(
              "Unable to Load Model",
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.primaryRose,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                height: 1.5,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text("Go Back"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryRose,
                    side: const BorderSide(color: AppColors.primaryRose),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _retryLoading,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text("Retry"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRose,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularButton({
    required int index,
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    const double distance = 100.0;
    final double angle = 180 + (index * 45);
    final double radians = angle * math.pi / 180;

    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        final double currentDistance = _expandAnimation.value * distance;
        return Transform.translate(
          offset: Offset(
            math.cos(radians) * currentDistance,
            math.sin(radians) * currentDistance,
          ),
          child: Opacity(
            opacity: _expandAnimation.value.clamp(0.0, 1.0),
            child: FloatingActionButton.small(
              heroTag: "btn_$index",
              onPressed: _isMenuOpen ? onPressed : null,
              backgroundColor: Colors.white,
              tooltip: tooltip,
              elevation: _isMenuOpen ? 2 : 0,
              child: Icon(icon, color: AppColors.primaryRose),
            ),
          ),
        );
      },
    );
  }
}
