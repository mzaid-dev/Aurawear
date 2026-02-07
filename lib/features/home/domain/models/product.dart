class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imagePath;
  final bool is3d;
  final String? modelPath;
 

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.is3d,
    this.modelPath ,
  });
}
