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
double? userLat;
double? userlong;
String? ddeath;
String? dbirth;

//edit data
String? docToBeEdit;