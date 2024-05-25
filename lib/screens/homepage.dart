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

class _HomepageState extends State<Homepage> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();

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
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            child: Container(
              color: Colors.green,
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('farms')
                    .doc(uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
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
                          width: 60, // Adjust the width as needed
                          height: 60, // Adjust the height as needed
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
          style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        actions: const [DropdownMenuWidget()],
        centerTitle: true,
      ),
      body: _isConnected
          ? Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // welcome msg
                      const WelcomeBackWidget(),
                      const Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Orders count Tile
                            OrderCountTile(),
                            SizedBox(
                              width: 8,
                            ),

                            // Processed orders tile
                            ProcessedTile()
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      //////////// Wildfire
                      const Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Delivered items tile
                            DeliveredCountTile(),
                            SizedBox(
                              width: 8,
                            ),

                            // total sales Tile
                            TotalSalesTile(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),

                      const TotalEarningsDisplay(),
// Todays Task
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          AppLocalizations.of(context)!.todays_task,
                          style: GoogleFonts.sansita(fontSize: 20),
                          textAlign: TextAlign.start,
                        ),
                      ),
// the task
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 15),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 30,
                          height: 270,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 137, 247, 143),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 30),
                            child: Column(
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const AddItemScreen())),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.limeAccent),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              //Add Item
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .add_item,
                                                style: const TextStyle(
                                                    fontSize: 15),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
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
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .manage_items_data,
                                            style: const TextStyle(
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
                                        GestureDetector(
                                          onTap: () {
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
                                                const EdgeInsets.only(top: 5.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.limeAccent),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .add_promo_item,
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        const UserCityWidget(),
                                      ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
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
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .manage_promotions_data,
                                              style: const TextStyle(
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

                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
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
