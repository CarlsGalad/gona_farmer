import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderItemWatcher {
  late String _farmId;

  void startWatching() {
    try {
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
            .listen(
          (QuerySnapshot<Map<String, dynamic>> snapshot) {
            // Iterate through the delivered order items
            snapshot.docChanges.forEach((change) async {
              try {
                // Check if the status changed to "delivered"
                if (change.doc['status'] == 'delivered') {
                  // Get the item price and increment totalEarnings by the item price
                  int itemPrice = change.doc['price'] ?? 0;

                  await _incrementTotalEarnings(itemPrice);

                  // Increment totalSales by quantity
                  int itemQuantity = change.doc['quantity'] ?? 0;
                  await _incrementTotalSales(itemQuantity);
                  // Add sale data to the sales collection
                  await _addSaleToSalesCollection(change.doc['itemId'],
                      itemQuantity, change.doc['itemFarm']);
                }
              } catch (e) {
                print('Error processing order item change: $e');
              }
            });
          },
          onError: (error) {
            print('Error listening to orderItems: $error');
          },
        );
      }
    } catch (e) {
      print('Error in OrderItemWatcher.startWatching: $e');
    }
  }

  Future<void> _incrementTotalEarnings(int incrementBy) async {
    try {
      // Check if farm document exists first
      DocumentSnapshot farmDoc = await FirebaseFirestore.instance
          .collection('farms')
          .doc(_farmId)
          .get();

      if (farmDoc.exists) {
        // Increment totalEarnings by the provided value
        await FirebaseFirestore.instance
            .collection('farms')
            .doc(_farmId)
            .update({
          'totalEarnings': FieldValue.increment(incrementBy),
        });
      } else {
        // Create the document if it doesn't exist
        await FirebaseFirestore.instance.collection('farms').doc(_farmId).set({
          'totalEarnings': incrementBy,
          'totalSales': 0,
        });
      }
    } catch (e) {
      print('Error incrementing total earnings: $e');
    }
  }

  Future<void> _incrementTotalSales(int incrementBy) async {
    try {
      // Check if farm document exists first
      DocumentSnapshot farmDoc = await FirebaseFirestore.instance
          .collection('farms')
          .doc(_farmId)
          .get();

      if (farmDoc.exists) {
        // Increment totalSales by the provided value
        await FirebaseFirestore.instance
            .collection('farms')
            .doc(_farmId)
            .update({
          'totalSales': FieldValue.increment(incrementBy),
        });
      }
      // No else block needed since _incrementTotalEarnings will have created the document if needed
    } catch (e) {
      print('Error incrementing total sales: $e');
    }
  }

  Future<void> _addSaleToSalesCollection(
      String itemId, int quantity, String itemFarm) async {
    try {
      // Get the current date and time
      Timestamp saleDate = Timestamp.now();

      // Create the sales collection if it doesn't exist and add a document
      await FirebaseFirestore.instance.collection('sales').add({
        'farmId': _farmId,
        'itemId': itemId,
        'quantity': quantity,
        'saleDate': saleDate,
        'itemFarm': itemFarm,
        'price':
            0, // Adding a default price field since it's used in the charts
      });
    } catch (e) {
      print('Error adding sale to sales collection: $e');
    }
  }
}
