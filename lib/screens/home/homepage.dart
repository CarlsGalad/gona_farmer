// ignore_for_file: unused_result

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import
import 'package:gona_vendor/screens/profile/profilescreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../models/user_model.dart';
import '../../provider/farm_provider.dart';
import '../../provider/order_item_provider.dart';
import '../help_center/help_center.dart';
import '../items/add_item.dart';
import '../items/add_promo.dart';
import '../items/manage_items.dart';
import '../items/manage_promo.dart';
import '../orders/delivered_screen.dart';
import '../orders/proccessed.dart';
import '../orders/order_list_screen.dart';
import '../settings/settings.dart';

class HomeScreen extends ConsumerStatefulWidget {
  // Use ConsumerStatefulWidget
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() =>
      _HomeScreenState(); // Use ConsumerState
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  final bool _isConnected = true;
  bool _showLastSixMonths = false;
  late TabController _tabController;

  // Added cached values
  FarmProfile? _cachedFarmProfile;
  int _cachedOrderCount = 0;
  int _cachedProcessedCount = 0;
  int _cachedDeliveredCount = 0;
  int _cachedTotalSales = 0;

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

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
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleChart() {
    setState(() {
      _showLastSixMonths = !_showLastSixMonths;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size; // Not used, can remove
    final farmProfileAsync = ref.watch(currentFarmProfileProvider);

    // Update the cached farm profile when new data is available
    farmProfileAsync.whenData((value) {
      if (value != null) {
        setState(() => _cachedFarmProfile = value);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: _isConnected
          ? SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: farmProfileAsync.when(
                  // Handle loading, error, and data
                  data: (farmProfile) {
                    if (farmProfile == null) {
                      return _buildErrorState(AppLocalizations.of(context)!
                          .user_data_not_found); // Or other appropriate message
                    }

                    return Column(
                      children: [
                        _buildAppBar(farmProfile), // Pass FarmProfile
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(13),
                                  blurRadius: 10,
                                  offset: const Offset(0, -5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                              child: RefreshIndicator(
                                color: AppColors.accentColor,
                                onRefresh: () async {
                                  // Refresh by refetching the provider.  .refresh is the key
                                  ref.refresh(currentFarmProfileProvider);
                                  ref.refresh(orderCountProvider);
                                  ref.refresh(processedOrdersCountProvider);
                                  ref.refresh(deliveredCountProvider);
                                },
                                child: ListView(
                                  padding: const EdgeInsets.only(top: 0),
                                  children: [
                                    _buildWelcomeSection(
                                        farmProfile), // Pass FarmProfile
                                    _buildStatisticsSection(),
                                    _buildEarningsSection(
                                        farmProfile), // Pass FarmProfile
                                    _buildChartSection(),
                                    _buildTasksSection(),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () {
                    // Use cached profile if available during loading
                    if (_cachedFarmProfile != null) {
                      return Column(
                        children: [
                          _buildAppBar(_cachedFarmProfile!),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(13),
                                    blurRadius: 10,
                                    offset: const Offset(0, -5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                                child: ListView(
                                  padding: const EdgeInsets.only(top: 0),
                                  children: [
                                    _buildWelcomeSection(_cachedFarmProfile!),
                                    _buildStatisticsSection(),
                                    _buildEarningsSection(_cachedFarmProfile!),
                                    _buildChartSection(),
                                    _buildTasksSection(),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                  error: (error, stack) => _buildErrorState('Error: $error'),
                ),
              ),
            )
          : _buildNoConnectionView(), // Implement if needed
    );
  }

  Widget _buildAppBar(FarmProfile farmProfile) {
    // Takes FarmProfile
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        color: AppColors.scaffoldBackground,
      ),
      child: Row(
        children: [
          _buildProfileImage(farmProfile), // Pass FarmProfile
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.appName,
              style: GoogleFonts.abel(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          _buildAppBarActions(),
        ],
      ),
    );
  }

  Widget _buildProfileImage(FarmProfile farmProfile) {
    // Takes FarmProfile
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()));
      },
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: farmProfile.imagePath.isNotEmpty // Use imagePath directly
              ? CachedNetworkImage(
                  imageUrl: farmProfile.imagePath,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => _buildProfilePlaceholder(),
                  errorWidget: (context, url, error) =>
                      _buildProfilePlaceholder(),
                )
              : _buildProfilePlaceholder(),
        ),
      ),
    );
  }

  Widget _buildProfilePlaceholder() {
    return const SizedBox(
      // Added SizedBox for fixed dimensions.
      width: 45,
      height: 45,
      child: Icon(Icons.person, color: AppColors.accentColor, size: 24),
    );
  }

  Widget _buildAppBarActions() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.textPrimary,
            size: 28,
          ),
          onPressed: () {
            // Navigate to notifications (Placeholder)
          },
        ),
        PopupMenuButton<String>(
          color: Colors.white,
          icon: const Icon(
            Icons.more_vert,
            color: AppColors.textPrimary,
            size: 28,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          onSelected: (String result) {
            // Handle menu selection
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            _buildPopupMenuItem('Profile', Icons.person_outline, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()));
            }),
            _buildPopupMenuItem('Settings', Icons.settings_outlined, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPrivacyPage()));
            }),
            _buildPopupMenuItem('Help', Icons.help_outline, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HelpCenterScreen()));
            }),
            _buildPopupMenuItem('Logout', Icons.logout, () {
              FirebaseAuth.instance.signOut();
            }, isDestructive: true),
          ],
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
      String title, IconData icon, void Function()? onTap,
      {bool isDestructive = false}) {
    return PopupMenuItem<String>(
      value: title,
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: isDestructive ? Colors.red : AppColors.accentColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color: isDestructive ? Colors.red : AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(FarmProfile farmProfile) {
    // Takes FarmProfile
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppLocalizations.of(context)!.welcome_back}, ${farmProfile.ownersName.split(' ').first}!', // Use ownersName
            style: GoogleFonts.abel(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.performance_chart,
            style: GoogleFonts.abel(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: AppLocalizations.of(context)!.orders_label,
                  icon: Icons.shopping_bag_outlined,
                  iconColor: Colors.orange,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OrderListScreen()),
                  ),
                  countFuture:
                      ref.watch(orderCountProvider.future), // Use the provider
                  cachedValue: _cachedOrderCount,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildStatCard(
                  title: AppLocalizations.of(context)!.processed_orders_label,
                  icon: Icons.access_time,
                  iconColor: Colors.blue,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProcessedOrdersScreen()),
                  ),
                  countFuture: ref.watch(
                      processedOrdersCountProvider.future), // Use the provider
                  cachedValue: _cachedProcessedCount,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: AppLocalizations.of(context)!.delivered_label,
                  icon: Icons.check_circle_outline,
                  iconColor: Colors.green,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DeliveredOrdersScreen()),
                  ),
                  countFuture: ref
                      .watch(deliveredCountProvider.future), // Use the provider
                  cachedValue: _cachedDeliveredCount,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildStatCard(
                  title: AppLocalizations.of(context)!.total_sales_label,
                  icon: Icons.bar_chart,
                  iconColor: Colors.purple,
                  onTap: () {},
                  countFuture: ref.watch(farmProfileByIdProvider(
                          FirebaseAuth.instance.currentUser!.uid)
                      .selectAsync((data) =>
                          int.parse(data?.totalSales ?? '0'))), // Use .future
                  cachedValue: _cachedTotalSales,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    required Future<int> countFuture,
    int cachedValue = 0,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: AppColors.border.withAlpha(128),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textSecondary.withAlpha(128),
                  size: 14,
                ),
              ],
            ),
            const SizedBox(height: 15),
            FutureBuilder<int>(
              future: countFuture,
              builder: (context, snapshot) {
                // Update cached value when new data arrives
                if (snapshot.hasData) {
                  if (title == AppLocalizations.of(context)!.orders_label) {
                    _cachedOrderCount = snapshot.data!;
                  } else if (title ==
                      AppLocalizations.of(context)!.processed_orders_label) {
                    _cachedProcessedCount = snapshot.data!;
                  } else if (title ==
                      AppLocalizations.of(context)!.delivered_label) {
                    _cachedDeliveredCount = snapshot.data!;
                  } else if (title ==
                      AppLocalizations.of(context)!.total_sales_label) {
                    _cachedTotalSales = snapshot.data!;
                  }
                }

                // Get the relevant cached value
                int valueToShow = cachedValue;
                if (title == AppLocalizations.of(context)!.orders_label) {
                  valueToShow = _cachedOrderCount;
                } else if (title ==
                    AppLocalizations.of(context)!.processed_orders_label) {
                  valueToShow = _cachedProcessedCount;
                } else if (title ==
                    AppLocalizations.of(context)!.delivered_label) {
                  valueToShow = _cachedDeliveredCount;
                } else if (title ==
                    AppLocalizations.of(context)!.total_sales_label) {
                  valueToShow = _cachedTotalSales;
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  if (valueToShow > 0) {
                    return Text(
                      valueToShow.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    );
                  }
                  return const SizedBox(
                    height: 30,
                    child: Center(
                      child: SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.accentColor,
                        ),
                      ),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Handle errors!
                }
                return Text(
                  snapshot.data?.toString() ?? '0',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                );
              },
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsSection(FarmProfile farmProfile) {
    // Takes FarmProfile
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () {
          // Navigate to earnings details
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.accentColor,
                AppColors.accentDark,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentColor.withAlpha(77),
                blurRadius: 15,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.total_earnings_label,
                    style: GoogleFonts.abel(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(52),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'NGN ${NumberFormat('#,###').format(int.parse(farmProfile.totalEarnings ?? '0'))}', // Use totalEarnings
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(52),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '12%', // TODO: Placeholder, implement logic for increase/decrease
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'from last month', // TODO: Placeholder, implement logic for time period
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withAlpha(203),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.performance_chart,
                style: GoogleFonts.abel(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: _toggleChart,
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: Text(
                  _showLastSixMonths
                      ? AppLocalizations.of(context)!.show_this_week
                      : AppLocalizations.of(context)!.show_last_six_months,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            height: 300,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(
                color: AppColors.border.withAlpha(128),
                width: 1,
              ),
            ),
            child: _showLastSixMonths
                ? const LineChartWidget() // Placeholder for monthly chart
                : const WeekLineChartWidget(), // Placeholder for weekly chart
          ),
        ],
      ),
    );
  }

  Widget _buildTasksSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.todays_task,
            style: GoogleFonts.abel(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(
                color: AppColors.border.withAlpha(128),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                _buildTaskItem(
                  title: AppLocalizations.of(context)!.inventory,
                  subtitle: AppLocalizations.of(context)!.manage_items_data,
                  icon: Icons.inventory_2_outlined,
                  buttonText: AppLocalizations.of(context)!.add_item,
                  onButtonTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddItemScreen()),
                  ),
                  onItemTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InventoryManagementPage()),
                  ),
                ),
                const SizedBox(height: 20),
                _buildTaskItem(
                  title: AppLocalizations.of(context)!.promotions,
                  subtitle:
                      AppLocalizations.of(context)!.manage_promotions_data,
                  icon: Icons.local_offer_outlined,
                  buttonText: AppLocalizations.of(context)!.add_promo_item,
                  onButtonTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddPromoScreen()),
                  ),
                  onItemTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PromoManagementPage()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required String buttonText,
    required VoidCallback onButtonTap,
    required VoidCallback onItemTap,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.accentColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: GestureDetector(
            onTap: onItemTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.abel(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: onButtonTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoConnectionView() {
    return Center(
      // Added for completeness.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          const Text(
            'No Internet Connection',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Please check your network settings.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: AppColors.error.withAlpha(82),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.abel(
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({super.key});

  @override
  LineChartWidgetState createState() => LineChartWidgetState();
}

class LineChartWidgetState extends State<LineChartWidget> {
  List<FlSpot> salesSpots = [];
  List<String> monthLabels = [];
  double maxY = 1000; // Default max Y value

  @override
  void initState() {
    super.initState();
    fetchMonthlySalesData();
  }

  Future<void> fetchMonthlySalesData() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        QuerySnapshot<Map<String, dynamic>>? snapshot;

        try {
          snapshot = await FirebaseFirestore.instance
              .collection('sales')
              .where('farmId', isEqualTo: userId)
              .where('saleDate',
                  isGreaterThan: Timestamp.fromDate(
                      DateTime.now().subtract(const Duration(days: 180))))
              .get();
        } catch (e) {
          // Collection might not exist yet
          print('Error fetching sales data: $e');
          snapshot = null;
        }

        Map<int, double> monthlySalesMap = {};
        Set<String> uniqueMonths = {};

        if (snapshot != null && snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            DateTime saleDate = (doc['saleDate'] as Timestamp).toDate();
            int month = saleDate.month;
            double saleAmount = (doc['price'] as num).toDouble() *
                (doc['quantity'] as num).toDouble();
            monthlySalesMap[month] = (monthlySalesMap[month] ?? 0) + saleAmount;
            uniqueMonths.add(DateFormat.MMM().format(saleDate));
          }
        }

        salesSpots = List.generate(6, (index) {
          int month = DateTime.now().month - 5 + index;
          if (month <= 0) month += 12;
          return FlSpot(index.toDouble(), monthlySalesMap[month] ?? 0);
        });

        monthLabels = List.generate(6, (index) {
          DateTime date =
              DateTime.now().subtract(Duration(days: (5 - index) * 30));
          return DateFormat.MMM().format(date);
        });

        // Calculate maxY based on the highest value in the data
        maxY = salesSpots.fold<double>(
                0, (max, spot) => spot.y > max ? spot.y : max) *
            1.2;
        maxY = maxY > 0 ? maxY : 1000; // Ensure maxY is always positive

        setState(() {});
      }
    } catch (e) {
      print('Error in fetchMonthlySalesData: $e');
      // Set default values in case of error
      salesSpots = List.generate(6, (index) => FlSpot(index.toDouble(), 0));
      monthLabels = List.generate(6, (index) {
        DateTime date =
            DateTime.now().subtract(Duration(days: (5 - index) * 30));
        return DateFormat.MMM().format(date);
      });
      maxY = 1000;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: maxY / 5,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey[300],
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey[300],
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  if (value >= 0 && value < monthLabels.length) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(monthLabels[value.toInt()],
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600])),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: maxY / 5,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text('₦${value.toInt()}',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[600])),
                  );
                },
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          minX: 0,
          maxX: 5,
          minY: 0,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: salesSpots,
              isCurved: true,
              color: AppColors.accentColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: AppColors.accentColor,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.accentColor.withAlpha(52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeekLineChartWidget extends StatefulWidget {
  const WeekLineChartWidget({super.key});

  @override
  WeekLineChartWidgetState createState() => WeekLineChartWidgetState();
}

class WeekLineChartWidgetState extends State<WeekLineChartWidget> {
  List<double> weeklySales = List.filled(7, 0);
  double maxY = 1000; //Default max Y

  @override
  void initState() {
    super.initState();
    fetchWeeklySalesData();
  }

  Future<void> fetchWeeklySalesData() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        QuerySnapshot<Map<String, dynamic>>? snapshot;

        try {
          snapshot = await FirebaseFirestore.instance
              .collection('sales')
              .where('farmId', isEqualTo: userId)
              .where('saleDate',
                  isGreaterThan: Timestamp.fromDate(
                      DateTime.now().subtract(const Duration(days: 7))))
              .get();
        } catch (e) {
          // Collection might not exist yet
          print('Error fetching weekly sales data: $e');
          snapshot = null;
        }

        List<double> dailySales = List.filled(7, 0);

        if (snapshot != null && snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            DateTime saleDate = (doc['saleDate'] as Timestamp).toDate();
            int dayOfWeek = saleDate.weekday - 1; // 0 for Monday, 6 for Sunday
            double saleAmount = (doc['price'] as num).toDouble() *
                (doc['quantity'] as num).toDouble();
            dailySales[dayOfWeek] += saleAmount;
          }
        }

        // Calculate maxY
        maxY =
            dailySales.reduce((curr, next) => curr > next ? curr : next) * 1.2;
        maxY = maxY > 0 ? maxY : 1000;

        setState(() {
          weeklySales = dailySales;
        });
      }
    } catch (e) {
      print('Error in fetchWeeklySalesData: $e');
      // Set default values in case of error
      setState(() {
        weeklySales = List.filled(7, 0);
        maxY = 1000;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: maxY / 5,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey[300],
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey[300],
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  const days = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun'
                  ];
                  final index = value.toInt();
                  if (index >= 0 && index < days.length) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        days[index],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: maxY / 5,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      '₦${value.toInt()}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: maxY, // Use calculated maxY
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                weeklySales.length,
                (index) => FlSpot(index.toDouble(), weeklySales[index]),
              ),
              isCurved: true,
              color: AppColors.accentColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: AppColors.accentColor,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.accentColor.withAlpha(52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
