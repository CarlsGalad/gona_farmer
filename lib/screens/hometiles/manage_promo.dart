import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gona_vendor/screens/add_promo.dart';
import 'package:google_fonts/google_fonts.dart';

import '../edit_items.dart';

class PromoManagementPage extends StatefulWidget {
  const PromoManagementPage({super.key});

  @override
  PromoManagementPageState createState() => PromoManagementPageState();
}

class PromoManagementPageState extends State<PromoManagementPage> {
  late String _farmId;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _promoStream;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserFarmId();
  }

  Future<void> _deleteItem(String itemId) async {
    try {
      await FirebaseFirestore.instance.collection('Items').doc(itemId).delete();
      // Show success message or navigate to a different screen if needed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting item: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _fetchCurrentUserFarmId() async {
    // Get the current user's UID (farmId) from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      setState(() {
        _farmId = userId;
      });
      // Fetch inventory items for the current user's farmId
      _promoStream = FirebaseFirestore.instance
          .collection('promotions')
          .where('farmId', isEqualTo: _farmId)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Promotions Management',
          style: GoogleFonts.aboreto(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _promoStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No promotions items found.'),
            );
          }
          // Display inventory items
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> itemData =
                  document.data() as Map<String, dynamic>; // Cast here
              return GestureDetector(
                onTap: () {},
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditItemDetailsPage(itemId: document.id),
                      ),
                    );
                  },
                  title: Text(itemData['name']),
                  subtitle: Text('Price: ${itemData['price']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                                'Are you sure you want to delete this item?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Perform delete operation
                                  _deleteItem(document.id);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  // Add more details as needed
                ),
              );
            }).toList(),
          );
        },
      ),
      // Add FloatingActionButton to add new inventory items
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPromoScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
