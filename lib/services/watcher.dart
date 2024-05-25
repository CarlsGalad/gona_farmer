import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderItemWatcher {
  late String _farmId;

  void startWatching() {
    // Get the current user's UID from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      _farmId = userId;
      // Create a query to listen for changes in order items where the farmId matches and status is "delivered"
      FirebaseFirestore.instance
          .collection('orderItems')
          .where('farmId', isEqualTo: _farmId)
          .where('status', isEqualTo: 'delivered')
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
        // Iterate through the delivered order items
        snapshot.docChanges.forEach((change) async {
          // Check if the status changed to "delivered"
          if (change.doc['status'] == 'delivered') {
            // Get the item price and increment totalEarnings by the item price
            int itemPrice = change.doc['price'] ?? 0;

            await _incrementTotalEarnings(itemPrice);

            // Increment totalSales by quantity
            int itemQuantity = change.doc['quantity'] ?? 0;
            await _incrementTotalSales(itemQuantity);
            // Add sale data to the sales collection
            await _addSaleToSalesCollection(
                change.doc['itemId'], itemQuantity, change.doc['itemFarm']);
          }
        });
      });
    }
  }

  Future<void> _incrementTotalEarnings(int incrementBy) async {
    // Increment totalEarnings by the provided value
    await FirebaseFirestore.instance.collection('farms').doc(_farmId).update({
      'totalEarnings': FieldValue.increment(incrementBy),
    });
  }

  Future<void> _incrementTotalSales(int incrementBy) async {
    // Increment totalSales by the provided value
    await FirebaseFirestore.instance.collection('farms').doc(_farmId).update({
      'totalSales': FieldValue.increment(incrementBy),
    });
  }

  Future<void> _addSaleToSalesCollection(
      String itemId, int quantity, String itemFarm) async {
    // Get the current date and time
    Timestamp saleDate = Timestamp.now();

    // Add the sale to the sales collection
    await FirebaseFirestore.instance.collection('sales').add({
      'farmId': _farmId,
      'itemId': itemId,
      'quantity': quantity,
      'saleDate': saleDate,
      'itemFarm': itemFarm,
    });
  }
}
