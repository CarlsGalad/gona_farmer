import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemDetailPage extends StatelessWidget {
  final String orderId;

  const ItemDetailPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Items'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchOrderItemsData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Map<String, dynamic>> orderItemsData =
                      snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: orderItemsData.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> orderItem = orderItemsData[index];
                      return ListTile(
                        title: Text(orderItem['item_name'] ?? 'Item Name'),
                        subtitle: Text(
                            'Quantity: ${orderItem['quantity']}, Price: \$${orderItem['item_price']}'),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 100,
        color: Colors.white60,
        child: ElevatedButton(
          onPressed: () {
            _prepareItemsForShipping(orderId);
          },
          child: const Text('Prepare Items for Shipping'),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchOrderItemsData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('orderItems')
              .where('order_id', isEqualTo: orderId)
              .get();

      List<Map<String, dynamic>> orderItemsData = [];
      querySnapshot.docs.forEach((doc) {
        orderItemsData.add(doc.data());
      });

      return orderItemsData;
    } catch (error) {
      rethrow;
    }
  }

  void _prepareItemsForShipping(String orderId) async {
    try {
      // Fetch order items for the given order ID
      QuerySnapshot<Map<String, dynamic>> orderItemsSnapshot =
          await FirebaseFirestore.instance
              .collection('orderItems')
              .where('order_id', isEqualTo: orderId)
              .get();

      // Update status of each order item to "prepared" and adjust inventory levels
      WriteBatch batch = FirebaseFirestore.instance.batch();
      for (QueryDocumentSnapshot<Map<String, dynamic>> orderItemDoc
          in orderItemsSnapshot.docs) {
        // Update status of order item to "prepared"
        batch.update(orderItemDoc.reference, {'status': 'prepared'});

        // Decrease inventory levels for the product
        String itemId = orderItemDoc.data()['item_id'];
        int quantity = orderItemDoc.data()['quantity'];
        await _decreaseInventory(itemId, quantity, batch);
      }

      // Commit the batch update
      await batch.commit();

      print('Items prepared for shipping and inventory updated successfully.');
    } catch (error) {
      print('Error preparing items for shipping: $error');
    }
  }

  Future<void> _decreaseInventory(
      String itemId, int quantity, WriteBatch batch) async {
    try {
      // Fetch current inventory level of the product
      DocumentSnapshot<Map<String, dynamic>> productDoc =
          await FirebaseFirestore.instance
              .collection('inventory')
              .doc(itemId)
              .get();

      // Check if the product exists in the inventory
      if (productDoc.exists) {
        int currentQuantity = productDoc.data()?['quantity'] ?? 0;
        if (currentQuantity >= quantity) {
          // Decrease inventory level by the shipped quantity
          int newQuantity = currentQuantity - quantity;
          batch.update(productDoc.reference, {'quantity': newQuantity});
        } else {
          print('Insufficient inventory for product with ID: $itemId');
        }
      } else {
        print('Product with ID: $itemId not found in inventory.');
      }
    } catch (error) {
      print('Error decreasing inventory for product with ID: $itemId');
      rethrow;
    }
  }
}
