import 'package:flutter/material.dart';
import 'package:gona_vendor/screens/hometiles/deliveredtile.dart';

import 'package:gona_vendor/screens/hometiles/ordercountile.dart';
import 'package:gona_vendor/screens/hometiles/process_count_tile.dart';
import 'package:gona_vendor/screens/welcomemsg.dart';

import 'package:google_fonts/google_fonts.dart';

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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Drawer;
                },
                child: const Icon(
                  Icons.menu,
                  size: 40,
                ),
              ),
            )
          ],
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
                        OrderCountTile(),
                        SizedBox(
                          width: 8,
                        ),
                        ProcessedTile()
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),
                  ////////////
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const DeliveredCountTile(),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 137, 247, 143),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                      child: Text(
                                        '1638',
                                        style: TextStyle(fontSize: 45),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Text(
                                      "Total sales",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ]),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 30,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 137, 247, 143),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text(
                                  '₦15690777',
                                  style: TextStyle(fontSize: 45),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 25.0),
                                child: Text(
                                  'Total Earnings',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )
                            ]),
                      ),
                    ),
                  ),
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
                                  Padding(
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
                                  const Spacer(),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 10.0, top: 15),
                                    child: Text(
                                      'Farm Name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  ),
                                ]),
                            const Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Inventory',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Text(
                                      'Manage sales data',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
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
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.limeAccent),
                                        child: const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text(
                                            'Manage Order',
                                            style: TextStyle(fontSize: 15),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 10.0, top: 15),
                                      child: Text(
                                        'Farm City',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                    ),
                                  ]),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 15.0),
                              child: Row(
                                children: [
                                  Column(
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
                                        'Manage sales data',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
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
