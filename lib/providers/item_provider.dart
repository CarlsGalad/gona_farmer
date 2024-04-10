import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/item.dart';
import '../services/firestore_service.dart';



class ItemProvider with ChangeNotifier {
  //listing to rep the item
  List<Map<String, dynamic>> _items = [];

  final Map<String, ImageProvider> _loadedImages = {};

  bool _isLoading = false;
  final String itemsCollectionName = 'Items';

//getter for data  and loading status
  List<Map<String, dynamic>> get items => _items;
  bool get isLoading => _isLoading;
  Map<String, ImageProvider> get loadedImages => _loadedImages;

// SharedPreferences instance
  SharedPreferences? _prefs;

  // Cart items list
  List<Item> _cart = [];
  List<Item> get cart => _cart;

  // Initialize SharedPreferences instance
  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save cart items to SharedPreferences
  Future<void> _saveCartItems() async {
    await _initSharedPreferences();
    List<String> cartItemsJson = _cart
        .map((item) => item.toJson())
        .toList()
        .map((e) => e.toString())
        .toList();
    await _prefs?.setStringList('cartItems', cartItemsJson);
  }

// Load cart items from SharedPreferences
  Future<void> loadCartItems() async {
    await _initSharedPreferences();
    List<String>? cartItemsJson = _prefs?.getStringList('cartItems');
    if (cartItemsJson != null) {
      _cart = cartItemsJson.map((itemJson) => Item.fromJson(itemJson)).toList();
    }
  }

// Fetch items and categories
  Future<void> updateFromFirestore(FirestoreService firestoreService) async {
    _isLoading = true;
    notifyListeners(); // Notify about loading state change
    try {
      _items = await firestoreService.fetchItems();
      notifyListeners(); // Notify about items update
    } catch (error) {
      // Handle errors appropriately
      print('Error updating items from Firestore: $error');
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify about loading state change (optional)
    }
  }

//New list to represent favorite items
  final List<Item> _favorites = [];
  List<Item> get favorites => _favorites;

  Item? getItemById(String itemId) {
    // Find the map corresponding to the item with the given ID
    Map<String, dynamic>? itemMap = _items.firstWhere(
      (item) => item['id'] == itemId,
      orElse: () =>
          <String, dynamic>{}, // Provide an empty map as the default value
    );

    // If the item map is empty (i.e., item not found), return null
    if (itemMap.isEmpty) {
      return null;
    }

    // Create an Item object from the item map
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

  void addItemCard(Item item) {
    // Convert the Item object to a map
    Map<String, dynamic> itemMap = item
        .toMap(); // Replace toMap() with the actual method to convert Item to Map

    // Add the map to the list of items
    _items.add(itemMap);
    notifyListeners();
  }

  void removeItemcard(Item item) {
    // Find the index of the item in the list based on its ID
    int index = _items.indexWhere((element) => element['id'] == item.id);

    // If the item is found, remove it from the list
    if (index != -1) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

//add items to cart
  void addItemToCart(Item item) async {
    _cart.add(item);
    _saveCartItems(); // Save cart items
    notifyListeners();
  }

// remove items from cart
  void removeProductFromCart(Item item) {
    _cart.remove(item);
    _saveCartItems(); // Save cart items
    notifyListeners();
  }

// get cart items length
  int getCartItemCount() {
    return _cart.length;
  }

// calculate item cart item total  price
  double getTotalPriceInCart() {
    double totalPrice =
        _cart.fold(0.0, (previousValue, item) => previousValue + item.price);
    return totalPrice;
  }

// Clear all items from the cart
  void clearCart() {
    _cart.clear(); // Clear all items from the cart list
    _saveCartItems(); // Save cart items
    notifyListeners(); // Notify listeners to update the UI
  }

//add item to favorite
  void addToFavorites(Item item) {
    _favorites.add(item);
    notifyListeners();
  }

// method to remove an item from favorites
  void removeFromFavorites(Item item) {
    _favorites.remove(item);
    notifyListeners();
  }

// check if the item is on the list of favorite
  bool isFavorite(Item item) {
    return _favorites.contains(item);
  }

// filter items based on a given category
  List<Item> getItemsByCategory(int categoryId) {
    return _items
        .where((item) => item['categoryId'] == categoryId)
        .map((map) => Item.fromMap(map))
        .toList();
  }

  // Method to get items by subcategory ID and category
  List<Item> getItemsBySubcategoryAndCategory(
      int subcategoryId, int categoryId) {
    // Filter the list of items based on the subcategory ID
    return _items
        .where((item) =>
            item['subcategoryId'] == subcategoryId &&
            item['categoryId'] == categoryId)
        .map((map) => Item.fromMap(map)) // Convert map to Item object
        .toList();
  }

  List<Item> searchItems(String query) {
    // Trim the query to remove leading and trailing whitespace
    query = query.trim();

    // Split the query by spaces
    List<String> keywords = query.split(' ');

    // Filter items based on the search query
    return _items
        .where((item) {
          String itemName = (item['name'] as String).toLowerCase();
          // Check if any of the keywords are present in the item name
          return keywords
              .any((keyword) => itemName.contains(keyword.toLowerCase()));
        })
        .map((map) => Item.fromMap(map))
        .toList();
  }

// search filter starts here
  List<Item> filterItems({
    String? location,
    double? minPrice,
    double? maxPrice,
    double? minVendorRating,
    int? categoryId,
    int? farmingYear,
    int? quantity,
  }) {
    // Initial list of items to filter
    List<Item> filteredItems = items.map((map) => Item.fromMap(map)).toList();

    // Filter by location
    if (location != null && location.isNotEmpty) {
      filteredItems = filteredItems
          .where((item) =>
              item.itemLocation.toLowerCase().contains(location.toLowerCase()))
          .toList();
    }

    // Filter by price range
    if (minPrice != null) {
      filteredItems =
          filteredItems.where((item) => item.price >= minPrice).toList();
    }

    if (maxPrice != null) {
      filteredItems =
          filteredItems.where((item) => item.price <= maxPrice).toList();
    }

    // Filter by vendor rating
    if (minVendorRating != null) {
      filteredItems = filteredItems
          .where((item) => item.vendorRating >= minVendorRating)
          .toList();
    }

    // Filter by category
    if (categoryId != null) {
      filteredItems =
          filteredItems.where((item) => item.categoryId == categoryId).toList();
    }

    // Filter by farming year
    if (farmingYear != null) {
      filteredItems = filteredItems
          .where((item) => item.farmingYear == farmingYear)
          .toList();
    }

    // Filter by quantity
    if (quantity != null) {
      filteredItems = filteredItems
          .where((item) => item.availQuantity == quantity)
          .toList();
    }

    return filteredItems;
  }
}
