import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:gona_vendor/screens/hometiles/task/add_promo.dart';
import 'package:gona_vendor/screens/hometiles/deliveredtile.dart';
import 'package:gona_vendor/screens/hometiles/task/manage_items.dart';
import 'package:gona_vendor/screens/hometiles/task/manage_promo.dart';

import 'package:gona_vendor/screens/hometiles/ordercountile.dart';
import 'package:gona_vendor/screens/hometiles/process_count_tile.dart';
import 'package:gona_vendor/screens/hometiles/welcomemsg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/helper/animation.dart';
import 'hometiles/appbaritems.dart';
import 'hometiles/task/add_item.dart';
import 'hometiles/earnings_tile.dart';
import 'hometiles/task/farmcty.dart';
import 'hometiles/task/farmname.dart';
import 'hometiles/total_salestile.dart';
import 'package:connectivity/connectivity.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isConnected = true;
  late AnimationController _leftController;
  late AnimationController _rightController;
  late AnimationController _upwardController;

  @override
  void initState() {
    super.initState();

    _leftController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _rightController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _upwardController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );

    // Start animations
    _leftController.forward();
    _rightController.forward();
    _upwardController.forward();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    String? uid = user?.uid;

    return Scaffold(
      backgroundColor: Colors.lightGreen.shade100,
      appBar: AppBar(
        backgroundColor: Colors.lightGreen.shade100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            child: Container(
              color: Colors.green.shade100,
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('farms')
                    .doc(uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.grey,
                    );
                  }
                  if (snapshot.hasError) {
                    return const Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.grey,
                    );
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.grey,
                    );
                  }
                  var farmData = snapshot.data!.data() as Map<String, dynamic>;
                  var imagePath = farmData['imagePath'] ?? '';
                  return imagePath.isNotEmpty
                      ? Image.network(
                          imagePath,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.white,
                        );
                },
              ),
            ),
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.appName,
          style: GoogleFonts.abel(
              fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black87),
        ),
        actions: const [DropdownMenuWidget()],
        centerTitle: true,
      ),
      body: _isConnected
          ? Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: ListView(
                children: [
                  // welcome msg
                  const WelcomeBackWidget(),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Orders count Tile
                        SlideTransition(
                          position:
                              CustomAnimations.slideFromLeft(_leftController),
                          child: const OrderCountTile(),
                        ),
                        const SizedBox(
                          width: 8,
                        ),

                        // Processed orders tile
                        SlideTransition(
                          position:
                              CustomAnimations.slideFromRight(_rightController),
                          child: const ProcessedTile(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  //////////// Wildfire
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Delivered items tile

                        SlideTransition(
                          position:
                              CustomAnimations.slideFromLeft(_leftController),
                          child: const DeliveredCountTile(),
                        ),
                        const SizedBox(
                          width: 8,
                        ),

                        // total sales Tile
                        SlideTransition(
                          position:
                              CustomAnimations.slideFromRight(_rightController),
                          child: const TotalSalesTile(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  FadeTransition(
                    opacity: CustomAnimations.fadeIn(_upwardController),
                    child: const TotalEarningsDisplay(),
                  ),
                  // Todays Task
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FadeTransition(
                      opacity: CustomAnimations.fadeIn(_upwardController),
                      child: SlideTransition(
                        position: CustomAnimations.slideUp(_upwardController),
                        child: Text(
                          AppLocalizations.of(context)!.todays_task,
                          style: GoogleFonts.sansita(fontSize: 20),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ),
                  // the task
                  FadeTransition(
                    opacity: CustomAnimations.fadeIn(_upwardController),
                    child: SlideTransition(
                      position: CustomAnimations.slideUp(_upwardController),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 15),
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 30,
                            height: 270,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 30),
                              child: Column(
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MaterialButton(
                                          color: Colors.green.shade100,
                                          elevation: 18,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AddItemScreen())),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .add_item,
                                              style: GoogleFonts.abel(
                                                  fontSize: 15),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        const FarmNameWidget(),
                                      ]),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const InventoryManagementPage(),
                                            )),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .inventory,
                                              style: GoogleFonts.abel(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .manage_items_data,
                                              style: GoogleFonts.abel(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 15.0,
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MaterialButton(
                                            color: Colors.green.shade100,
                                            elevation: 18,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AddPromoScreen(),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .add_promo_item,
                                                style: GoogleFonts.abel(
                                                    fontSize: 15),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          const UserCityWidget(),
                                        ]),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const PromoManagementPage()));
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .promotions,
                                                style: GoogleFonts.abel(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .manage_promotions_data,
                                                style: GoogleFonts.abel(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            )
          : ScaffoldMessenger(
              child: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error,
                        size: 50,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)!.no_internet_connection,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isConnected = true;
                          });
                        },
                        child: Text(AppLocalizations.of(context)!.retry),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
