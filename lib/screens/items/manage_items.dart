import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../models/item.dart';
import '../../provider/item_provider.dart';
import 'add_item.dart';
import 'edit_items.dart';

class InventoryManagementPage extends ConsumerStatefulWidget {
  // Use ConsumerStatefulWidget
  const InventoryManagementPage({super.key});

  @override
  InventoryManagementPageState createState() => InventoryManagementPageState();
}

class InventoryManagementPageState
    extends ConsumerState<InventoryManagementPage>
    with SingleTickerProviderStateMixin {
  late String _farmId;
  // Remove _inventoryStream
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
    _fetchCurrentUserFarmId();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrentUserFarmId() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    debugPrint(userId);
    if (userId != null) {
      setState(() {
        _farmId = userId;
      });
    }
  }

  Future<void> _deleteItem(String itemId) async {
    try {
      // Use the Riverpod provider to delete the item
      await ref.read(
          deleteItemProvider(itemId).future); // Use .future for FutureProviders

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(AppLocalizations.of(context)!.item_deleted_successfully),
            backgroundColor: AppColors.success, // Consistent color
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
      );
    } catch (error) {
      if (!mounted) return;

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${AppLocalizations.of(context)!.error_deleting_item} $error'),
            backgroundColor: AppColors.error, // Consistent color
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider for items by farm ID
    final itemsAsyncValue = ref.watch(itemsByFarmProvider(_farmId));


    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground, // Consistent background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.inventory_management,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 20,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(itemsByFarmProvider(_farmId));
              },
              color: AppColors.accentColor,
              child: itemsAsyncValue.when(
                data: (items) {
                  if (items.isEmpty) {
                    return _buildEmptyState(); // Show empty state
                  }
                  return _buildItemList(items);
                },
                loading: () => _buildLoadingState(),
                error: (error, stackTrace) =>
                    _buildErrorState(context, error.toString()),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add new inventory items (use GoRouter if you have it set up)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddItemScreen(),
            ),
          );
          // Example with GoRouter (if you have it set up):
          // context.goNamed(AppRoutes.addItem);
        },
        backgroundColor: AppColors.accentColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildItemList(List<Item> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildItemCard(item);
      },
    );
  }

  Widget _buildItemCard(Item item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          // Navigate to edit screen, passing the item ID
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditItemDetailsPage(itemId: item.id),
            ),
          );
        },
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.inventory, // Placeholder icon
            color: AppColors.accentColor,
            size: 30,
          ),
        ),
        title: Text(
          item.name,
          style: GoogleFonts.poppins(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Price: NGN ${NumberFormat("#,##0.00").format(item.price)}', // Format as currency
              style: GoogleFonts.poppins(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Available: ${item.availQuantity}',
              style: GoogleFonts.poppins(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min, // Important for Row inside ListTile
          children: [
            IconButton(
              icon: Icon(
                item.isPaused ? Icons.play_arrow : Icons.pause,
                color: item.isPaused ? Colors.green : Colors.orange,
              ), // Conditional icon
              onPressed: () async {
                // Use Riverpod to toggle pause/unpause
                await ref.read(toggleItemPausedProvider(item.id).future);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.error),
              onPressed: () {
                _showDeleteConfirmationDialog(
                    context, item.id); // Show confirmation dialog
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String itemId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.confirm_delete,
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(
            AppLocalizations.of(context)!.confirm_delete_question,
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: GoogleFonts.poppins(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                // Perform delete operation using Riverpod
                _deleteItem(itemId); // Use the provider function
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.delete,
                style: GoogleFonts.poppins(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.accentColor,
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 60,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading inventory',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(itemsByFarmProvider(_farmId));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Try Again',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory, // A suitable icon
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Items in Inventory',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add items to your inventory to manage them here.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
