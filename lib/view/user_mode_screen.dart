import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/common-components/CustomSnackbar.dart';
import 'package:mytat/common-components/CustomWarnigDialog.dart';
import 'package:mytat/services/db_helper.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:mytat/utilities/ImageUrls.dart';
import 'package:mytat/view/Authorization/login_type_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModeScreen extends StatelessWidget {
  const UserModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: EdgeInsets.all(AppConstants.paddingSmall),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppConstants.appPrimary, width: 2),
            borderRadius:
                BorderRadius.circular(AppConstants.borderRadiusSmall)),
        child: Text(
          "Version: ${AppConstants.appVersion}",
          style: AppConstants.titleBold,
        ),
      ),
      backgroundColor: AppConstants.appBackground,
      body: Column(
        children: [
          SizedBox(
            height: Get.height * 0.65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  ImageUrls.companyLogo,
                  height: AppConstants.borderRadiusCircular * 1.5,
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                CustomElevatedButton(
                    onTap: () async {
                      if (await Permission.location.isPermanentlyDenied ||
                          await Permission.location.isDenied ||
                          await Permission.location.isRestricted) {
                        Get.dialog(
                            barrierDismissible: false,
                            CustomSuccessDialog(
                                title: "Please Allow Location First!",
                                logo: CustomElevatedButton(
                                    onTap: () {
                                      Get.back();
                                      openAppSettings();
                                    },
                                    text: "Allow Location")));
                      } else {
                        var dbHelper = DatabaseHelper();
                        await dbHelper.clearDatabase();
                        SharedPreferences _prefs =
                            await SharedPreferences.getInstance();
                        _prefs.setBool("isOnline", true);
                        AppConstants.isOnlineMode = _prefs.getBool("isOnline");
                        CustomSnackBar.customSnackBar(
                            true, "Online Mode Tapped!");
                        Get.to(const LoginTypeScreen(isOnline: true));
                      }
                    },
                    text: "ONLINE MODE"),
                SizedBox(
                  height: AppConstants.paddingDefault * 2,
                ),
                CustomElevatedButton(
                    buttonColor: AppConstants.appSecondary,
                    onTap: () async {
                      if (await Permission.location.isPermanentlyDenied ||
                          await Permission.location.isDenied ||
                          await Permission.location.isRestricted) {
                        Get.dialog(
                            barrierDismissible: false,
                            CustomSuccessDialog(
                                title: "Please Allow Location First!",
                                logo: CustomElevatedButton(
                                    onTap: () {
                                      Get.back();
                                      openAppSettings();
                                    },
                                    text: "Allow Location")));
                      } else {
                        var dbHelper = DatabaseHelper();
                        await dbHelper.clearDatabase();
                        SharedPreferences _prefs =
                            await SharedPreferences.getInstance();
                        _prefs.setBool("isOnline", false);
                        AppConstants.isOnlineMode = _prefs.getBool("isOnline");
                        CustomSnackBar.customSnackBar(
                            true, "Offline Mode Tapped!");
                        Get.to(const LoginTypeScreen(isOnline: false));
                      }
                    },
                    text: "OFFLINE MODE"),
                SizedBox(
                  height: AppConstants.paddingDefault * 4,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Image.asset(
              Get.width < 420
                  ? ImageUrls.homeOnboardingMedium
                  : ImageUrls.homeOnboarding,
            ),
          ),
        ],
      ),
    );
  }
}
