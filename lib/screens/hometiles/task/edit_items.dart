import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class EditItemDetailsPage extends StatefulWidget {
  final String itemId;

  const EditItemDetailsPage({super.key, required this.itemId});

  @override
  EditItemDetailsPageState createState() => EditItemDetailsPageState();
}

class EditItemDetailsPageState extends State<EditItemDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // Add controllers for other fields as needed

  @override
  void initState() {
    super.initState();
    _fetchItemDetails();
  }

  Future<void> _fetchItemDetails() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Items')
          .doc(widget.itemId)
          .get();

      Map<String, dynamic> itemData = snapshot.data() ?? {};

      setState(() {
        _nameController.text = itemData['name'] ?? '';
        _priceController.text = (itemData['price'] ?? 0).toString();
        _descriptionController.text = itemData['description'] ?? '';
        // Initialize other controllers with item data
      });
    } catch (error) {
      print('Error fetching item details: $error');
    }
  }

  Future<void> _updateItemDetails() async {
    try {
      await FirebaseFirestore.instance
          .collection('items')
          .doc(widget.itemId)
          .update({
        'name': _nameController.text.trim(),
        'price': int.parse(_priceController.text.trim()),
        'description': _descriptionController.text.trim(),
        // Update other fields as needed
      });
      // Show a success message or navigate back to the previous screen
    } catch (error) {
      print('Error updating item details: $error');
      // Show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Edit Item Details',
          style: GoogleFonts.aboreto(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateItemDetails,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: null,
            ),
            // Add other text fields for additional item details
          ],
        ),
      ),
    );
  }
}
