import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'add_item.dart';
import 'edit_items.dart';

class InventoryManagementPage extends StatefulWidget {
  const InventoryManagementPage({super.key});

  @override
  InventoryManagementPageState createState() => InventoryManagementPageState();
}

class InventoryManagementPageState extends State<InventoryManagementPage> {
  late String _farmId;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _inventoryStream;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserFarmId();
  }

  Future<void> _deleteItem(String itemId) async {
    try {
      // Step 1: Get the document to retrieve the image URL
      DocumentSnapshot itemDoc = await FirebaseFirestore.instance
          .collection('Items')
          .doc(itemId)
          .get();

      if (itemDoc.exists) {
        String? imagePath = itemDoc['imagePath'];

        // Step 2: Delete the file from Firebase Storage if imagePath is not null
        if (imagePath != null && imagePath.isNotEmpty) {
          final storageRef = FirebaseStorage.instance.refFromURL(imagePath);
          await storageRef.delete();
        }

        // Step 3: Delete the Firestore document
        await FirebaseFirestore.instance
            .collection('Items')
            .doc(itemId)
            .delete();

        if (!mounted) return;

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalizations.of(context)!.item_deleted_successfully),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Document does not exist');
      }
    } catch (error) {
      if (!mounted) return;

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${AppLocalizations.of(context)!.error_deleting_item} $error'),
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
      _inventoryStream = FirebaseFirestore.instance
          .collection('Items')
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
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.inventory_management,
          style: GoogleFonts.aboreto(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _inventoryStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${AppLocalizations.of(context)!.error}: '
                  ' ${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  size: 50, color: Colors.green.shade100),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child:
                  Text(AppLocalizations.of(context)!.no_inventory_items_found),
            );
          }
          // Display inventory items
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> itemData =
                  document.data() as Map<String, dynamic>; // Cast here
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Card(
                  elevation: 5,
                  color: Colors.green.shade100,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
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
                    title: Text(
                      itemData['name'],
                      style: GoogleFonts.abel(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          ' ${AppLocalizations.of(context)!.price_with_column} ${itemData['price']}',
                          style: GoogleFonts.abel(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text('${itemData['sellingMethod'] ?? ''}')
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Color.fromARGB(255, 88, 3, 3),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                  AppLocalizations.of(context)!.confirm_delete),
                              content: Text(AppLocalizations.of(context)!
                                  .confirm_delete_question),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.cancel),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Perform delete operation
                                    _deleteItem(document.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.delete),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      // Add FloatingActionButton to add new inventory items
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a screen to add new inventory items
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddItemScreen(),
            ),
          );
        },
        backgroundColor: Colors.green.shade100,
        child: const Icon(Icons.add),
      ),
    );
  }
}
