import 'package:flutter/material.dart';

import 'package:gona_vendor/screens/hometiles/task/add_promo.dart';
import 'package:gona_vendor/screens/hometiles/deliveredtile.dart';
import 'package:gona_vendor/screens/hometiles/task/manage_items.dart';
import 'package:gona_vendor/screens/hometiles/task/manage_promo.dart';

import 'package:gona_vendor/screens/hometiles/ordercountile.dart';
import 'package:gona_vendor/screens/hometiles/process_count_tile.dart';
import 'package:gona_vendor/screens/welcomemsg.dart';

import 'package:google_fonts/google_fonts.dart';

import 'hometiles/appbaritems.dart';
import 'hometiles/task/add_item.dart';
import 'hometiles/earnings_tile.dart';
import 'hometiles/task/farmcty.dart';
import 'hometiles/task/farmname.dart';
import 'hometiles/total_salestile.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: Container(
                color: Colors.blueAccent,
              ),
            ),
          ),
          title: Text(
            'Gona Farmers',
            style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          actions: const [DropdownMenuWidget()],
          centerTitle: true,
        ),
        body: Container(
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
                      "Today's Task",
                      style: GoogleFonts.sansita(fontSize: 20),
                      textAlign: TextAlign.start,
                    ),
                  ),
// the task
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 30,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 137, 247, 143),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 10),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AddItemScreen())),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.limeAccent),
                                        child: const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text(
                                            'Add Item',
                                            style: TextStyle(fontSize: 15),
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
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Inventory',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        "Manage items' data",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 15.0,
                              ),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          child: const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(
                                              'Add Promo Item',
                                              style: TextStyle(fontSize: 15),
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
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Promotions',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          'Manage promotions item data',
                                          style: TextStyle(
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
        ));
  }
}
