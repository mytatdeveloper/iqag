import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController implements GetxService {
  double _loadingIndicatorValue = 0.0;
  double get loadingIndicatorValue => _loadingIndicatorValue;

  Future<dynamic> getAssessorCredentials() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    AppConstants.assessorId = _prefs.getString("assesorID");
    AppConstants.assessorPassword = _prefs.getString("assesorPassword");
    AppConstants.assesmentId = _prefs.getString("assesmentId");
    AppConstants.assessorName = _prefs.getString("assessorName");
    AppConstants.isOnlineMode = _prefs.getBool("isOnline");
    AppConstants.companyId = _prefs.getString("companyId");
    AppConstants.instructionsList.add(_prefs.getString("instruction") ?? "");
    AppConstants.isTempOut = _prefs.getBool("tempLogout") ?? false;

    // print("Assessor Id: ${AppConstants.assessorId}");
    // print("Assessor Password: ${AppConstants.assessorPassword}");
    // print("Assesment Id: ${AppConstants.assesmentId}");
    // print("Assessor Name: ${AppConstants.assessorName}");
    // print("IsOnline: ${AppConstants.isOnlineMode}");
    // print("Company Id: ${AppConstants.companyId}");
    // print("Instruction: ${AppConstants.instructionsList.length}");

    if (AppConstants.assessorId != null) {
      update();
      if (await isContactsImported(_prefs) == true) {
        return "imported";
      }
      return "notImported";
    }
    return null;
  }

  Future<bool?> isContactsImported(SharedPreferences _prefs) async {
    return _prefs.getBool("isImportCompleted");
  }

  // Location Storing Code Starts
  Future<void> getLocation() async {
    PermissionStatus status = await Permission.location.request();

    // print(status.isGranted);
    // print(status.isLimited);
    // print(status.isProvisional);
    // print(status.isRestricted);

    try {
      if (status.isGranted || status.isLimited) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        AppConstants.locationInformation =
            _generateLocationInfo(position, placemarks);

        AppConstants.latitude = position.latitude.toString();
        AppConstants.longitude = position.longitude.toString();

        print(
            "Received Location Information Here: ${AppConstants.locationInformation}");

        update();
      } else {
        print("It is mandatory to provide the location. Please turn it on!");

        status = await Permission.location.request();
      }
    } catch (e) {
      print("Failed to get the Location! $e");
      status = await Permission.location.request();
      AppConstants.locationInformation = 'Error fetching location: $e';
    }
  }

  String _generateLocationInfo(Position position, List<Placemark>? placemarks) {
    if (placemarks == null || placemarks.isEmpty) {
      return 'Location not found';
    }

    Placemark placemark = placemarks[0];

    AppConstants.photoWatermarkText =
        "${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}";
    AppConstants.photoWatermarkText2 = "${placemark.subAdministrativeArea}";
    AppConstants.photoWatermarkText3 = getCurrentDateTime();

    return 'Address: ${placemark.subLocality}, ${placemark.locality}, \n${placemark.subAdministrativeArea}, ${placemark.postalCode}, ${placemark.country}';
  }

  String getCurrentDateTime() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd, hh:mm:ss a');
    return formatter.format(now);
  }

  setLoadingIndicatorValue(double value) {
    _loadingIndicatorValue = value;
    update();
  }
}
