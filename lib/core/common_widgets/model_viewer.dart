import 'dart:io' as io;
import 'dart:math' as math;
import 'package:aurawear/core/theme/app_colors.dart';
import 'package:aurawear/core/theme/text_styles.dart';
import 'package:aurawear/features/home/domain/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'windows_model_viewer.dart';

class ModelViewerWidget extends StatefulWidget {
  final Product product;
  const ModelViewerWidget({super.key, required this.product});

  @override
  State<ModelViewerWidget> createState() => _ModelViewerWidgetState();
}

class _ModelViewerWidgetState extends State<ModelViewerWidget>
    with SingleTickerProviderStateMixin {
  bool _isAutoRotate = true;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  bool _isMenuOpen = false;
  final Flutter3DController _controller = Flutter3DController();
  final Windows3DController _windowsController = Windows3DController();
  String? _stagedModelPath;
  bool _isLoading = true;

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
    final String assetPath =
        widget.product.modelPath ?? 'assets/3d_models/headphone.glb';

    if (!kIsWeb && io.Platform.isWindows) {
      try {
        final directory = await getTemporaryDirectory();
        final fileName = assetPath.split('/').last;
        final file = io.File('${directory.path}/$fileName');

        if (!await file.exists()) {
          final byteData = await rootBundle.load(assetPath);
          await file.writeAsBytes(
            byteData.buffer.asUint8List(
              byteData.offsetInBytes,
              byteData.lengthInBytes,
            ),
          );
        }

        if (mounted) {
          setState(() {
            _stagedModelPath = file.path;
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _stagedModelPath = assetPath;
            _isLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _stagedModelPath = assetPath;
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
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
    if (!kIsWeb && io.Platform.isWindows) {
      _windowsController.setCameraOrbit(0, 0, -0.5);
    } else {
      _controller.setCameraOrbit(0, 0, -5);
    }
  }

  void _zoomOut() {
    if (!kIsWeb && io.Platform.isWindows) {
      _windowsController.setCameraOrbit(0, 0, 0.5);
    } else {
      _controller.setCameraOrbit(0, 0, 5);
    }
  }

  void _toggleAutoRotate() {
    setState(() {
      _isAutoRotate = !_isAutoRotate;
      if (!kIsWeb && io.Platform.isWindows) {
        _windowsController.setAutoRotate(_isAutoRotate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Center(
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: AppColors.primaryRose,
                            )
                          : (!kIsWeb && io.Platform.isWindows)
                          ? WindowsModelViewer(
                              selectedModel: _stagedModelPath!,
                              controller: _windowsController,
                              autoRotate: _isAutoRotate,
                            )
                          : Flutter3DViewer(
                              src: _stagedModelPath!,
                              controller: _controller,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                  icon: _isAutoRotate ? Icons.stop_circle : Icons.rotate_right,
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
