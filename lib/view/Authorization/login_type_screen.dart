import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:mytat/utilities/ImageUrls.dart';
import 'package:mytat/view/Authorization/login_screen.dart';

class LoginTypeScreen extends StatelessWidget {
  final bool isOnline;
  final bool isFromStudentLogout;

  const LoginTypeScreen(
      {super.key, required this.isOnline, this.isFromStudentLogout = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppConstants.appBackground,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
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
                Visibility(
                  visible: !isOnline,
                  child: SizedBox(
                    height: AppConstants.paddingDefault * 2,
                  ),
                ),
                CustomElevatedButton(
                    buttonColor: AppConstants.appGreen,
                    onTap: () {
                      // CustomSnackBar.customSnackBar(
                      //     true, "Assessor Login Tapped!");
                      Get.to(LoginScreen(
                          userType: "assessor",
                          isOnline: isOnline,
                          isFromStudentLogout: isFromStudentLogout));
                    },
                    text: "ASSESSOR LOGIN"),
                SizedBox(
                  height: AppConstants.paddingDefault * 2,
                ),
                CustomElevatedButton(
                    buttonColor: AppConstants.appPrimary,
                    onTap: () {
                      // CustomSnackBar.customSnackBar(
                      //     false, "Candidate Login Tapped!");
                      Get.to(LoginScreen(
                        userType: "candidate",
                        isOnline: isOnline,
                      ));
                    },
                    text: "CANDIDATE LOGIN"),
                SizedBox(
                  height: AppConstants.paddingDefault * 4,
                ),
              ],
            ),
          ),
          Expanded(
            child: isOnline
                ? Image.asset(
                    Get.width < 400
                        ? ImageUrls.loginTypeMedium
                        : ImageUrls.loginType,
                  )
                : Image.asset(
                    Get.width < 400
                        ? ImageUrls.loginTypeOffline
                        : ImageUrls.loginTypeOfflineMedium,
                  ),
          ),
        ],
      ),
    );
  }
}
