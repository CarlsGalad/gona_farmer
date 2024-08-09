import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
          AppLocalizations.of(context)!.ordered_items,
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
                  return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                          size: 50, color: Colors.green.shade100));
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text(
                          '${AppLocalizations.of(context)!.error} ${snapshot.error}'));
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
                        child: Card(
                          elevation: 5,
                          color: Colors.green.shade100,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: ListTile(
                            title: Text(
                              orderItem['item_name'] ?? 'Item Name',
                              style: GoogleFonts.abel(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${AppLocalizations.of(context)!.quantity} ${orderItem['quantity']}, Price: \$${orderItem['item_price']}',
                              style: GoogleFonts.abel(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
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
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.prepare_items_for_shipping,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15),
                    ),
                    const SizedBox(width: 7),
                    // ignore: prefer_const_constructors
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
    } catch (error) {
      rethrow;
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
      rethrow;
    }
  }
}
