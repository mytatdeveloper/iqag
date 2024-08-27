import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomAppBar.dart';
import 'package:mytat/common-components/CustomCameraWidget.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/common-components/CustomLoadingIndicator.dart';
import 'package:mytat/common-components/CustomToastMessage.dart';
import 'package:mytat/common-components/CustomWarnigDialog.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/QuestionAnswersController.dart';
import 'package:mytat/model/Online-Models/ServerDateTimeModel.dart';
import 'package:mytat/model/StudentsBatchModel.dart';
import 'package:mytat/utilities/AppConstants.dart';

import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';

class CustomImageUploaderWidget extends StatelessWidget {
  final Batches? candidate;
  final String fileName;
  // final Annexurelist? assessor;
  final bool isVideo;
  // final Annexurelist? document;
  final bool isAnnexure;
  // final bool isFromAssessorUpload;
  final bool uploadDirectly;

  // final Annexurelist? document;
  final bool isAssessorClicking;

  const CustomImageUploaderWidget(
      {super.key,
      this.candidate,
      required this.fileName,
      // this.assessor,
      this.isVideo = false,
      this.isAnnexure = false,
      this.isAssessorClicking = false,
      this.uploadDirectly = false
      // this.document
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: fileName,
        showRecordingTime: isVideo == true,
      ),
      body: GetBuilder<QuestionAnswersController>(
          builder: (questionAnswerController) {
        return WillPopScope(
          onWillPop: () async {
            if (questionAnswerController.isClickingPhoto == true) {
              questionAnswerController.changeIsClickingPhoto(false);
              return true;
            }
            if (questionAnswerController.isRecording == true) {
              CustomToast.showToast("You can not go back while Recording");
              return false;
              // questionAnswerController.saveDocumentsToLocal(fileName);
              // questionAnswerController.resetRecordingTimer();
              // questionAnswerController.resetTimer();
            } else {
              if (questionAnswerController.currentClickedFile != null) {
                questionAnswerController.clearFile();
                // questionAnswerController.saveDocumentsToLocal(fileName);
                return true;
              } else {
                return true;
              }
            }
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: AppConstants.paddingSmall),
            child: Column(
              children: [
                Expanded(
                  child: questionAnswerController.isFileClicked
                      ? isVideo
                          ? Icon(
                              Icons.check_circle,
                              color: AppConstants.successGreen,
                              size: Get.height * 0.4,
                            )
                          : Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(File(
                                        questionAnswerController
                                                .currentClickedFile ??
                                            "")),
                                    fit: BoxFit.fill),
                              ),
                              width: Get.width,
                            )
                      : CameraWidget(
                          width: Get.width,
                          cameraController:
                              questionAnswerController.cameraController),
                ),
                questionAnswerController.isRecording == true
                    ? CustomElevatedButton(
                        buttonStyle: AppConstants.commonButtonStyle,
                        buttonColor: AppConstants.appRed,
                        onTap: () async {
                          await questionAnswerController.stopRecording();
                          questionAnswerController.stopRecordingTimer();
                        },
                        text: "Stop Recording")
                    : !questionAnswerController.showSaveButton
                        ? questionAnswerController.isClickingPhoto
                            ? const CustomLoadingIndicator()
                            : CustomElevatedButton(
                                buttonStyle: AppConstants.commonButtonStyle,
                                onTap: () async {
                                  if (isVideo) {
                                    if (fileName == "Center Video") {
                                      Get.find<AssessorDashboardController>()
                                          .getServerDateTimeMode();
                                      SharedPreferences _prefs =
                                          await SharedPreferences.getInstance();
                                      _prefs.setString(
                                          "assessorCenterVideo",
                                          Get.find<AssessorDashboardController>()
                                                      .centerVideoDateTime !=
                                                  null
                                              ? "${Get.find<AssessorDashboardController>().centerVideoDateTime!.date}, ${Get.find<AssessorDashboardController>().centerVideoDateTime!.time}"
                                              : "");
                                    }
                                    await questionAnswerController
                                        .startRecording();
                                    questionAnswerController
                                        .startRecordingTimer();
                                  } else {
                                    await questionAnswerController.takePicture(
                                        isWatermarkNeeded:
                                            isAssessorClicking == true
                                                ? false
                                                : true);
                                  }
                                },
                                text: "Click $fileName")
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppConstants.paddingExtraLarge),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          textStyle:
                                              AppConstants.commonButtonStyle,
                                          primary: Colors.green),
                                      onPressed: () async {
                                        if (isVideo) {
                                          questionAnswerController
                                              .resetRecordingTimer();
                                        }
                                        Get.dialog(
                                            barrierDismissible: false,
                                            const CustomSuccessDialog(
                                                title: "Saving File",
                                                logo:
                                                    CustomLoadingIndicator()));
                                        if (uploadDirectly == true &&
                                            AppConstants.isOnlineMode == true) {
                                          if (questionAnswerController
                                                  .currentClickedFile !=
                                              null) {
                                            await Get.find<
                                                    AssessorDashboardController>()
                                                .syncAssessorOneDocumentOnline(
                                                    fileName == "Profile Pic"
                                                        ? "Assessor Profile"
                                                        : fileName ==
                                                                "Aadhar Pic"
                                                            ? "Assessor Aadhar"
                                                            : fileName,
                                                    questionAnswerController
                                                        .currentClickedFile!);
                                          }
                                        }
                                        // if (assessor != null) {
                                        if (isAnnexure == true) {
                                          // questionAnswerController
                                          //     .saveToAnexureList(document!);
                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            Get.back();
                                            Get.back();
                                          });
                                        } else {
                                          questionAnswerController
                                              .saveDocumentsToLocal(fileName);
                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            Get.back();
                                            Get.back();
                                          });
                                        }
                                      },
                                      child: Text(
                                        "Save $fileName",
                                        textAlign: TextAlign.center,
                                        style: AppConstants.titleItalic
                                            .copyWith(color: Colors.white),
                                      )),
                                ),
                                SizedBox(
                                  width: AppConstants.paddingExtraLarge,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          textStyle:
                                              AppConstants.commonButtonStyle,
                                          primary: AppConstants.appSecondary),
                                      onPressed: () async {
                                        if (isVideo) {
                                          questionAnswerController
                                              .resetRecordingTimer();
                                        }
                                        questionAnswerController
                                            .changeShowButtonVisibility();
                                      },
                                      child: Text(
                                        "Upload Again",
                                        textAlign: TextAlign.center,
                                        style: AppConstants.titleItalic
                                            .copyWith(color: Colors.white),
                                      )),
                                ),
                              ],
                            ),
                          )
              ],
            ),
          ),
        );
      }),
    );
  }
}
