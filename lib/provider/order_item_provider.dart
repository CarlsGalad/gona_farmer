import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gona_vendor/models/order_items.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';

part 'order_item_provider.g.dart';


@riverpod
CollectionReference<Map<String, dynamic>> orderItemCollection(Ref ref) {
  return FirebaseFirestore.instance.collection('orderItems');
}

// 2.  Add Order Item
@riverpod
Future<void> addOrderItem(Ref ref, OrderItem orderItem) async {
  final collection = ref.read(orderItemCollectionProvider);
  await collection.add(orderItem.toFirestore());
}

// 3. Fetch All Order Items (Stream)
@riverpod
Stream<List<OrderItem>> allOrderItems(Ref ref) {
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  final collection = ref.watch(orderItemCollectionProvider);
  return collection
      .orderBy('order_date', descending: true)
       .where('farmId', isEqualTo: userId) // Order by date
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => OrderItem.fromFirestore(doc)).toList());
}

// 4. Filtered Order Items (Stream - by status)
@riverpod
Stream<List<OrderItem>> filteredOrderItems(
    Ref ref, String status) {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
  final collection = ref.watch(orderItemCollectionProvider);
  return collection
      .where('status', isEqualTo: status)
       .where('farmId', isEqualTo: userId)
      .orderBy('order_date', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => OrderItem.fromFirestore(doc)).toList());
}

// 5. Single Order Item by ID (Future)
@riverpod
Future<OrderItem?> orderItemById(
    Ref ref, String orderItemId) async {
  final collection = ref.read(orderItemCollectionProvider);
  final doc = await collection.doc(orderItemId).get();
  if (doc.exists) {
    return OrderItem.fromFirestore(doc);
  } else {
    return null; //Or throw an exception
  }
}


@riverpod
Future<void> updateOrderItemStatus(
    Ref ref, String orderItemId, String newStatus) async {
  final collection = ref.read(orderItemCollectionProvider);
  await collection.doc(orderItemId).update({
    'status': newStatus,
    'last_update': Timestamp.now(), // Always update last_update
  });
}

// 7.  Update the W1hole OrderItem (Future)
@riverpod
Future<void> updateOrderItem(
    Ref ref, String orderItemId, OrderItem updatedItem) async {
  final collection = ref.read(orderItemCollectionProvider);
  await collection.doc(orderItemId).update(updatedItem.toFirestore());
}

//New provider for orderItems by Order ID
@riverpod
Stream<List<OrderItem>> orderItemsByOrderId(Ref ref, String orderId) {
  final collection = ref.watch(orderItemCollectionProvider);
  return collection
      .where('order_id', isEqualTo: orderId)
      
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => OrderItem.fromFirestore(doc)).toList());
}

@riverpod
Future<int> orderCount(Ref ref) async {
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId != null) {
    QuerySnapshot<Map<String, dynamic>> ordersSnapshot = await ref
        .watch(orderItemCollectionProvider)
        .where('farmId', isEqualTo: userId)
        .where('status', isEqualTo: 'placed')
        .get();
    return ordersSnapshot.docs.length;
  }
  return 0;
}

@riverpod
Future<int> processedOrdersCount(Ref ref) async {
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId != null) {
    QuerySnapshot<Map<String, dynamic>> processedOrdersSnapshot = await ref
        .watch(orderItemCollectionProvider)
        .where('farmId', isEqualTo: userId)
        .where('status', isEqualTo: 'prepared')
        .get();
    return processedOrdersSnapshot.docs.length;
  }
  return 0;
}

@riverpod
Future<int> deliveredCount(Ref ref) async {
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId != null) {
    QuerySnapshot<Map<String, dynamic>> deliveredOrderItemsSnapshot = await ref
        .watch(orderItemCollectionProvider)
        .where('farmId', isEqualTo: userId)
        .where('status', isEqualTo: 'delivered')
        .get();
    return deliveredOrderItemsSnapshot.docs.length;
  }
  return 0;
}
