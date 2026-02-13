import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class MacWindowControls extends StatefulWidget {
  const MacWindowControls({super.key});

  @override
  State<MacWindowControls> createState() => _MacWindowControlsState();
}

class _MacWindowControlsState extends State<MacWindowControls> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            color: const Color(0xFFFF5F57),
            icon: Icons.close,
            tooltip: "Close",
            onTap: () => windowManager.close(),
          ),
          const SizedBox(width: 8),
          _buildButton(
            color: const Color(0xFFFFBD2E),
            icon: Icons.remove,
            tooltip: "Minimize",
            onTap: () => windowManager.minimize(),
          ),
          const SizedBox(width: 8),
          _buildButton(
            color: const Color(0xFF28C940),
            icon: Icons.add,
            tooltip: "Maximize",
            onTap: () async {
              if (await windowManager.isMaximized()) {
                windowManager.restore();
              } else {
                windowManager.maximize();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: _isHovering
              ? Center(
                  child: Icon(
                    icon,
                    size: 8,
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
