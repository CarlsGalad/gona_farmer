import 'package:cloud_firestore/cloud_firestore.dart';



class OrderItem {
  final String orderId;
  final String itemId;
  final int quantity;
  final double itemPrice;
  final String farmId;
  final DateTime orderDate;
  final String itemName;
  final String status;
  final String itemFarm;
  final DateTime? lastUpdate; // Nullable DateTime

  OrderItem({
    required this.orderId,
    required this.itemId,
    required this.quantity,
    required this.itemPrice,
    required this.farmId,
    required this.orderDate,
    required this.itemName,
    required this.status,
    required this.itemFarm,
    this.lastUpdate,
  });

  // Convert Firestore document to OrderItem
  factory OrderItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return OrderItem(
      orderId: data['order_id'] as String,
      itemId: data['item_id'] as String,
      quantity: data['quantity'] as int,
      itemPrice: (data['item_price'] as num).toDouble(), // Handle num
      farmId: data['farmId'] as String,
      orderDate: (data['order_date'] as Timestamp).toDate(),
      itemName: data['item_name'] as String,
      status: data['status'] as String,
      itemFarm: data['itemFarm'] as String,
      lastUpdate: (data['last_update'] as Timestamp?)
          ?.toDate(), // Handle potential null
    );
  }

  // Convert OrderItem to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'order_id': orderId,
      'item_id': itemId,
      'quantity': quantity,
      'item_price': itemPrice,
      'farmId': farmId,
      'order_date':
          Timestamp.fromDate(orderDate), // Convert DateTime to Timestamp
      'item_name': itemName,
      'status': status,
      'itemFarm': itemFarm,
      'last_update':
          lastUpdate != null ? Timestamp.fromDate(lastUpdate!) : null,
    };
  }
}