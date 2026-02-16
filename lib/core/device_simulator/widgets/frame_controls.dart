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
            icon: Icons.minimize,
            tooltip: "Minimize",
            onTap: () => windowManager.minimize(),
          ),
          const SizedBox(width: 8),
          _buildButton(
            color: const Color(0xFF3A3A3A),
            icon: Icons.add,
            tooltip: "Full Screen (Disabled)",
            onTap: () {},
            isEnabled: false,
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
    bool isEnabled = true,
  }) {
    return Tooltip(
      message: tooltip,
      preferBelow : false,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: Container(
          width: 13,
          height: 13,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: (_isHovering && isEnabled)
              ? Center(
                  child: Icon(
                    icon,
                    size: 9,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
