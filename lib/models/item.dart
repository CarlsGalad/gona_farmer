import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String id;
  final String name;
  final int price;
  final String description;
  final String itemPath;
  final String itemLocation;
  final String itemFarm;
  final int categoryId;
  final int farmingYear;
  final double? vendorRating;
  final int subcategoryId;
  final int availQuantity;
  final bool isPaused;
  final int? oldPrice;
  final String? label;
  final double weight;
  final String? sellingMethod;
  final String? state;
  final String farmId;

  int quantity;

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.itemPath,
    required this.itemLocation,
    required this.itemFarm,
    required this.categoryId,
    required this.farmingYear,
    required this.subcategoryId,
    required this.availQuantity,
    required this.farmId,
    required this.weight,
    this.quantity = 1,
    this.isPaused = false,
    this.oldPrice,
    this.label,
    this.sellingMethod,
    this.state,
    this.vendorRating,
  });

  factory Item.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Item(
      id: doc.id,
      name: data['name'] as String,
      price: data['price'] as int,
      description: data['description'] as String,
      itemPath: data['itemPath'] as String,
      itemLocation: data['itemLocation'] as String,
      itemFarm: data['itemFarm'] as String,
      categoryId: data['categoryId'] as int,
      farmingYear: data['farmingYear'] as int,
      vendorRating: data.containsKey('vendorRating')
          ? (data['vendorRating'] as num?)?.toDouble()
          : null,
      subcategoryId: data['subcategoryId'] as int,
      availQuantity: data['availQuantity'] as int,
      quantity:
          data.containsKey('quantity') ? (data['quantity'] as int?) ?? 1 : 1,
      isPaused: data.containsKey('isPaused')
          ? (data['isPaused'] as bool?) ?? false
          : false,
      oldPrice: data.containsKey('oldPrice') ? data['oldPrice'] as int? : null,
      label: data.containsKey('label') ? data['label'] as String? : null,
      weight: data.containsKey('weight')
          ? (data['weight'] as num?)?.toDouble() ?? 0.0
          : 0.0,
      sellingMethod: data.containsKey('sellingMethod')
          ? data['sellingMethod'] as String?
          : null,
      state: data.containsKey('state') ? data['state'] as String? : null,
      farmId: data['farmId'] as String,
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'itemPath': itemPath,
      'itemLocation': itemLocation,
      'itemFarm': itemFarm,
      'categoryId': categoryId,
      'farmingYear': farmingYear,
      if (vendorRating != null) 'vendorRating': vendorRating,
      'subcategoryId': subcategoryId,
      'availQuantity': availQuantity,
      'farmId': farmId,
      'quantity': quantity,
      'isPaused': isPaused,
      'weight': weight,
      if (oldPrice != null) 'oldPrice': oldPrice,
      if (label != null) 'label': label,
      if (sellingMethod != null) 'sellingMethod': sellingMethod,
      if (state != null) 'state': state,
    };
  }

  Item copyWith({
    String? id,
    String? name,
    int? price,
    String? description,
    String? itemPath,
    String? itemLocation,
    String? itemFarm,
    int? categoryId,
    int? farmingYear,
    double? vendorRating,
    String? farmId,
    int? subcategoryId,
    int? availQuantity,
    int? quantity,
    bool? isPaused,
    int? oldPrice,
    String? label,
    double? weight,
    String? sellingMethod,
    String? state,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      itemPath: itemPath ?? this.itemPath,
      itemLocation: itemLocation ?? this.itemLocation,
      itemFarm: itemFarm ?? this.itemFarm,
      categoryId: categoryId ?? this.categoryId,
      farmingYear: farmingYear ?? this.farmingYear,
      vendorRating: vendorRating ?? this.vendorRating,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      availQuantity: availQuantity ?? this.availQuantity,
      farmId: farmId ?? this.farmId,
      quantity: quantity ?? this.quantity,
      isPaused: isPaused ?? this.isPaused,
      oldPrice: oldPrice ?? this.oldPrice,
      label: label ?? this.label,
      weight: weight ?? this.weight,
      sellingMethod: sellingMethod ?? this.sellingMethod,
      state: state ?? this.state,
    );
  }
}
