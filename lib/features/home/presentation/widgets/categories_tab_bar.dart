import 'package:flutter/material.dart';

class CustomChipTabBar extends StatefulWidget {
  const CustomChipTabBar({super.key});

  @override
  State<CustomChipTabBar> createState() => _CustomChipTabBarState();
}

class _CustomChipTabBarState extends State<CustomChipTabBar> {
  final List<String> categories = ['All', 'Headphones', 'Speakers'];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      child: Stack(
        children: [
          // Background/Border implementation
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23),
              border: Border.all(color: Colors.black12, width: 1),
            ),
          ),

          // Animated Selector
          LayoutBuilder(
            builder: (context, constraints) {
              double tabWidth = constraints.maxWidth / categories.length;
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.elasticOut,
                left: _selectedIndex * tabWidth,
                width: tabWidth,
                top: 0,
                bottom: 0,
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(21),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Tab Items
          Row(
            children: List.generate(categories.length, (index) {
              final isSelected = _selectedIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black45,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                      child: Text(categories[index]),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
