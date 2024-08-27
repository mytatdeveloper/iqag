import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/common-components/CustomSnackbar.dart';
import 'package:mytat/model/AssesmentQuestionsModel.dart';
import 'package:mytat/model/AssessmentAllLanguagesListModel.dart';
import 'package:mytat/model/Online-Models/ServerDateTimeModel.dart';
import 'package:mytat/model/Syncing-Models/AssessorDocumentsUploadModels.dart';
import 'package:mytat/utilities/ApiClient.dart';
import 'package:mytat/utilities/ApiEndpoints.dart';

class AppConstants {
  static String? assesmentId;
  static String? assessorId;
  static String? assessorPassword;
  static String? assessorName;
  static String? companyId;
  static bool? isOnlineMode;
  static String? assessorEmail;

  static bool isTempOut = false;

  static String? serverDate;
  static String? serverTime;

  static List<String> instructionsList = [];

// Vaiables for storing the Address
  static String locationInformation = "";
  static String latitude = "";
  static String longitude = "";

  static String lastCenterVideoTimeStamp = "";

  static String photoWatermarkText = "";
  static String photoWatermarkText2 = "";
  static String photoWatermarkText3 = "";
  static String appVersion = "1.0";

  static String countryCode = "en";
  static AssessmentAvailableLanguageModel? vernacularLanguage;

  static String replacementPath = "/data/user/0/com.iqag.android/cache/";

// Duration Model -->
  static DurationModel? duration;

  static String imageUploadUrl = "${ApiEndpoints.baseUrl}/sscfiles/images/";
  static String videoUploadUrl = "${ApiEndpoints.baseUrl}/sscfiles/videos/";
  static String screenshotUploadUrl =
      "${ApiEndpoints.baseUrl}/uploads/screenshot/";

  static double paddingSmall = 8.0;
  static double paddingMedium = 10.0;
  static double paddingLarge = 12.0;
  static double paddingDefault = 14.0;
  static double paddingExtraLarge = 20.0;

  static double borderRadiusSmall = 10.0;
  static double borderRadiusMedium = 15.0;
  static double borderRadiusLarge = 20.0;
  static double borderRadiusCircular = 50.0;

  static double fontSmall = 8.0;
  static double fontMedium = 12.0;
  static double fontDefault = 14.0;
  static double fontLarge = 16.0;
  static double fontExtraLarge = 18.0;

// button sizes
  static double mediumButtonSized = 35.0;
  static double largebuttonSized = 45.0;

  static Color appBackground = const Color(0xffEFF2FC);
  static Color appPrimary = const Color(0xff5657CB);
  static Color appSecondary = const Color(0xffE68C31);
  static Color successGreen = const Color(0xff49D234);
  static Color appGreen = const Color(0xff25B7BB);
  static Color appGrey = Colors.grey;
  static Color appBlack = const Color.fromARGB(255, 0, 0, 0);
  static Color appRed = Colors.red;

  static Color theoryBg = const Color(0xfffafafa);

// headings textstyles
  static TextStyle title = TextStyle(
      color: AppConstants.appBlack, fontSize: AppConstants.fontExtraLarge);
  static TextStyle titleBold = TextStyle(
      fontWeight: FontWeight.bold,
      color: AppConstants.appBlack,
      fontSize: AppConstants.fontExtraLarge);
  static TextStyle titleItalic = TextStyle(
      color: AppConstants.appBlack,
      fontSize: Get.width < 400
          ? AppConstants.fontDefault
          : AppConstants.fontExtraLarge);

// subheadings textstyles
  static TextStyle subHeadingItalic = TextStyle(
      color: AppConstants.appBlack,
      fontStyle: FontStyle.italic,
      fontSize: AppConstants.fontLarge);
  static TextStyle subHeadingBold = TextStyle(
      fontWeight: FontWeight.bold,
      color: AppConstants.appBlack,
      fontSize: AppConstants.fontLarge);
  static TextStyle subHeading =
      TextStyle(color: AppConstants.appBlack, fontSize: AppConstants.fontLarge);

// body textstyles
  static TextStyle body = TextStyle(
      color: AppConstants.appBlack,
      fontSize:
          Get.width < 400 ? AppConstants.fontSmall : AppConstants.fontDefault);
  static TextStyle bodyBold = TextStyle(
      fontWeight: FontWeight.bold,
      color: AppConstants.appBlack,
      fontSize:
          Get.width < 400 ? AppConstants.fontSmall : AppConstants.fontDefault);
  static TextStyle bodyItalic = TextStyle(
      fontStyle: FontStyle.italic,
      color: AppConstants.appBlack,
      fontSize:
          Get.width < 400 ? AppConstants.fontSmall : AppConstants.fontDefault);

