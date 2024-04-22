import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemDetailPage extends StatelessWidget {
  final String orderId;

  const ItemDetailPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            CupertinoIcons.back,
          ),
        ),
        title: Text(
          'Order Items',
          style: GoogleFonts.aboreto(fontWeight: FontWeight.bold),
        ),
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 4),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: ListTile(
                            title: Text(
                              orderItem['item_name'] ?? 'Item Name',
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              'Quantity: ${orderItem['quantity']}, Price: \$${orderItem['item_price']}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
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
        height: 80,
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
          child: GestureDetector(
            onTap: () async {
              try {
                _prepareItemsForShipping(orderId);
              } finally {
                Navigator.pop(context);
              }
            },
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(15)),
                child: const Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Prepare Items for Shipping',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15),
                    ),
                    SizedBox(width: 7),
                    Icon(
                      Icons.send,
                      color: Colors.white,
                    )
                  ],
                ))),
          ),
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
              .collection('Items')
              .doc(itemId)
              .get();

      // Check if the product exists in the inventory
      if (productDoc.exists) {
        int currentQuantity = productDoc.data()?['availQuantity'] ?? 0;
        if (currentQuantity >= quantity) {
          // Decrease inventory level by the shipped quantity
          int newQuantity = currentQuantity - quantity;
          batch.update(productDoc.reference, {'availQuantity': newQuantity});
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
