import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'frame_controls.dart';

class DeviceSimulatorFrame extends StatelessWidget {
  final Widget child;
  const DeviceSimulatorFrame({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, 
      body: Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (context) => Column(
              children: [
                const SizedBox(height: 10),
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
                      child: child,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
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
              const MacWindowControls(),
              Expanded(
                child: Center(
                  child: Text(
                    "iPhone 13 Pro Max - iOS 15.0",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 68,
              ), 
            ],
          ),
        ),
      ),
    );
  }
}
