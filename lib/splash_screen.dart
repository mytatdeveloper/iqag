import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomImageWidget.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/Online-Controller/OnlineAssessorDashboardController.dart';
import 'package:mytat/controller/SplashController.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:mytat/utilities/ImageUrls.dart';
import 'package:mytat/view/Assessor-Module/assessor_dashboard_screen.dart';
import 'package:mytat/view/Authorization/assessor_import_assesment_screen.dart';
import 'package:mytat/view/Authorization/login_screen.dart';
import 'package:mytat/view/Online-Mode/online_assessor_dashboard.dart';
import 'package:mytat/view/user_mode_screen.dart';
import 'package:path_provider/path_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getBaseData();
    super.initState();
  }

  Future<void> getBaseData() async {
    // if (AppConstants.isOnlineMode != true) {
    await Get.find<SplashController>().getLocation();
    // Get.find<SplashController>().setLoadingIndicatorValue(0.2);

    var path = await getTemporaryDirectory();
    AppConstants.replacementPath = "${path.path}/";
    print("Replacement Path set To: ${AppConstants.replacementPath}");

    await Get.find<AssessorDashboardController>()
        .getAllTemporaryQuestionsList();
    // } else {
    await Get.find<OnlineAssessorDashboardController>()
        .getAllTemporaryQuestionsList();
    // Get.find<SplashController>().setLoadingIndicatorValue(0.4);

    // }
    String? status =
        await Get.find<SplashController>().getAssessorCredentials();
    // Get.find<SplashController>().setLoadingIndicatorValue(0.7);

    Get.off(status == "imported"
        ? AppConstants.isTempOut == true
            ? LoginScreen(
                userType: "assessor",
                isOnline: AppConstants.isOnlineMode ?? false)
            : AppConstants.isOnlineMode == false
                ? const AssessorDashboardScreen()
                : const OnlineAssessorDashboardScreen()
        : status == "notImported"
            ? const ImportAssesmentScreen()
            : const UserModeScreen());

    // Get.find<SplashController>().setLoadingIndicatorValue(1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: AppConstants.appBackground,
      child: CustomImageWidget(
        path: ImageUrls.companyLogo,
        height: Get.height * 0.2,
        width: Get.width * 0.5,
      ),
    );
  }
}
