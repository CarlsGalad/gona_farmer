
import 'package:gona_vendor/models/subcategory.dart';

class Category {
  final int id;
  final String name;
  final String imagePath;
  final List<Subcategory> subcategories;

  Category(
      {required this.id,
      required this.name,
      required this.imagePath,
      required this.subcategories});

  factory Category.fromMap(Map<String, dynamic> data) => Category(
        id: data['id'] as int,
        name: data['name'] as String,
        imagePath: data['imagePath'] as String,
        subcategories: (data['subcategories'] as List<dynamic>)
            .map((subcatData) => Subcategory.fromMap(subcatData))
            .toList(), // Convert subcategories data to Subcategory objects
      );
}
