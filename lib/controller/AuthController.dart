import 'package:get/get.dart';
import 'package:mytat/model/AssessorLoginModel.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/ServerInformationModel.dart';
import '../utilities/ApiClient.dart';
import '../utilities/ApiEndpoints.dart';

class AuthController extends GetxController {
  bool _showPassword = true;
  bool get showPassword => _showPassword;

  ServerInformation serverInfo = ServerInformation();

  Servers? _currentServer;
  Servers? get currentServer => _currentServer;

  Assessor _currentAssessor = Assessor();
  Assessor get currentAssessor => _currentAssessor;

  bool _isLoadingResponse = false;
  bool get isLodaingResponse => _isLoadingResponse;

  changeIsLoadingResponse() {
    _isLoadingResponse = !_isLoadingResponse;
    update();
  }

  changePasswordVisibility() {
    _showPassword = !showPassword;
    update();
  }

  Future<bool> getServerBaseformation(String id, String password) async {
    _isLoadingResponse = true;

    update();
    Map<String, dynamic> response = await ApiClient().get(
        "${ApiEndpoints.serverinformation}?userName=$id&uPassword=$password");

    if (response['servers'][0]['result'] != "0") {
      serverInfo = ServerInformation.fromJson(response);
      _isLoadingResponse = false;
      update();
      return true;
    } else {
      _isLoadingResponse = false;
      update();
      return false;
    }
  }

  Future<bool?> loginAssessor(
      String id, String password, bool isSettingPrefsNeeded) async {
    _isLoadingResponse = true;
    update();
    try {
      Map<String, dynamic> response = await ApiClient().get(
          "${ApiEndpoints.assessorLoginUrl}company_email=$id&password=$password");

      if (response['Assessor'][0]['result'] != "0") {
        _currentAssessor = Assessor.fromJson(response['Assessor'][0]);
        _isLoadingResponse = false;
        update();
        if (isSettingPrefsNeeded) {
          setAssessorLoginFlow(
              _currentAssessor.assessorId ?? "",
              password,
              _currentAssessor.compId ?? "",
              _currentAssessor.name ?? "",
              _currentAssessor.userEmail ?? "");
        }

        return true;
      } else {
        _isLoadingResponse = false;
        update();
        return false;
      }
    } catch (e) {
      print("Exception Logging in: $e");
      _isLoadingResponse = false;
      update();
      return null;
    }
  }

  setAssessorLoginFlow(String assesorId, String assessorPassword,
      String companyId, String assessorName, String assessorEmail) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString("assesorID", assesorId);
    _prefs.setString("assesorPassword", assessorPassword);
    _prefs.setString("companyId", companyId);
    _prefs.setString("assessorName", assessorName);
    _prefs.setString("assessorEmail", assessorEmail);

    AppConstants.assessorId = _prefs.getString("assesorID");
    AppConstants.assesmentId = _prefs.getString("assesmentId");
    AppConstants.companyId = _prefs.getString("companyId");
    AppConstants.assessorName = _prefs.getString("assessorName");
    AppConstants.assessorEmail = _prefs.getString("assessorEmail");

    print("If Logged in Assessor Id ==> ${AppConstants.assessorId}");
    print("If Logged in Assessment Id ==> ${AppConstants.assesmentId}");
    print("If Logged in Company Id ==> ${AppConstants.companyId}");
    print("If Logged in Assessor Name ==> ${AppConstants.assessorName}");

    update();
  }

  logOutUser() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.clear();
    // added line of code for deleting the Cache And App Directory
    // await deleteCacheDir();
    // await deleteAppDir();
    // added line of code for deleting the Cache And App Directory

    update();
  }

  Future<void> deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }
}
