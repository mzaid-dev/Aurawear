import 'package:aurawear/core/theme/index.dart';
import 'package:aurawear/features/home/presentation/home_presentation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [HomeAppBar(), SizedBox(height: 18), HomeBody()],
        ),
      ),
    );
  }
}
