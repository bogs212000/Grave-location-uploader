import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'Loading.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

TextEditingController fullname = new TextEditingController();
TextEditingController fname = new TextEditingController();
TextEditingController mname = new TextEditingController();
TextEditingController lname = new TextEditingController();
TextEditingController birth = new TextEditingController();
TextEditingController death = new TextEditingController();
TextEditingController location = new TextEditingController();

bool loading = false;

class MyHomepage extends StatefulWidget {
  static String id = "MyHomePage";
  Completer<GoogleMapController> _controller = Completer();

  MyHomepage({super.key});

  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  late BannerAd _bannedAd;
  bool _isAdLoaded = false;
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  late double long;
  late double lat;
  String address = "";
  File? _image;
  late String imgUrl;
  final _picker = ImagePicker();
  final Completer<GoogleMapController> _controller = Completer();
  String date = "";
  DateTime selectedDate = DateTime.now();
  Set<Marker> _marker = {};

  @override
  void initState() {
    super.initState();
    _bannedAd = BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-9178239124625802/8242619776',
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          setState(() {
            _isAdLoaded = false;
          });
          ad.dispose();
        }),
        request: const AdRequest());
    _bannedAd.load();
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1940),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        birth.text =
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
      });
    }
  }

  _selectDate1(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1940),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        death.text =
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
      });
    }
  }

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
      setState(() {
        loading = false;
      });
    }
  }

  checkGps() async {
    showAlertDialog2(context);
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      print(position.longitude);
      print(position.latitude);

      long = position.longitude;
      lat = position.latitude;

      setState(() {
        location.text = "$lat, $long";
        address = "$lat, $long";

        // Clear existing markers and add a new one
        _marker = {
          Marker(
            markerId: MarkerId("myMarkerId"), // Use a specific marker ID
            position: LatLng(lat, long),
            infoWindow: InfoWindow(title: "$address"),
          ),
        };
        loading = false;
      });

      Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        loading = false;
      });
    } catch (e) {
      print("Error getting location: $e");
      // Handle errors if any
    }
  }

  showAlertDialog1(BuildContext context) {
    // set up the buttons

    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = const AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 50,
            color: Colors.green,
          ),
          Text(
            "Uploaded successfully!",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          )
        ],
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog2(BuildContext context) {
    // set up the buttons

    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = const AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.location_on,
            color: Colors.red,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Locating...",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );

    // show the dialog
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            body: Container(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 5, 44, 77)),
              padding: const EdgeInsets.only(
                  left: 20, top: 20, right: 20, bottom: 0),
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Image.asset('assets/cemetery.png',
                            scale: 5, color: Colors.white),
                        const Text('  Grave Mapping Uploader',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white))
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.all(20),
                      width: double.infinity,
                      child: Column(
                        children: [
                          TextField(
                            controller: fname,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                letterSpacing: .5,
                                fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 219, 219, 219))),
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: const TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black,
                                  letterSpacing: .5,
                                  fontWeight: FontWeight.w400),
                              labelText: "First name",
                              prefixIcon: const Icon(Icons.person_2_outlined,
                                  color: Colors.black),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 219, 219, 219)),
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: mname,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                letterSpacing: .5,
                                fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 219, 219, 219))),
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: const TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black,
                                  letterSpacing: .5,
                                  fontWeight: FontWeight.w400),
                              labelText: "Middle name(optional)",
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 219, 219, 219)),
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: lname,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                letterSpacing: .5,
                                fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 219, 219, 219))),
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: const TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black,
                                  letterSpacing: .5,
                                  fontWeight: FontWeight.w400),
                              labelText: "Last name",
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 219, 219, 219)),
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        width: 120,
                                        child: TextField(
                                          controller: birth,
                                          keyboardType: TextInputType.name,
                                          style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                              letterSpacing: .5,
                                              fontWeight: FontWeight.w400),
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 219, 219, 219))),
                                            filled: true,
                                            fillColor: Colors.white,
                                            labelStyle: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black,
                                                letterSpacing: .5,
                                                fontWeight: FontWeight.w400),
                                            labelText: "Date of Birth",
                                            hintText: "DD/MM/YYYY",
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 219, 219, 219)),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        child: Icon(Icons.calendar_month),
                                        onTap: () {
                                          _selectDate(context);
                                        },
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(children: [
                                    SizedBox(
                                      height: 50,
                                      width: 120,
                                      child: TextField(
                                        controller: death,
                                        keyboardType: TextInputType.name,
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black,
                                            letterSpacing: .5,
                                            fontWeight: FontWeight.w400),
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: const BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 219, 219, 219))),
                                          filled: true,
                                          fillColor: Colors.white,
                                          labelStyle: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                              letterSpacing: .5,
                                              fontWeight: FontWeight.w400),
                                          labelText: "Date of Death",
                                          hintText: "DD/MM/YYYY",
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 219, 219, 219)),
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      child: Icon(Icons.calendar_month),
                                      onTap: () {
                                        _selectDate1(context);
                                      },
                                    )
                                  ]),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            child: Container(
                                alignment: Alignment.center,
                                child: _image != null
                                    ? Image.file(_image!, fit: BoxFit.cover)
                                    : Column(
                                        children: const [
                                          Text('Tap here to take a photo'),
                                        ],
                                      )),
                            onTap: () {
                              _openImagePicker();
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              SizedBox(
                                height: 50,
                                width: 190,
                                child: TextField(
                                  controller: location,
                                  enabled: false,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                      letterSpacing: .5,
                                      fontWeight: FontWeight.w400),
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 219, 219, 219))),
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelStyle: const TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.black,
                                        letterSpacing: .5,
                                        fontWeight: FontWeight.w400),
                                    labelText: "Location",
                                    hintText: " ",
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 219, 219, 219)),
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                  ),
                                ),
                              ),
                              Spacer(),
                              SizedBox(
                                height: 40,
                                width: 60,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    await showAlertDialog2(context);
                                    await checkGps();
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  child: const Text("Get"),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            child: address != ""
                                ? SizedBox(
                                    width: double.infinity,
                                    height: 160,
                                    child: GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                          target: LatLng(lat, long), zoom: 19),
                                      markers: Set<Marker>.of(_marker),
                                      zoomControlsEnabled: true,
                                      zoomGesturesEnabled: true,
                                      tiltGesturesEnabled: true,
                                      scrollGesturesEnabled: true,
                                      rotateGesturesEnabled: true,
                                      mapType: MapType.satellite,
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        _controller.complete(controller);
                                      },
                                    ))
                                : Container(),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (lname.text == "" ||
                              fname.text == "" ||
                              birth.text == "" ||
                              death.text == "" ||
                              location.text == "" ||
                              _image == null ||
                              lat == 0.0 ||
                              long == 0.0) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              backgroundColor: Colors.red,
                              content: Row(
                                children: [
                                  Icon(
                                    Icons.warning,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5),
                                  Text("Fill-up all the text-field",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              duration: Duration(seconds: 2),
                            ));
                          } else {
                            setState(() {
                              loading = true;
                            });
                            try {
                              String url;
                              String fn = fname.text;
                              String mn = mname.text;
                              String ln = lname.text;
                              String name = '$fn $mn $ln';
                              final ref = FirebaseStorage.instance
                                  .ref()
                                  .child('UsersId/$name');
                              await ref.putFile(File(_image!.path));
                              url = await ref.getDownloadURL();
                              await FirebaseFirestore.instance
                                  .collection("Records")
                                  .doc(name)
                                  .set({
                                'Fullname': name,
                                'Fname': fname.text,
                                'Initial': mname.text,
                                'Lname': lname.text,
                                'Date of Birth': birth.text,
                                'Date of Death': death.text,
                                'lat': lat,
                                'long': long,
                                'Location': address,
                                'image': url,
                              });
                              fullname.clear();
                              fname.clear();
                              mname.clear();
                              lname.clear();
                              birth.clear();
                              death.clear();
                              address = "";
                              lat = 0.0;
                              long = 0.0;
                              location.clear();
                              name = '';
                              _image = null;
                              setState(() {
                                loading = false;
                              });
                              showAlertDialog1(context);
                            } catch (e) {
                              print(e);
                              setState(() {
                                loading = false;
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: const Text("Upload"),
                      ),
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
              ),
            ),
            bottomNavigationBar: _isAdLoaded
                ? SizedBox(
                    height: _bannedAd.size.height.toDouble(),
                    width: _bannedAd.size.width.toDouble(),
                    child: AdWidget(ad: _bannedAd),
                  )
                : SizedBox());
  }
}
