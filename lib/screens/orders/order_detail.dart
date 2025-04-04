
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../models/order_items.dart';
import '../../provider/order_item_provider.dart';
import '../../provider/item_provider.dart';

class ItemDetailPage extends ConsumerStatefulWidget {
  final String orderId;

  const ItemDetailPage({super.key, required this.orderId});

  @override
  ConsumerState<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends ConsumerState<ItemDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isProcessing = false;

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderItemsAsyncValue =
        ref.watch(orderItemsByOrderIdProvider(widget.orderId));

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
          AppLocalizations.of(context)?.ordered_items ?? 'Ordered Items',
          style: GoogleFonts.abel(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: orderItemsAsyncValue.when(
            data: (orderItems) {
              if (orderItems.isEmpty) {
                return _buildEmptyState();
              }
              return _buildItemList(orderItems);
            },
            loading: () => _buildLoadingState(),
            error: (error, stackTrace) => _buildErrorState(error.toString()),
          ),
        ),
      ),
      bottomNavigationBar: orderItemsAsyncValue.maybeWhen(
        data: (orderItems) {
          if (orderItems.isEmpty) return null;

          bool allPrepared = orderItems.every((item) =>
              item.status == 'prepared' || item.status == 'delivered');

          if (allPrepared) return null;

          return _buildBottomNavigationBar(orderItems);
        },
        orElse: () => null,
      ),
    );
  }

  Widget _buildItemList(List<OrderItem> orderItems) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: orderItems.length,
      itemBuilder: (context, index) {
        final orderItem = orderItems[index];
        return _buildItemCard(orderItem);
      },
    );
  }

  Widget _buildItemCard(OrderItem orderItem) {
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
                  Icons.shopping_bag_outlined,
                  color: AppColors.accentColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    orderItem.itemName,
                    style: GoogleFonts.abel(
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
                    color: _getStatusColor(orderItem.status).withAlpha(52),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(orderItem.status),
                    style: GoogleFonts.abel(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(orderItem.status),
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
                  icon: Icons.calendar_today,
                  label:
                      AppLocalizations.of(context)?.order_date ?? 'Order Date',
                  value: formattedDate,
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  icon: Icons.shopping_basket_outlined,
                  label: AppLocalizations.of(context)?.quantity ?? 'Quantity',
                  value: '${orderItem.quantity} ${'units'}',
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  icon: Icons.attach_money,
                  label: AppLocalizations.of(context)?.price ?? 'Price',
                  value:
                      'NGN ${NumberFormat('#,###').format(orderItem.itemPrice)}',
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  icon: Icons.location_on_outlined,
                  label: AppLocalizations.of(context)?.farm_name ?? 'Farm',
                  value: orderItem.itemFarm,
                ),
              ],
            ),
          ),
          if (orderItem.status == 'placed') ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed:
                      _isProcessing ? null : () => _prepareItem(orderItem),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accentColor,
                    side: const BorderSide(color: AppColors.accentColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Prepare Item',
                    style: GoogleFonts.abel(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'placed':
        return 'Placed';
      case 'prepared':
        return 'Prepared';
      case 'delivered':
        return 'Delivered';
      default:
        return status.capitalize();
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'placed':
        return Colors.blue;
      case 'prepared':
        return Colors.orange;
      case 'delivered':
        return AppColors.success;
      default:
        return Colors.grey;
    }
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: GoogleFonts.abel(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.abel(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
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
            AppLocalizations.of(context)?.loading ?? 'Loading order items...',
            style: GoogleFonts.abel(
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
            AppLocalizations.of(context)?.error_fetching_item_details(error) ??
                'Error loading order details',
            style: GoogleFonts.abel(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: GoogleFonts.abel(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(orderItemsByOrderIdProvider(widget.orderId));
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
              AppLocalizations.of(context)?.retry ?? 'Try Again',
              style: GoogleFonts.abel(
                fontWeight: FontWeight.bold,
              ),
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
              Icons.info_outline,
              size: 80,
              color: AppColors.textSecondary.withAlpha(128),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)?.error_fetching_details ??
                  'No Order Items',
              style: GoogleFonts.abel(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)?.no_details_found ??
                  'There are no items associated with this order.',
              textAlign: TextAlign.center,
              style: GoogleFonts.abel(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(List<OrderItem> orderItems) {
    // Filter out items that are already prepared or delivered
    final unpreparedItems =
        orderItems.where((item) => item.status == 'placed').toList();

    if (unpreparedItems.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed:
            _isProcessing ? null : () => _prepareAllItems(unpreparedItems),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.accentColor.withAlpha(156),
          disabledForegroundColor: Colors.white.withAlpha(201),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        icon: _isProcessing
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.check_circle_outline),
        label: Text(
          AppLocalizations.of(context)?.prepare_items_for_shipping ??
              'Prepare Items for Shipping',
          style: GoogleFonts.abel(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Future<void> _prepareItem(OrderItem orderItem) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Update the status of the order item
      await ref.read(
          updateOrderItemStatusProvider(orderItem.orderId, 'prepared').future);

      // Decrease inventory levels
      await ref.read(
          decreaseInventoryProvider(orderItem.itemId, orderItem.quantity)
              .future);

      // Refresh the order items list
      ref.invalidate(orderItemsByOrderIdProvider(widget.orderId));

      if (mounted) {
        _showSuccessSnackBar("Item prepared for shipping");
      }
    } catch (error) {
      if (mounted) {
        _showErrorSnackBar(
            "${AppLocalizations.of(context)?.error_updating_item_details(error) ?? 'Error preparing item'}: $error");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _prepareAllItems(List<OrderItem> orderItems) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // WriteBatch batch = FirebaseFirestore.instance.batch();

      for (final orderItem in orderItems) {
        // Update the status of each order item
        await ref.read(
            updateOrderItemStatusProvider(orderItem.orderId, 'prepared')
                .future);

        // Decrease inventory levels for each product
        await ref.read(
            decreaseInventoryProvider(orderItem.itemId, orderItem.quantity)
                .future);
      }

      // Refresh the order items list
      ref.invalidate(orderItemsByOrderIdProvider(widget.orderId));

      if (mounted) {
        _showSuccessSnackBar("Items prepared for shipping");

        // Navigate back after successful preparation
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }
    } catch (error) {
      if (mounted) {
        _showErrorSnackBar(
            "${AppLocalizations.of(context)?.error ?? 'Error preparing items'}: $error");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.abel(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.abel(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
