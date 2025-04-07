import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';

import '../models/item.dart';

part 'item_provider.g.dart';

/// Provider for the Items collection in Firestore
@riverpod
CollectionReference<Map<String, dynamic>> itemCollection(Ref ref) {
  return FirebaseFirestore.instance.collection('Items');
}

/// Creates a new item in the database
@riverpod
Future<void> createItem(Ref ref, Item newItem) async {
  try {
    final collection = ref.read(itemCollectionProvider);
    await collection.add(newItem.toFirestore());
  } catch (e) {
    throw Exception('Failed to create item: ${e.toString()}');
  }
}

/// Streams all items from the database
@riverpod
Stream<List<Item>> allItems(Ref ref) {
  final collection = ref.watch(itemCollectionProvider);
  return collection.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList();
  });
}

/// Fetches a single item by ID
@riverpod
Future<Item?> itemById(Ref ref, String itemId) async {
  try {
    final collection = ref.read(itemCollectionProvider);
    final doc = await collection.doc(itemId).get();
    if (doc.exists) {
      return Item.fromFirestore(doc);
    } else {
      return null;
    }
  } catch (e) {
    throw Exception('Failed to fetch item: ${e.toString()}');
  }
}

/// Updates an existing item in the database
@riverpod
Future<void> updateItem(Ref ref, String itemId, Item updatedItem) async {
  try {
    final collection = ref.read(itemCollectionProvider);
    await collection.doc(itemId).update(updatedItem.toFirestore());
  } catch (e) {
    throw Exception('Failed to update item: ${e.toString()}');
  }
}

/// Deletes an item from the database
@riverpod
Future<void> deleteItem(Ref ref, String itemId) async {
  try {
    final collection = ref.read(itemCollectionProvider);
    await collection.doc(itemId).delete();
  } catch (e) {
    throw Exception('Failed to delete item: ${e.toString()}');
  }
}

/// Toggles the paused status of an item
@riverpod
Future<void> toggleItemPaused(Ref ref, String itemId) async {
  try {
    final collection = ref.read(itemCollectionProvider);
    final item = await ref.read(itemByIdProvider(itemId).future);

    if (item != null) {
      final updatedItem = item.copyWith(isPaused: !item.isPaused);
      await collection.doc(itemId).update(updatedItem.toFirestore());
    } else {
      throw Exception('Item not found');
    }
  } catch (e) {
    throw Exception('Failed to toggle item status: ${e.toString()}');
  }
}

@riverpod
Future<void> decreaseInventory(Ref ref, String itemId, int quantity) async {
  try {
    final collection = ref.read(itemCollectionProvider);
    final itemDoc = await collection.doc(itemId).get();

    if (itemDoc.exists) {
      final item = Item.fromFirestore(itemDoc);
      final newQuantity = item.availQuantity - quantity;

      if (newQuantity < 0) {
        throw Exception("Not enough quantity available");
      }

      final updatedItem = item.copyWith(availQuantity: newQuantity);
      await collection.doc(itemId).update(updatedItem.toFirestore());
    } else {
      throw Exception("Item not found");
    }
  } catch (e) {
    throw Exception('Failed to decrease inventory: ${e.toString()}');
  }
}

/// Streams items filtered by farm ID
@riverpod
Stream<List<Item>> itemsByFarm(Ref ref, String farmId) {
  final collection = ref.watch(itemCollectionProvider);
  print(collection);
  return collection
      .where('farmId', isEqualTo: farmId)
      .snapshots()
      .map((snapshot) {
    print(snapshot.docs);
    return snapshot.docs.map((doc) {
      print(doc);
      return Item.fromFirestore(doc);
    }).toList();
  });
}

/// Streams items filtered by category ID
@riverpod
Stream<List<Item>> itemsByCategory(Ref ref, int categoryId) {
  final collection = ref.watch(itemCollectionProvider);
  return collection.where('categoryId', isEqualTo: categoryId).snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList());
}

/// Streams promotional items
@riverpod
Stream<List<Item>> promoItems(Ref ref) {
  final collection = ref.watch(itemCollectionProvider);
  return collection.where('label', isEqualTo: 'promo').snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList());
}

/// Streams items with low inventory (less than threshold)
@riverpod
Stream<List<Item>> lowInventoryItems(Ref ref, {int threshold = 5}) {
  final collection = ref.watch(itemCollectionProvider);
  return collection
      .where('availQuantity', isLessThanOrEqualTo: threshold)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList());
}



/// Increases the inventory quantity of an item
@riverpod
Future<void> increaseInventory(Ref ref, String itemId, int quantity) async {
  try {
    final collection = ref.read(itemCollectionProvider);
    final itemDoc = await collection.doc(itemId).get();

    if (itemDoc.exists) {
      final item = Item.fromFirestore(itemDoc);
      final newQuantity = item.availQuantity + quantity;

      final updatedItem = item.copyWith(availQuantity: newQuantity);
      await collection.doc(itemId).update(updatedItem.toFirestore());
    } else {
      throw Exception("Item not found");
    }
  } catch (e) {
    throw Exception('Failed to increase inventory: ${e.toString()}');
  }
}

/// Searches for items by name
@riverpod
Stream<List<Item>> searchItems(Ref ref, String query) {
  if (query.isEmpty) {
    return Stream.value([]);
  }

  final collection = ref.watch(itemCollectionProvider);
  final lowercaseQuery = query.toLowerCase();

  return collection.snapshots().map((snapshot) => snapshot.docs
      .map((doc) => Item.fromFirestore(doc))
      .where((item) => item.name.toLowerCase().contains(lowercaseQuery))
      .toList());
}
