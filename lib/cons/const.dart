import 'package:geolocator/geolocator.dart';

bool? maintenance;
String? termsAndConditions;
String? feedback;
bool servicestatus = false;
bool haspermission = false;
late LocationPermission permission;
Position? _currentPosition;
double? showlat;
double? showlong;
String? showfullname;
String? showimage;
double? userLat = 9.2458347;
double? userLong = 118.401804;
String? ddeath;
String? dbirth;
String? pin;

//edit data
String? docToBeEdit;