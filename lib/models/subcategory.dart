class Subcategory {
  final int id;
  final String name;

  Subcategory({required this.id, required this.name});

  factory Subcategory.fromMap(Map<String, dynamic> data) => Subcategory(
        id: data['id'] as int,
        name: data['name'] as String,
      );
}
