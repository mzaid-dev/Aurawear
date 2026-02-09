import 'package:flutter/material.dart';

class ColorSelector extends StatelessWidget {
  final List<Color> colors;
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const ColorSelector({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74.88,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: colors.map((color) {
          return GestureDetector(
            onTap: () => onColorSelected(color),
            child: _buildColorDot(color, isSelected: selectedColor == color),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildColorDot(Color color, {bool isSelected = false}) {
    return AnimatedScale(
      scale: isSelected ? 1.1 : 1,
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: 44,
        width: 44,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 8),
        ),
      ),
    );
  }
}
