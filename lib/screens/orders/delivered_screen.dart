import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/app_colors.dart';
import '../../models/order_items.dart';
import '../../provider/order_item_provider.dart';

class DeliveredOrdersScreen extends ConsumerStatefulWidget {
  // Use ConsumerStatefulWidget
  const DeliveredOrdersScreen({super.key});

  @override
  DeliveredOrdersScreenState createState() => DeliveredOrdersScreenState();
}

class DeliveredOrdersScreenState extends ConsumerState<DeliveredOrdersScreen>
    with SingleTickerProviderStateMixin {
  // Add SingleTickerProviderStateMixin
  late String farmId;
  // Remove _deliveredOrdersFuture
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserFarmId();

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrentUserFarmId() async {
    final userId = FirebaseAuth.instance.currentUser;
    // String? userId =
    //     ref.read(user).currentUser?.uid; // Best practice
    if (userId != null) {
      setState(() {
        farmId = userId.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use ref.watch with the filtered provider
    final deliveredOrdersAsyncValue =
        ref.watch(filteredOrderItemsProvider('delivered'));

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground, // Consistent background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            CupertinoIcons.back,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.delivered_items,
          style: GoogleFonts.poppins(
            // Consistent font
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(
                filteredOrderItemsProvider('delivered')); // Refresh data
          },
          color: AppColors.accentColor,
          child: Padding(
            // Add padding
            padding: const EdgeInsets.all(16.0),
            child: deliveredOrdersAsyncValue.when(
              // Use .when for AsyncValue
              data: (orderItems) {
                if (orderItems.isEmpty) {
                  return _buildEmptyState(context); // Show empty state
                }
                return _buildOrdersList(orderItems); // Build the list
              },
              loading: () => _buildLoadingState(), // Show loading indicator
              error: (error, stackTrace) => _buildErrorState(
                  context, error.toString()), // Show error message
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<OrderItem> orderItems) {
    return ListView.builder(
      itemCount: orderItems.length,
      itemBuilder: (context, index) {
        final orderItem = orderItems[index];
        return _buildOrderItemCard(orderItem); // Use a helper function
      },
    );
  }

  Widget _buildOrderItemCard(OrderItem orderItem) {
    final formattedDate =
        DateFormat('MMM d, yyyy h:mm a').format(orderItem.orderDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          // Use ExpansionTile
          title: Text(
            orderItem.itemName,
            style: GoogleFonts.poppins(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            formattedDate,
            style: GoogleFonts.poppins(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          leading: Container(
              // Consistent leading icon
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.check_circle,
                  color: AppColors.success) // Delivered icon
              ),
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: [
            // Details inside the expanded tile
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Quantity:",
                    style: GoogleFonts.poppins(
                        color: AppColors.textSecondary, fontSize: 14)),
                Text(orderItem.quantity.toString(),
                    style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Price:",
                    style: GoogleFonts.poppins(
                        color: AppColors.textSecondary, fontSize: 14)),
                Text('NGN${orderItem.itemPrice}',
                    style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total:",
                    style: GoogleFonts.poppins(
                        color: AppColors.textSecondary, fontSize: 14)),
                Text('NGN${(orderItem.itemPrice * orderItem.quantity)}',
                    style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
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
            'Error loading delivered orders',
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
              ref.invalidate(filteredOrderItemsProvider('delivered'));
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.delivery_dining, // A delivery icon
            size: 80,
            color: AppColors.textSecondary.withAlpha(128),
          ),
          const SizedBox(height: 16),
          Text(
            'No Delivered Orders',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Orders that have been marked as delivered will appear here.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
