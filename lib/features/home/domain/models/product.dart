class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imagePath;
  final List<int> colors; // List of hex values

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.colors,
  });
}
