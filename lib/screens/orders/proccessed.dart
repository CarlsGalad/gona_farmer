import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../models/order_items.dart';
import '../../provider/order_item_provider.dart';

class ProcessedOrdersScreen extends ConsumerStatefulWidget {
  const ProcessedOrdersScreen({super.key});

  @override
  ProcessedOrdersScreenState createState() => ProcessedOrdersScreenState();
}

class ProcessedOrdersScreenState extends ConsumerState<ProcessedOrdersScreen>
    with SingleTickerProviderStateMixin {
  late String farmId;
  // Remove _processedOrdersFuture, we'll use Riverpod
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

  // Keep this method to get the farmId, but remove the Future
  Future<void> _fetchCurrentUserFarmId() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      setState(() {
        farmId = userId;
      });
      // No need to fetch data here, Riverpod will handle it
    }
  }

  // No more _refreshOrders, Riverpod handles updates

  @override
  Widget build(BuildContext context) {
    // Use ref.watch to listen to the provider
    final processedOrdersAsyncValue =
        ref.watch(filteredOrderItemsProvider('prepared'));

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text(
          AppLocalizations.of(context)?.processed_orders ?? 'Processed Orders',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(filteredOrderItemsProvider('prepared'));
          },
          color: AppColors.accentColor,
          child: processedOrdersAsyncValue.when(
            // Use .when for AsyncValue
            data: (orders) {
              if (orders.isEmpty) {
                return _buildEmptyState();
              }
              return _buildOrdersList(orders);
            },
            loading: () => _buildLoadingState(),
            error: (error, stackTrace) => _buildErrorState(error.toString()),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppColors.accentColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading orders...',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 60,
              color: AppColors.error.withAlpha(182),
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading orders',
              style: GoogleFonts.poppins(
                fontSize: 20,
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
                ref.invalidate(filteredOrderItemsProvider('prepared'));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
              Icons.inventory_2_outlined,
              size: 80,
              color: AppColors.textSecondary.withAlpha(128),
            ),
            const SizedBox(height: 16),
            Text(
              'No Processed Orders',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Orders that have been processed will appear here',
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

  Widget _buildOrdersList(List<OrderItem> orders) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final orderItem = orders[index];
        return _buildOrderCard(orderItem); // Pass the OrderItem object
      },
    );
  }

  Widget _buildOrderCard(OrderItem orderItem) {
    // Receives OrderItem
    final formattedDate =
        DateFormat('MMM d, yyyy h:mm a').format(orderItem.orderDate);
    final processedDate = DateFormat('MMM d, yyyy h:mm a')
        .format(orderItem.lastUpdate ?? DateTime.now());

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.inventory_2_outlined, // Consistent icon
                  color: AppColors.accentColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    orderItem.itemName, // Use OrderItem fields
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accentColor.withAlpha(52),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Processed',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  icon: Icons.attach_money,
                  label: 'Price',
                  value:
                      'NGN ${NumberFormat('#,###').format(orderItem.itemPrice)}',
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  icon: Icons.shopping_basket_outlined,
                  label: 'Quantity',
                  value: '${orderItem.quantity} units',
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  icon: Icons.access_time,
                  label: 'Ordered on',
                  value: formattedDate,
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  icon: Icons.access_time_filled,
                  label: 'Processed on',
                  value: processedDate,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
