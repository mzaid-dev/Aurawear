import 'package:aurawear/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';
import 'window_controls.dart';

class DesktopWindowWrapper extends StatelessWidget {
  final Widget child;

  const DesktopWindowWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const _SimulatorHeader(),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 40,
                    spreadRadius: 2,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                // The child is the DeviceFrame which has its own rounded corners,
                // but we clip here just in case to match the shadow/frame.
                child: child,
              ),
            ),
          ),
          const SizedBox(height: 20), // Bottom breathing room
        ],
      ),
    );
  }
}

class _SimulatorHeader extends StatelessWidget {
  const _SimulatorHeader();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (_) {
        windowManager.startDragging();
      },
      child: Container(
        height: 52,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              // 1. Controls (Traffic Lights)
              const MacWindowControls(),

              // 2. Device Name (Centered)
              Expanded(
                child: Center(
                  child: Text(
                    "iPhone 15 Pro - iOS 17.0",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily:
                          'SF Pro Display', // Default fallback usually OK
                    ),
                  ),
                ),
              ),

              // 3. Toolbar Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ToolbarButton(
                    icon: Icons.restart_alt_rounded,
                    tooltip: "Restart App",
                    onPressed: () {
                      context.goNamed(AppRoutes.splashName);
                    },
                  ),
                  const SizedBox(width: 12),
                  _ToolbarButton(
                    icon: Icons.camera_alt_outlined,
                    tooltip: "Screenshot",
                    onPressed: () {}, // Dummy
                  ),
                  const SizedBox(width: 12),
                  _ToolbarButton(
                    icon: Icons.rotate_right_rounded,
                    tooltip: "Rotate",
                    onPressed: () {}, // Dummy
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolbarButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _ToolbarButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  State<_ToolbarButton> createState() => _ToolbarButtonState();
}

class _ToolbarButtonState extends State<_ToolbarButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Tooltip(
          message: widget.tooltip,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _isHovering
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.icon,
              color: _isHovering ? Colors.white : Colors.grey[500],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
