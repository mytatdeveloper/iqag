import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CenterPicsCustomCard.dart';
import 'package:mytat/common-components/CustomAnnexureCardWidget.dart';
import 'package:mytat/common-components/CustomAppBar.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/common-components/CustomLoadingIndicator.dart';
import 'package:mytat/common-components/CustomSnackbar.dart';
import 'package:mytat/common-components/CustomWarnigDialog.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/QuestionAnswersController.dart';
import 'package:mytat/controller/SplashController.dart';
import 'package:mytat/model/Syncing-Models/AssessorDocumentsUploadModels.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssessorDocumentsManagementScreen extends StatelessWidget {
  const AssessorDocumentsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.find<QuestionAnswersController>().makeCurentSelectedDopdownNull();
        if (Get.find<QuestionAnswersController>().isCameraOpen) {
          Get.find<QuestionAnswersController>().closeCamera();
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppConstants.appBackground,
        appBar: CustomAppBar(title: "Assessor Documents Upload"),
        body: GetBuilder<QuestionAnswersController>(
            builder: (questionAnswersController) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Center Documents Row Here -->
                SizedBox(
                  height: AppConstants.paddingExtraLarge,
                ),
                Text(
                  "Assessor Center Documents:",
                  style: AppConstants.titleBold,
                ),
                SizedBox(
                  height: AppConstants.paddingExtraLarge,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CenterPicsCustomCard(
                        title: "Profile Pic",
                        fileUrl: questionAnswersController
                            .currentAssessorProfilePhoto),
                    CenterPicsCustomCard(
                        title: "Aadhar Pic",
                        fileUrl:
                            questionAnswersController.currentAssessorAdharPic),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CenterPicsCustomCard(
                        title: "Center Pic",
                        fileUrl:
                            questionAnswersController.currentAssessorCenterPic),
                    CenterPicsCustomCard(
                        title: "Center Video",
                        fileUrl: questionAnswersController
                            .currentAssessorCenterVideo),
                  ],
                ),
                SizedBox(
                  height: AppConstants.paddingDefault,
                ),
                Text(
                  "Assessor Annexure Documents:",
                  style: AppConstants.titleBold,
                ),
                SizedBox(
                  height: AppConstants.paddingDefault,
                ),
                Visibility(
                    visible: questionAnswersController
                        .assessorLocalDocumentsList.isNotEmpty,
                    child: const CustomAnnexureCardWidget()),
                questionAnswersController.anexureUploadedList.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: AppConstants.paddingExtraLarge,
                            left: AppConstants.paddingExtraLarge,
                            right: AppConstants.paddingExtraLarge),
                        child: ListView.builder(
                            itemCount: questionAnswersController
                                .anexureUploadedList.length,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: AppConstants.paddingSmall),
                                child: Card(
                                  child: SizedBox(
                                      height: 100,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: Image.file(
                                              File(questionAnswersController
                                                      .anexureUploadedList[
                                                          index]
                                                      .image ??
                                                  ""),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          SizedBox(
                                            width: AppConstants.paddingDefault,
                                          ),
                                          Expanded(
                                            child: Text(
                                              questionAnswersController
                                                  .anexureUploadedList[index]
                                                  .name
                                                  .toString(),
                                              style:
                                                  AppConstants.subHeadingBold,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right:
                                                    AppConstants.paddingSmall),
                                            child: InkWell(
                                              onTap: () {
                                                questionAnswersController
                                                    .removeFromAnexureLocalUploadedList(
                                                        questionAnswersController
                                                                .anexureUploadedList[
                                                            index]);
                                                questionAnswersController
                                                    .anexureUploadedList[index]
                                                    .name
                                                    .toString();
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: AppConstants.appRed,
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              );
                            }),
                      )
                    : const SizedBox.shrink(),
                SizedBox(height: AppConstants.paddingDefault),
                questionAnswersController.isLoadingResponse == true
                    ? const CustomLoadingIndicator()
                    : CustomElevatedButton(
                        onTap:
                            questionAnswersController
                                            .currentAssessorCenterPic ==
                                        null ||
                                    questionAnswersController.currentAssessorAdharPic ==
                                        null ||
                                    questionAnswersController
                                            .currentAssessorCenterVideo ==
                                        null ||
                                    questionAnswersController
                                            .currentAssessorProfilePhoto ==
                                        null
                                ? () {
                                    CustomSnackBar.customSnackBar(true,
                                        "All The Center Documents are mandatory");
                                  }
                                : () async {
                                    Get.dialog(
                                        barrierDismissible: false,
                                        CustomWarningDialog(
                                            onPress: () async {
                                              Get.back();
                                              questionAnswersController
                                                  .changeIsLoadingResponse(
                                                      true);
                                              // Location Code
                                              await Get.find<SplashController>()
                                                  .getLocation();
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              // saving center documents
                                              await questionAnswersController
                                                  .saveCenterDocumentsToSharedPreferences();
                                              // saving center documents

                                              final assessorDocumentsUploadModelTemp =
                                                  AssessorDocumentsUploadModel(
                                                assessorInfo: AssessorInfo(
                                                  // Server Time Sending Data
                                                  time: AppConstants
                                                      .lastCenterVideoTimeStamp,
                                                  // Server Time Sending Data

                                                  assessorId: int.parse(
                                                      AppConstants.assessorId ??
                                                          ""),
                                                  lat: AppConstants
                                                      .locationInformation,
                                                  long:
                                                      "${AppConstants.latitude}, ${AppConstants.longitude}",
                                                  assmentId: int.parse(
                                                      AppConstants
                                                              .assesmentId ??
                                                          ""),
                                                ),
                                                assessorCenterDocuments:
                                                    AssessorCenterDocuments(
                                                  assessorProfile:
                                                      questionAnswersController
                                                          .currentAssessorProfilePhoto,
                                                  assessorAadhar:
                                                      questionAnswersController
                                                          .currentAssessorAdharPic,
                                                  assessorCenterVideo:
                                                      questionAnswersController
                                                          .currentAssessorCenterVideo,
                                                  assessorCenterPic:
                                                      questionAnswersController
                                                          .currentAssessorCenterPic,
                                                  name:
                                                      AppConstants.assessorName,
                                                ),
                                                assessorAnexureDocuments:
                                                    AssessorAnexureDocuments(
                                                  annexure: null,
                                                  attendanceSheet: null,
                                                  tPFeedbackForm: null,
                                                  annexureM: null,
                                                  assesmentCheckList: null,
                                                  assessorFeedbackForm: null,
                                                  assessorUndertaking: null,
                                                  mannualOrBiometric: null,
                                                ),
                                                assessorOtherDocuments:
                                                    AssessorOtherDocuments(
                                                  otherDocumentsKey: [],
                                                  otherDocumentsValue: [],
                                                ),
                                              );
                                              // replacing URL's
                                              final assessorDocumentsUploadModelTempWithReplacedUrl =
                                                  AssessorDocumentsUploadModel(
                                                assessorInfo: AssessorInfo(
                                                  // Server Time Sending Data
                                                  time: AppConstants
                                                      .lastCenterVideoTimeStamp,
                                                  // Server Time Sending Data

                                                  assessorId: int.parse(
                                                      AppConstants.assessorId ??
                                                          ""),
                                                  lat: AppConstants
                                                      .locationInformation,
                                                  long:
                                                      "${AppConstants.latitude}, ${AppConstants.longitude}",
                                                  assmentId: int.parse(
                                                      AppConstants
                                                              .assesmentId ??
                                                          ""),
                                                ),
                                                assessorCenterDocuments:
                                                    AssessorCenterDocuments(
                                                  assessorProfile:
                                                      questionAnswersController
                                                          .currentAssessorProfilePhoto!
                                                          .replaceFirst(
                                                              AppConstants
                                                                  .replacementPath,
                                                              ""),
                                                  assessorAadhar:
                                                      questionAnswersController
                                                          .currentAssessorAdharPic!
                                                          .replaceFirst(
                                                              AppConstants
                                                                  .replacementPath,
                                                              ""),
                                                  assessorCenterVideo:
                                                      questionAnswersController
                                                          .currentAssessorCenterVideo!
                                                          .replaceFirst(
                                                              AppConstants
                                                                  .replacementPath,
                                                              ""),
                                                  assessorCenterPic:
                                                      questionAnswersController
                                                          .currentAssessorCenterPic!
                                                          .replaceFirst(
                                                              AppConstants
                                                                  .replacementPath,
                                                              ""),
                                                  name:
                                                      AppConstants.assessorName,
                                                ),
                                                assessorAnexureDocuments:
                                                    AssessorAnexureDocuments(
                                                  annexure: null,
                                                  attendanceSheet: null,
                                                  tPFeedbackForm: null,
                                                  annexureM: null,
                                                  assesmentCheckList: null,
                                                  assessorFeedbackForm: null,
                                                  assessorUndertaking: null,
                                                  mannualOrBiometric: null,
                                                ),
                                                assessorOtherDocuments:
                                                    AssessorOtherDocuments(
                                                  otherDocumentsKey: [],
                                                  otherDocumentsValue: [],
                                                ),
                                              );
                                              AppConstants
                                                      .assessorDocumentsUploadModel =
                                                  assessorDocumentsUploadModelTemp;
                                              AppConstants
                                                      .assessorDocumentsUploadModelwithReplacedUrl =
                                                  assessorDocumentsUploadModelTempWithReplacedUrl;
                                              print(
                                                  "Without Replacing: ${AppConstants.assessorDocumentsUploadModel!.toJson()}");
                                              print(
                                                  "After Replacing: ${AppConstants.assessorDocumentsUploadModelwithReplacedUrl!.toJson()}");
                                              // Saving List to Local Database
                                              await questionAnswersController
                                                  .saveAnnexureListToLocalDatabase();
                                              // Saving List to Local Database
                                              questionAnswersController
                                                  .changeIsLoadingResponse(
                                                      false);
                                              Get.back();
                                            },
                                            bottomSpacing:
                                                AppConstants.paddingExtraLarge,
                                            title:
                                                "Please check that all the documents are uploaded successfully and at its accurate slot! You will not be allow to upload it again"));
                                  },
                        buttonStyle: AppConstants.commonButtonStyle,
                        text: "Save Documents"),
                SizedBox(
                  height: AppConstants.paddingExtraLarge,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
