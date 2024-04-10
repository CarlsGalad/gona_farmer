import 'dart:convert';

class Item {
  final String id; //Document ID
  final String name;
  final int price;
  final String description;
  final String itemPath;
  final String itemLocation;
  final String itemFarm;
  final int categoryId; // Reference to a Category document
  final int farmingYear;
  final double vendorRating;
  final int
      subcategoryId; // Reference to a document within the Category's subcollection
  final int availQuantity;

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
    required this.vendorRating,
    required this.subcategoryId,
    required this.availQuantity,
    this.quantity = 1,
  });

  // Renamed factory constructor to fromMap for clarity
  factory Item.fromMap(Map<String, dynamic> data) {
    // Error handling for missing fields
    if (data.containsKey('quantity')) {
      return Item(
        id: data['id'] as String,
        name: data['name'] as String,
        price: data['price'] as int,
        description: data['description'] as String,
        itemPath: data['itemPath'] as String,
        itemLocation: data['itemLocation'] as String,
        itemFarm: data['itemFarm'] as String,
        categoryId:
            data['categoryId'] as int, // Reference to a Category document
        farmingYear: data['farmingYear'] as int,
        vendorRating: data['vendorRating'] as double,
        subcategoryId: data['subcategoryId']
            as int, // Reference to a document within the Category's subcollection
        availQuantity: data['availQuantity'] as int,
        quantity: data['quantity'] as int,
      );
    } else {
      return Item(
        id: data['id'] as String,
        name: data['name'] as String,
        price: data['price'] as int,
        description: data['description'] as String,
        itemPath: data['itemPath'] as String,
        itemLocation: data['itemLocation'] as String,
        itemFarm: data['itemFarm'] as String,
        categoryId:
            data['categoryId'] as int, // Reference to a Category document
        farmingYear: data['farmingYear'] as int,
        vendorRating: data['vendorRating'] as double,
        subcategoryId: data['subcategoryId']
            as int, // Reference to a document within the Category's subcollection
        availQuantity: data['availQuantity'] as int,
      );
    }
  }

  factory Item.fromJson(String jsonString) {
    // Parse the JSON string to a Map
    final Map<String, dynamic> data = json.decode(jsonString);
    return Item.fromMap(data);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'itemPath': itemPath,
      'itemLocation': itemLocation,
      'itemFarm': itemFarm,
      'categoryId': categoryId,
      'farmingYear': farmingYear,
      'vendorRating': vendorRating,
      'subcategoryId': subcategoryId,
      'availQuantity': availQuantity,
      'quantity': quantity,
    };
  }

  String toJson() {
    return json.encode(toMap());
  }

  //  a method to copy the item with an updated quantity
  Item copyWith({int? quantity}) {
    return Item(
      id: id,
      name: name,
      price: price,
      description: description,
      itemPath: itemPath,
      itemLocation: itemLocation,
      itemFarm: itemFarm,
      categoryId: categoryId,
      farmingYear: farmingYear,
      vendorRating: vendorRating,
      subcategoryId: subcategoryId,
      availQuantity: quantity ??
          availQuantity, // Use the new quantity if provided, otherwise use the current quantity
    );
  }
}
