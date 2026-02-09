import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imagePath;
  final bool is3d;
  final String? modelPath;
  final List<Color> colors;
  final int selectedColor;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.is3d,
    required this.colors,
    required this.selectedColor,
    this.modelPath,
  });
}
