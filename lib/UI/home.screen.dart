// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../cons/const.dart';
import 'add.screen.dart';
import 'edit.screen.dart';

String sortBy = "Fullname";

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static String id = "SearchScreen";

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController search2Controller = TextEditingController();
  String? _selectedValue;
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  late double long, lat;
  List<Marker> _marker = <Marker>[];
  String dropdownValue1 = "First Name";
  String? dropdownValue;
  List<String> list = ["Name", "Date of Birth", "Date of Death"];
  String search = "";
  String filterSearch = "Fullname";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   backgroundColor: Color(0xFF265630),
        //   foregroundColor: Colors.white,
        //   title: Row(
        //     children: [
        //       // const Text(
        //       //   "Sort by: ",
        //       //   style: TextStyle(fontSize: 12),
        //       // ),
        //       // DropdownButton<String>(
        //       //   dropdownColor: Colors.blue[100],
        //       //   value: dropdownValue,
        //       //   icon: const Icon(Icons.sort, size: 15),
        //       //   elevation: 12,
        //       //   underline: Container(
        //       //     height: 1,
        //       //     color: Colors.white,
        //       //   ),
        //       //   onChanged: (String? value) {
        //       //     // This is called when the user selects an item.
        //       //     setState(() {
        //       //       dropdownValue = value!;
        //       //     });
        //       //     if (value == "Birth") {
        //       //       setState(() {
        //       //         sortBy = "Date of Birth";
        //       //       });
        //       //     } else if (value == "Name") {
        //       //       setState(() {
        //       //         sortBy = "Fullname";
        //       //       });
        //       //     } else {
        //       //       setState(() {
        //       //         sortBy = "Date of Death";
        //       //       });
        //       //     }
        //       //   },
        //       //   items: list.map<DropdownMenuItem<String>>((String value) {
        //       //     return DropdownMenuItem<String>(
        //       //       value: value,
        //       //       child: Text(value, style: TextStyle(fontSize: 12),),
        //       //     );
        //       //   }).toList(),
        //       // ),
        //       const SizedBox(width: 5),
        //       Spacer(),
        //       AnimatedContainer(
        //         duration: Duration(milliseconds: 300),
        //         height: 40,
        //         width: search == "" ? 100 : 120,
        //         child: TextFormField(
        //           controller: search2Controller,
        //           textCapitalization: TextCapitalization.words,
        //           onChanged: (value) {
        //             setState(() {
        //               search = value;
        //             });
        //           },
        //           style: const TextStyle(fontSize: 15),
        //           decoration: InputDecoration(
        //             contentPadding: const EdgeInsets.all(10),
        //             focusColor: Colors.blue.shade50,
        //             hintText: "Search...",
        //             suffixIcon: search == ""
        //                 ? Icon(Icons.search)
        //                 : GestureDetector(
        //                     onTap: () {
        //                       search2Controller.clear();
        //                       setState(() {
        //                         search = "";
        //                       });
        //                     },
        //                     child: Icon(
        //                       Icons.cancel_outlined,
        //                       color: Colors.grey,
        //                     ),
        //                   ),
        //             filled: true,
        //             fillColor: Colors.blue.shade50,
        //             focusedBorder: OutlineInputBorder(
        //                 borderRadius: BorderRadius.circular(40),
        //                 borderSide: const BorderSide(color: Colors.white)),
        //             labelStyle: const TextStyle(color: Colors.white),
        //             enabledBorder: OutlineInputBorder(
        //                 borderSide: const BorderSide(color: Colors.white),
        //                 borderRadius: BorderRadius.circular(40.0)),
        //           ),
        //         ),
        //       ),
        //       Column(
        //         children: [
        //           GestureDetector(
        //               onTap: () {
        //                 if (filterSearch == "Fullname") {
        //                   setState(() {
        //                     filterSearch = "Lname";
        //                   });
        //                 } else {
        //                   setState(() {
        //                     filterSearch = "Fullname";
        //                   });
        //                 }
        //               },
        //               child: Icon(Icons.change_circle)),
        //           filterSearch == "Lname"
        //               ? Text("Last name", style: TextStyle(fontSize: 7))
        //               : Text("First name", style: TextStyle(fontSize: 7))
        //         ],
        //       )
        //     ],
        //   ),
        //   elevation: 0,
        // ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  Container(
                      height: 110,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/new/USER_SB4Header.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        children: [
                        ],
                      ),),
                  Container(
                    width: double.infinity,
                    height: 85,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            // First Container with a TextField
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: 150,
                                        height: 40,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          border: Border.all(
                                            color: Colors.green[400]!,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: TextField(
                                          textCapitalization:
                                              TextCapitalization.words,
                                          onChanged: (value) {
                                            setState(() {
                                              search = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Search...',
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Second Container with a circular icon
                            Positioned(
                              top: 0,
                              // Adjust this value to position it as desired
                              right: 0,
                              // Adjust this value to position it as desired
                              child: Container(
                                height: 40,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.green[300],
                                            borderRadius:
                                                BorderRadius.circular(60),
                                            border: Border.all(
                                              color: Colors.green[300]!,
                                              width: 3.0,
                                            ),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.search,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                            .animate()
                            .fadeIn() // uses `Animate.defaultDuration`
                            .scale() // inherits duration from fadeIn
                            .move(delay: 300.ms, duration: 600.ms),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 1),
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.green[900],
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.filter_list,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  SizedBox(width: 5),
                                  SizedBox(
                                    width: dropdownValue == null ? 100 : 100,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        hint: 'Filter'
                                            .text
                                            .color(Colors.white)
                                            .size(12)
                                            .make(),
                                        dropdownColor: Colors.green[300],
                                        value: dropdownValue,
                                        icon: Icon(Icons.arrow_drop_down,
                                            color: Colors.white),
                                        iconSize: 20,
                                        style: TextStyle(
                                            color: Colors.green[900],
                                            fontSize: 12),
                                        onChanged: (String? value) {
                                          // This is called when the user selects an item.
                                          setState(() {
                                            dropdownValue = value!;
                                          });
                                          if (value == "Date of Birth") {
                                            setState(() {
                                              sortBy = "Date of Birth";
                                            });
                                          } else if (value == "Name") {
                                            setState(() {
                                              sortBy = "Fullname";
                                            });
                                          } else {
                                            setState(() {
                                              sortBy = "Date of Death";
                                            });
                                          }
                                        },
                                        items: list
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                            .animate()
                            .fadeIn() // uses `Animate.defaultDuration`
                            .scale() // inherits duration from fadeIn
                            .move(delay: 100.ms, duration: 600.ms),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: StreamBuilder(
                        stream: (search != "")
                            ? FirebaseFirestore.instance
                                .collection("Records")
                                .where(filterSearch,
                                    isGreaterThanOrEqualTo: search)
                                .where(filterSearch, isLessThan: search + 'z')
                                .snapshots()
                            : FirebaseFirestore.instance
                                .collection('Records')
                                .orderBy('$sortBy')
                                .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Somthing went wrong!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 231, 25, 25),
                                  ),
                                )
                              ],
                            );
                          } else if (snapshot.data?.size == 0) {
                            return Center(
                                child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                  "We couldn't find any records matching your search."),
                            ));
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ListView.builder(
                              itemCount: 3,
                              itemBuilder: (context, index) =>
                                  Shimmer.fromColors(
                                      baseColor: Colors.green.shade100,
                                      highlightColor: Colors.white,
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          height: 130,
                                          width: double.infinity,
                                        ),
                                      )),
                            );
                          }
                          Row(children: const [
                            TextField(
                              decoration: InputDecoration(),
                            )
                          ]);
                          return ListView(
                            physics: const BouncingScrollPhysics(),
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              String? image = data["image"];
                              String? fullname = data["Fullname"];
                              String? firstname = data["Fname"];
                              String? middlename = data["Initial"];
                              String? lastname = data["Lname"];
                              String? birth = data["Date of Birth"];
                              String? death = data["Date of Death"];
                              double? lat = data["lat"];
                              double? long = data["long"];
                              _marker.add(Marker(
                                  markerId: const MarkerId(""),
                                  position: LatLng(lat!, long!),
                                  infoWindow: InfoWindow(title: "$fullname")));

                              return Padding(
                                padding: EdgeInsets.only(right: 10, left: 10),
                                child: Card(
                                    shadowColor:
                                        const Color.fromARGB(255, 34, 34, 34),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: Colors.green, // Border color
                                        width: 2.0, // Border width
                                      ),
                                    ),
                                    color: Colors.white,
                                    child: Container(
                                      height: 160,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 30,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.green[900],
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15),
                                                  child: GestureDetector(
                                                    onTap: () {

                                                      setState(() {
                                                       docToBeEdit = fullname;
                                                       showimage =image;
                                                       lastNameEdit.text = lastname!;
                                                       middleNameEdit.text = middlename!;
                                                       firstNameEdit.text = firstname!;
                                                       birthEdit.text = birth!;
                                                       deathEdit.text = death!;
                                                      });
                                                      print(
                                                          "$showlat, $showlong");
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              EditScreen(),
                                                        ),
                                                      );
                                                      // Navigator.push(
                                                      //   context,
                                                      //   // MaterialPageRoute(
                                                      //   //   builder: (_) =>
                                                      //   //       DetailsScreen(),
                                                      //   // ),
                                                      // );
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.edit,
                                                          color: Colors.white,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const SizedBox(width: 5),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 50,
                                                      vertical: 10),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          'Last Name:       '
                                                              .text
                                                              .make(),
                                                          Flexible(
                                                            child: Text(
                                                              '$lastname',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          'First Name:       '
                                                              .text
                                                              .make(),
                                                          Flexible(
                                                            child: Text(
                                                              '$firstname',
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          'Middle Name:   '
                                                              .text
                                                              .make(),
                                                          Flexible(
                                                            child: Text(
                                                              '$middlename',
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          'Date of Birth:   '
                                                              .text
                                                              .make(),
                                                          Flexible(
                                                            child: Text(
                                                              '$birth',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                      fontSize:
                                                                          14),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          'Date of Death:   '
                                                              .text
                                                              .make(),
                                                          Flexible(
                                                            child: Text(
                                                              '$death',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                      fontSize:
                                                                          14),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.end,
                                          //   children: [
                                          //     GestureDetector(
                                          //       child: Image.asset(
                                          //         "assets/imageIcon.png",
                                          //         scale: 2.4,
                                          //         color: Colors.blue.shade900,
                                          //       ),
                                          //       onTap: () {
                                          //         setState(() {
                                          //           showimage = image;
                                          //           showfullname = fullname;
                                          //           showlat = lat;
                                          //           showlong = long;
                                          //           ddeath = death;
                                          //           dbirth = birth;
                                          //         });
                                          //         Navigator.push(
                                          //           context,
                                          //           MaterialPageRoute(
                                          //             builder: (context) => ShowImage(),
                                          //           ),
                                          //         );
                                          //       },
                                          //     ),
                                          //     const SizedBox(width: 10),
                                          //     GestureDetector(
                                          //       child: Image.asset(
                                          //         "assets/locationIcon.png",
                                          //         scale: 2.4,
                                          //         color: Colors.blue.shade900,
                                          //       ),
                                          //       onTap: () {
                                          //         setState(() {
                                          //           showlat = lat;
                                          //           showlong = long;
                                          //           showfullname = fullname;
                                          //         });
                                          //         Navigator.push(
                                          //           context,
                                          //           MaterialPageRoute(
                                          //             builder: (context) => Show(),
                                          //           ),
                                          //         );
                                          //       },
                                          //     ),
                                          //   ],
                                          // )
                                        ],
                                      ),
                                    )),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap:(){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    AddScreen(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            child: Icon(Icons.add),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
