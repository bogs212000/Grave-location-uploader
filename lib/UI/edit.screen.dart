// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grapp_mapping/UI/Loading.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../cons/const.dart';
import '../fetch/fetch.edit.dart';
import 'home.screen.dart';
import 'lock.screen.dart';
import 'map/show.location.dart';

String sortBy = "Fullname";
TextEditingController lastNameEdit = TextEditingController();
TextEditingController firstNameEdit = TextEditingController();
TextEditingController middleNameEdit = TextEditingController();
TextEditingController birthEdit = TextEditingController();
TextEditingController deathEdit = TextEditingController();
bool saveLoading = false;

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  static String id = "EditScreen";

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  void initState() {
    fetchpass(setState);
    super.initState();
  }


  Future<void> fetchpass(Function setState) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser!.email.toString())
          .get();

      pass = snapshot.data()?['password'];
      setState(() {
        pass = pass;
      });
      print(pass);
    } catch (e) {
      // Handle errors
    }
  }

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
  bool _isCircle = true;

  void _toggleShape() {
    setState(() {
      _isCircle = !_isCircle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return saveLoading
        ? Loading()
        : Scaffold(
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
            body: Container(
              height: double.infinity,
              width: double.infinity,
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
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _toggleShape,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: _isCircle ? 160 : 250,
                    width: _isCircle ? 160 : 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(_isCircle ? 100 : 140),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(_isCircle ? 100 : 140),
                      child: CachedNetworkImage(
                        imageUrl: showimage.toString(),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Center(
                          child: Shimmer.fromColors(
                            baseColor: Colors.green.shade100,
                            highlightColor: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                height: 200,
                                width: 200,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (_) => MapScreen(),
                                    //   ),
                                    // );
                                  },
                                  child: Stack(
                                    children: [
                                      GestureDetector(
                                        onTap:(){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  ChangeLocation(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 100,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 180,
                                                decoration: BoxDecoration(
                                                  color: Colors.green[900],
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 60),
                                                    'Pin on the Map'
                                                        .text
                                                        .size(15)
                                                        .color(Colors.white)
                                                        .make(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                    border: Border.all(
                                                      color: Colors.green[900]!,
                                                      // Change this to your desired border color
                                                      width:
                                                          3.0, // Change this to adjust the border width
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.pin_drop,
                                                      color: Colors.green[900],
                                                      size: 35,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            //Last name
                            Row(
                              children: [
                                '  Last Name'
                                    .text
                                    .color(Colors.green[900])
                                    .semiBold
                                    .make()
                              ],
                            ),
                            Container(
                              height: 45,
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0),
                                border: Border.all(
                                  color: Colors.green[900]!,
                                  width: 1.5,
                                ),
                              ),
                              child: TextField(
                                controller: lastNameEdit,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            //First name
                            SizedBox(height: 5),
                            Row(
                              children: [
                                '  First Name'
                                    .text
                                    .color(Colors.green[900])
                                    .semiBold
                                    .make()
                              ],
                            ),
                            Container(
                              height: 45,
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0),
                                border: Border.all(
                                  color: Colors.green[900]!,
                                  width: 1.5,
                                ),
                              ),
                              child: TextField(
                                controller: firstNameEdit,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            //Middle name
                            SizedBox(height: 5),
                            Row(
                              children: [
                                '  Middle Name'
                                    .text
                                    .color(Colors.green[900])
                                    .semiBold
                                    .make()
                              ],
                            ),
                            Container(
                              height: 45,
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0),
                                border: Border.all(
                                  color: Colors.green[900]!,
                                  width: 1.5,
                                ),
                              ),
                              child: TextField(
                                controller: middleNameEdit,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            //Name extension
                            SizedBox(height: 5),
                            Row(
                              children: [
                                '  Name Extension'
                                    .text
                                    .color(Colors.green[900])
                                    .semiBold
                                    .make()
                              ],
                            ),
                            Container(
                              height: 45,
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0),
                                border: Border.all(
                                  color: Colors.green[900]!,
                                  width: 1.5,
                                ),
                              ),
                              child: TextField(
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            //Date of Birth
                            SizedBox(height: 5),
                            Row(
                              children: [
                                '  Date of Birth'
                                    .text
                                    .color(Colors.green[900])
                                    .semiBold
                                    .make()
                              ],
                            ),
                            Container(
                              height: 45,
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0),
                                border: Border.all(
                                  color: Colors.green[900]!,
                                  width: 1.5,
                                ),
                              ),
                              child: TextField(
                                controller: birthEdit,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            //Date of Death
                            SizedBox(height: 5),
                            Row(
                              children: [
                                '  Date of Death'
                                    .text
                                    .color(Colors.green[900])
                                    .semiBold
                                    .make()
                              ],
                            ),
                            Container(
                              height: 45,
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0),
                                border: Border.all(
                                  color: Colors.green[900]!,
                                  width: 1.5,
                                ),
                              ),
                              child: TextField(
                                controller: deathEdit,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: 200,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ConfirmPasswordDialog();
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF265630),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                child: "Save"
                                    .text
                                    .size(20)
                                    .light
                                    .color(Colors.white)
                                    .make(),
                              ),
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    super.dispose();
  }
}

class ConfirmPasswordDialog extends StatefulWidget {
  @override
  State<ConfirmPasswordDialog> createState() => _ConfirmPasswordDialogState();
}

class _ConfirmPasswordDialogState extends State<ConfirmPasswordDialog> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Confirm Password',
                    style: TextStyle(
                      color: Colors.green[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.cancel_outlined,
                      color: Colors.green[900],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: 'For your security, please type your password to save.'
                  .text
                  .color(Colors.green[900])
                  .make(),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  // First Container with a TextField
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 240,
                              height: 40,
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0),
                                border: Border.all(
                                  color: Colors.green[400]!,
                                  width: 2.0,
                                ),
                              ),
                              child: TextField(
                                controller: _passwordController,
                                textCapitalization: TextCapitalization.words,
                                onChanged: (value) {},
                                decoration: InputDecoration(
                                  hintText: 'Password',
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
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.green[300],
                                  borderRadius: BorderRadius.circular(60),
                                  border: Border.all(
                                    color: Colors.green[300]!,
                                    width: 3.0,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.lock,
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
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  if (_passwordController.text == pass) {
                    setState(() {
                      saveLoading = true;
                    });
                    try {
                      FirebaseFirestore.instance
                          .collection('Records')
                          .doc('$docToBeEdit')
                          .update({
                        'Fname': firstNameEdit.text,
                        'Initial': middleNameEdit.text,
                        'Lname': lastNameEdit.text,
                        'Date of Birth': birthEdit.text,
                        'Date of Death': deathEdit.text,
                      });
                      setState(() {
                        saveLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            backgroundColor: Colors.green[900],
                            content: 'Update Successfully!'
                                .text
                                .color(Colors.white)
                                .make()),
                      );
                    } catch (e) {
                      setState(() {
                        saveLoading = false;
                      });
                      print(e);
                    }
                  } else {
                    setState(() {
                      saveLoading = false;
                    });
                    // Handle incorrect password case
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Incorrect password!')),
                    );
                  }
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  backgroundColor: Colors.green[900],
                ),
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
