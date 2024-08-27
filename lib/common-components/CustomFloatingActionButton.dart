import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomWarnigDialog.dart';
import 'package:mytat/controller/AuthController.dart';
import 'package:mytat/services/db_helper.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:mytat/view/user_mode_screen.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.dialog(
            barrierDismissible: false,
            CustomWarningDialog(
                bottomSpacing: AppConstants.paddingDefault,
                onPress: () async {
                  // Clear the database entries
                  AppConstants.isTempOut = false;
                  var dbHelper = DatabaseHelper();
                  await dbHelper.clearDatabase();

                  // logout the user
                  await Get.find<AuthController>().logOutUser();
                  Get.offAll(const UserModeScreen());
                },
                title: AppConstants.isOnlineMode == true
                    ? "Do you want to Logout?"
                    : "Are you sure that you want to clear the database? If you press Ok the Assessor and student data will get cleared from your local database"));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: AppConstants.paddingSmall,
            horizontal: AppConstants.paddingSmall),
        margin: EdgeInsets.only(bottom: AppConstants.paddingLarge),
        decoration: BoxDecoration(
            boxShadow: [AppConstants.appShadow],
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.red,
                Colors.amber,
              ],
            ),
            // color: AppConstants.appSecondary,
            borderRadius:
                BorderRadius.circular(AppConstants.borderRadiusLarge)),
        width: Get.width * 0.5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppConstants.isOnlineMode == true ? Icons.logout : Icons.logout,
              size: AppConstants.fontExtraLarge * 2,
              color: Colors.white,
            ),
            Text(
              // AppConstants.isOnlineMode == true
              //     ?
              "    Logout",
              // : "    Clear Database",
              style: AppConstants.titleBold.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
