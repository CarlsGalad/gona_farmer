import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item.dart';
import '../services/firestore_service.dart';

class ItemProvider with ChangeNotifier {
  List<Map<String, dynamic>> _items = [];
  final Map<String, ImageProvider> loadedImages = {};
  bool isLoading = false;
  final String itemsCollectionName = 'Items';
  SharedPreferences? _prefs;
  List<Item> _cart = [];
  List<Item> get cart => _cart;

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveCartItems() async {
    await _initSharedPreferences();
    List<String> cartItemsJson = _cart
        .map((item) => item.toJson())
        .toList()
        .map((e) => e.toString())
        .toList();
    await _prefs?.setStringList('cartItems', cartItemsJson);
  }

  Future<void> loadCartItems() async {
    await _initSharedPreferences();
    List<String>? cartItemsJson = _prefs?.getStringList('cartItems');
    if (cartItemsJson != null) {
      _cart = cartItemsJson.map((itemJson) => Item.fromJson(itemJson)).toList();
    }
  }

  Future<void> updateFromFirestore(FirestoreService firestoreService) async {
    isLoading = true;
    notifyListeners();
    try {
      _items = await firestoreService.fetchItems();
      notifyListeners();
    } catch (error) {
      print('Error updating items from Firestore: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Item? getItemById(String itemId) {
    Map<String, dynamic>? itemMap = _items.firstWhere(
      (item) => item['id'] == itemId,
      orElse: () => <String, dynamic>{},
    );

    if (itemMap.isEmpty) {
      return null;
    }

    return Item(
      id: itemMap['id'],
      name: itemMap['name'],
      price: itemMap['price'],
      description: itemMap['description'],
      itemFarm: itemMap['itemFarm'],
      itemLocation: itemMap['itemLocation'],
      itemPath: itemMap['itemPath'],
      vendorRating: itemMap['vendorRating'],
      categoryId: itemMap['categoryId'],
      farmingYear: itemMap['farmingYear'],
      subcategoryId: itemMap['subcategoryId'],
      availQuantity: itemMap['availQuantity'],
    );
  }

  // Method to add an item to the farmer's collection
  void addItem(Item item) {
    _items.add(item.toMap());
    notifyListeners();
  }

  void removeItem(Item item) {
    int index = _items.indexWhere((element) => element['id'] == item.id);
    if (index != -1) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  List<Item> searchItems(String query) {
    query = query.trim();
    List<String> keywords = query.split(' ');
    return _items
        .where((item) {
          String itemName = (item['name'] as String).toLowerCase();
          return keywords
              .any((keyword) => itemName.contains(keyword.toLowerCase()));
        })
        .map((map) => Item.fromMap(map))
        .toList();
  }
}
