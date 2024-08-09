import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gona_vendor/screens/hometiles/task/add_promo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'edit_items.dart';

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
      await FirebaseFirestore.instance
          .collection('promotions')
          .doc(itemId)
          .delete();
      if (!mounted) return;
      // Show success message or navigate to a different screen if needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(AppLocalizations.of(context)!.item_deleted_successfully),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)!.error_deleting_item} '
              ' $error'),
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
          AppLocalizations.of(context)!.promotions_management,
          style: GoogleFonts.aboreto(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _promoStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  '${AppLocalizations.of(context)!.error} ${snapshot.error}'),
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
                  Text(AppLocalizations.of(context)!.no_promotions_items_found),
            );
          }
          // Display inventory items
          return Card(
            elevation: 5,
            color: Colors.green.shade100,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: ListView(
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
                    title: Text(
                      itemData['name'],
                      style: GoogleFonts.abel(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          '${AppLocalizations.of(context)!.price_with_column} '
                          ' ${itemData['price']}',
                          style: GoogleFonts.abel(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          '${itemData['sellingMethod'] ?? ''}',
                          style: GoogleFonts.abel(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
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
                                        AppLocalizations.of(context)!.cancel)),
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
                );
              }).toList(),
            ),
          );
        },
      ),
      //  FloatingActionButton to add new inventory items
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPromoScreen(),
            ),
          );
        },
        backgroundColor: Colors.green.shade100,
        child: const Icon(Icons.add),
      ),
    );
  }
}
