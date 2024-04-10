class Promotion {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imagePath;

  Promotion({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
  });

  factory Promotion.fromMap(Map<String, dynamic> map) {
    return Promotion(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      imagePath: map['imagePath'],
    );
  }
}