  static BoxShadow appShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 5,
    blurRadius: 7,
    offset: const Offset(0, 3),
  );

  static AssessorDocumentsUploadModel? assessorDocumentsUploadModel;
  static AssessorDocumentsUploadModel?
      assessorDocumentsUploadModelwithReplacedUrl;

  static String getCurrentDateFormatted() {
    final now = DateTime.now();
    final format = DateFormat('d-MMMM-yyyy');
    return format.format(now);
  }

  // exam date time code
  static String getFormatedCurrentDate(DateTime dateTime) {
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    final formattedDay = twoDigits(dateTime.day);
    final formattedMonth = twoDigits(dateTime.month);
    final formattedYear = dateTime.year;

    return '$formattedYear-$formattedMonth-$formattedDay';
  }

  static String getFormatedCurrentTime(DateTime dateTime) {
    String period = 'AM';

    int hours = dateTime.hour;
    if (hours >= 12) {
      period = 'PM';
      if (hours > 12) {
        hours -= 12;
      }
    }

    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    final formattedHours = twoDigits(hours);
    final minutes = twoDigits(dateTime.minute);
    final seconds = twoDigits(dateTime.second);

    return '$formattedHours:$minutes:$seconds $period';
  }
  // exam date time code

// exit the app dialog
  static Future<bool> onWillPop(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsPadding:
            EdgeInsets.only(bottom: AppConstants.paddingDefault * 2),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(AppConstants.borderRadiusLarge))),
        title: Center(
          child: Text(
            'Exit App',
            style: AppConstants.titleBold,
          ),
        ),
        content: Text(
          'Do you want to exit the app?',
          style: AppConstants.subHeading,
          textAlign: TextAlign.center,
        ),
        actions: [
          CustomElevatedButton(
              width: 150,
              height: AppConstants.mediumButtonSized,
              buttonStyle: AppConstants.commonButtonStyle,
              buttonColor: AppConstants.appGrey,
              onTap: () {
                Navigator.of(context).pop(false);
              },
              text: "No"),
          CustomElevatedButton(
              width: 150,
              buttonStyle: AppConstants.commonButtonStyle,
              height: AppConstants.mediumButtonSized,
              buttonColor: AppConstants.appRed,
              onTap: () {
                exit(0);
              },
              text: "Yes")

          // TextButton(
          //   onPressed: () => Navigator.of(context).pop(false),
          //   child: const Text('No'),
          // ),
          // TextButton(
          //   onPressed: () => Navigator.of(context).pop(true),
          //   child: const Text('Yes'),
          // ),
        ],
      ),
    );
  }

  static Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      CustomSnackBar.customSnackBar(false, "No Internet Connection");
      return false;
    } else {
      print("Connected to the Network");
      return true;
    }
  }

  static Future<ServerDateTimeModel?> getServerDateAndTime() async {
    try {
      Map<String, dynamic> response =
          await ApiClient().get(ApiEndpoints.getServerDateAndTime);

      ServerDateTimeModel serverDateTimeModel =
          ServerDateTimeModel.fromJson(response);

      print("Server Time: ${serverDateTimeModel.time}");
      print("Server Date: ${serverDateTimeModel.date}");

      return serverDateTimeModel;
    } catch (e) {
      print("Exception While Getting Server Time: $e");
      return null;
    }
  }

  static TextStyle commonButtonStyle = AppConstants.subHeading
      .copyWith(color: Colors.white, fontSize: AppConstants.fontExtraLarge);

  static Uint8List base64ToBytes(String base64String) {
    return const Base64Decoder().convert(base64String);
  }

  static Style htmlStyle = Style(
      margin: EdgeInsets.zero,
      fontSize: const FontSize(40.0),
      fontWeight: FontWeight.normal,
      lineHeight: LineHeight.number(1));
}
