import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/common-components/CustomImageWidget.dart';
import 'package:mytat/common-components/CustomToastMessage.dart';
import 'package:mytat/common-components/CustomUploadCardWidget.dart';
import 'package:mytat/common-components/CustomVideoPlayer.dart';
import 'package:mytat/common-components/CustomWarnigDialog.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/QuestionAnswersController.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:mytat/utilities/ImageUrls.dart';

class CenterPicsCustomCard extends StatelessWidget {
  final String? fileUrl;
  final String title;

  const CenterPicsCustomCard({super.key, required this.title, this.fileUrl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // await Get.find<SplashController>().getLocation();
        // Trendsetters Changes
        await Get.find<QuestionAnswersController>().clearFile();
        // Trendsetters Changes

        await Get.find<QuestionAnswersController>()
            .initializeCamera(title == "Profile Pic" ? 1 : 0);

        if (title == "Center Video") {
          if (fileUrl != null) {
            Get.to(CustomVideoPlayer(
              videoLink: Get.find<QuestionAnswersController>()
                  .currentAssessorCenterVideo
                  .toString(),
            ));
          } else {
            // await Get.find<QuestionAnswersController>()
            //     .pickImage(isWatermarkNeeded: false);
            Get.to(CustomImageUploaderWidget(
              // isAssessorClicking: true,
              fileName: title,
              isVideo: title == "Center Video" ? true : false,
            ));
          }
        } else {
          // await Get.find<QuestionAnswersController>()
          //     .pickImage(isWatermarkNeeded: false);
          Get.to(CustomImageUploaderWidget(
            // isAssessorClicking: true,
            fileName: title,
            isVideo: title == "Center Video" ? true : false,
          ));
        }
      },
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusLarge)),
            child: Padding(
              padding: EdgeInsets.all(AppConstants.fontSmall),
              child: Column(
                children: [
                  Text(
                    title,
                    style: AppConstants.titleBold,
                  ),
                  SizedBox(
                    height: AppConstants.fontSmall,
                  ),
                  fileUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusLarge),
                          child: title == "Center Video"
                              ? Image.asset(
                                  ImageUrls.playIcon,
                                  height: 120,
                                  width: Get.width * 0.4,
                                  fit: BoxFit.fill,
                                )
                              : Image.file(
                                  File(fileUrl!),
                                  height: 120,
                                  width: Get.width * 0.4,
                                  fit: BoxFit.fill,
                                ),
                        )
                      : CustomImageWidget(
                          path: ImageUrls.placeholderImage,
                          height: 120,
                          width: Get.width * 0.4,
                          borderRadius: AppConstants.borderRadiusLarge),
                ],
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 7,
            child: fileUrl != null
                ? InkWell(
                    onTap: () {
                      switch (title) {
                        case "Profile Pic":
                          Get.find<QuestionAnswersController>()
                              .assessorProfilePic();
                          break;
                        case "Aadhar Pic":
                          Get.find<QuestionAnswersController>()
                              .assessorAadharPhoto();
                          break;
                        case "Center Pic":
                          Get.find<QuestionAnswersController>()
                              .assessorCenterPic();
                          break;
                        case "Center Video":
                          Get.find<QuestionAnswersController>()
                              .assesorCenterVideo();
                          break;
                        default:
                      }
                    },
                    child: Icon(
                      Icons.cancel,
                      color: AppConstants.appRed,
                      size: AppConstants.paddingExtraLarge * 1.5,
                    ),
                  )
                : Icon(
                    Icons.arrow_circle_up_outlined,
                    color: AppConstants.successGreen,
                    size: AppConstants.paddingExtraLarge * 1.5,
                  ),
          )
        ],
      ),
    );
  }
}

// Get Assessor Documents List Online

class CenterPicsCustomCardOnline extends StatelessWidget {
  final String? fileUrl;
  final String title;

  const CenterPicsCustomCardOnline(
      {super.key, required this.title, this.fileUrl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Get.find<QuestionAnswersController>().clearFile();
        if (title == "Center Video") {
          if (fileUrl != null) {
            Get.to(CustomVideoPlayer(videoLink: fileUrl!));
          } else {
            await Get.find<QuestionAnswersController>()
                .initializeCamera(title == "Profile Pic" ? 1 : 0);
            Get.to(CustomImageUploaderWidget(
              fileName: title,
              uploadDirectly: true,
              isVideo: title == "Center Video" ? true : false,
            ));
          }
        } else {
          if (fileUrl != null) {
            CustomToast.showToast(
                "$title is already uploaded. Please remove Existing first.");
          } else {
            await Get.find<QuestionAnswersController>()
                .initializeCamera(title == "Profile Pic" ? 1 : 0);
            Get.to(CustomImageUploaderWidget(
              fileName: title,
              uploadDirectly: true,
              isVideo: title == "Center Video" ? true : false,
            ));
          }
        }
      },
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusLarge)),
            child: Padding(
              padding: EdgeInsets.all(AppConstants.fontSmall),
              child: Column(
                children: [
                  Text(
                    title,
                    style: AppConstants.titleBold,
                  ),
                  SizedBox(
                    height: AppConstants.fontSmall,
                  ),
                  fileUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusLarge),
                          child: title == "Center Video"
                              ? Image.asset(
                                  ImageUrls.playIcon,
                                  height: 120,
                                  width: Get.width * 0.4,
                                  fit: BoxFit.fill,
                                )
                              : Image.network(
                                  fileUrl!,
                                  height: 120,
                                  width: Get.width * 0.4,
                                  fit: BoxFit.fill,
                                ))
                      : CustomImageWidget(
                          path: ImageUrls.placeholderImage,
                          height: 120,
                          width: Get.width * 0.4,
                          borderRadius: AppConstants.borderRadiusLarge),
                ],
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 7,
            child: fileUrl != null
                ? InkWell(
                    onTap: () {
                      Get.dialog(
                          barrierDismissible: true,
                          CustomSuccessDialog(
                              title: "Do you want to Delete $title?",
                              logo: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomElevatedButton(
                                      height: 35,
                                      width: 120,
                                      buttonColor: AppConstants.successGreen,
                                      onTap: () {
                                        Get.back();
                                      },
                                      text: "Cancel"),
                                  CustomElevatedButton(
                                      height: 35,
                                      width: 120,
                                      buttonColor: AppConstants.appRed,
                                      onTap: () {
                                        Get.find<AssessorDashboardController>()
                                            .deleteAssessorOneDocumentOnline(
                                                title == "Profile Pic"
                                                    ? "Assessor Profile"
                                                    : title == "Aadhar Pic"
                                                        ? "Assessor Aadhar"
                                                        : title);
                                        Get.back();
                                        CustomToast.showToast("$title Deleted");
                                      },
                                      text: "Delete"),
                                ],
                              )));
                    },
                    child: Icon(
                      Icons.cancel,
                      color: AppConstants.appRed,
                      size: AppConstants.paddingExtraLarge * 1.5,
                    ),
                  )
                : Icon(
                    Icons.arrow_circle_up_outlined,
                    color: AppConstants.successGreen,
                    size: AppConstants.paddingExtraLarge * 1.5,
                  ),
          )
        ],
      ),
    );
  }
}
