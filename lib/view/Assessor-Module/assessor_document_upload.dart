import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomAppBar.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/common-components/CustomLoadingIndicator.dart';
import 'package:mytat/common-components/CustomSnackbar.dart';
import 'package:mytat/common-components/CustomUploadCardWidget.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/QuestionAnswersController.dart';
import 'package:mytat/model/FilePickerMode.dart';
import 'package:mytat/model/StudentsBatchModel.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:mytat/utilities/ImageUrls.dart';

class AssessorDocumentUploadScreen extends StatelessWidget {
  final List<FilePickerModel> docsList;
  final Batches candidate;
  const AssessorDocumentUploadScreen(
      {super.key, required this.docsList, required this.candidate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Documents Upload",
        icon: const Icon(Icons.arrow_back),
        onpressed: () {
          Get.find<QuestionAnswersController>().submitStudentDocuments();
          Get.back();
        },
      ),
      body: GetBuilder<QuestionAnswersController>(
          builder: (questionAnswersController) {
        return WillPopScope(
          onWillPop: () async {
            Get.find<QuestionAnswersController>().submitStudentDocuments();
            return true;
          },
          child: Padding(
            padding: EdgeInsets.all(AppConstants.paddingExtraLarge),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Candidate Name: ${candidate.name}",
                    style: AppConstants.titleItalic,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Candidate ID: ${candidate.enrollmentNo}",
                    style: AppConstants.titleItalic,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: AppConstants.paddingExtraLarge,
                  ),
                  // Profile Card -->
                  Card(
                    color: questionAnswersController
                                .currentCandidateProfilePhoto !=
                            null
                        ? AppConstants.successGreen.withOpacity(0.8)
                        : AppConstants.appRed.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(
                              AppConstants.borderRadiusCircular),
                          bottomLeft: Radius.circular(
                              AppConstants.borderRadiusCircular)),
                    ),
                    margin: EdgeInsets.only(
                        bottom: AppConstants.paddingExtraLarge * 2),
                    child: InkWell(
                      onTap: () async {
                        await Get.find<QuestionAnswersController>()
                            .initializeCamera(null);
                        Get.to(CustomImageUploaderWidget(
                            candidate: candidate, fileName: "Profile Photo"));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(
                                    AppConstants.borderRadiusCircular),
                                bottomLeft: Radius.circular(
                                    AppConstants.borderRadiusCircular)),
                            child: questionAnswersController
                                        .currentCandidateProfilePhoto !=
                                    null
                                ? Image.file(
                                    File(questionAnswersController
                                            .currentCandidateProfilePhoto ??
                                        ""),
                                    height: Get.height * 0.2,
                                    width: Get.width * 0.5,
                                    fit: BoxFit.fill,
                                  )
                                : Image.asset(
                                    ImageUrls.placeholderImage,
                                    height: Get.height * 0.2,
                                    width: Get.width * 0.5,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                          SizedBox(
                            width: AppConstants.paddingExtraLarge,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Profile Photo",
                                style: AppConstants.titleBold,
                              ),
                              Chip(
                                backgroundColor: questionAnswersController
                                            .currentCandidateProfilePhoto !=
                                        null
                                    ? AppConstants.successGreen.withOpacity(0.2)
                                    : AppConstants.appRed.withOpacity(0.2),
                                avatar: Icon(
                                  questionAnswersController
                                              .currentCandidateProfilePhoto !=
                                          null
                                      ? Icons.check
                                      : Icons.camera_alt,
                                  color: questionAnswersController
                                              .currentCandidateProfilePhoto !=
                                          null
                                      ? AppConstants.successGreen
                                      : AppConstants.appRed,
                                ),
                                label: Text(
                                    questionAnswersController
                                                .currentCandidateProfilePhoto !=
                                            null
                                        ? "Uploaded"
                                        : "Click Image",
                                    style: AppConstants.bodyItalic),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Aadhar Front Photos Card  -->
                  Card(
                    color: questionAnswersController
                                .currentCandidateAdharFrontPic !=
                            null
                        ? AppConstants.successGreen.withOpacity(0.8)
                        : AppConstants.appRed.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(
                              AppConstants.borderRadiusCircular),
                          bottomLeft: Radius.circular(
                              AppConstants.borderRadiusCircular)),
                    ),
                    margin: EdgeInsets.only(
                        bottom: AppConstants.paddingExtraLarge * 2),
                    child: InkWell(
                      onTap: () async {
                        await Get.find<QuestionAnswersController>()
                            .initializeCamera(null);

                        Get.to(CustomImageUploaderWidget(
                            candidate: candidate, fileName: "Aadhar Front"));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(
                                    AppConstants.borderRadiusCircular),
                                bottomLeft: Radius.circular(
                                    AppConstants.borderRadiusCircular)),
                            child: questionAnswersController
                                        .currentCandidateAdharFrontPic !=
                                    null
                                ? Image.file(
                                    File(questionAnswersController
                                            .currentCandidateAdharFrontPic ??
                                        ""),
                                    height: Get.height * 0.2,
                                    width: Get.width * 0.5,
                                    fit: BoxFit.fill,
                                  )
                                : Image.asset(
                                    ImageUrls.placeholderImage,
                                    height: Get.height * 0.2,
                                    width: Get.width * 0.5,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                          SizedBox(
                            width: AppConstants.paddingExtraLarge,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Aadhar Front",
                                style: AppConstants.titleBold,
                              ),
                              Chip(
                                backgroundColor: questionAnswersController
                                            .currentCandidateAdharFrontPic !=
                                        null
                                    ? AppConstants.successGreen.withOpacity(0.2)
                                    : AppConstants.appRed.withOpacity(0.2),
                                avatar: Icon(
                                  questionAnswersController
                                              .currentCandidateAdharFrontPic !=
                                          null
                                      ? Icons.check
                                      : Icons.camera_alt,
                                  color: questionAnswersController
                                              .currentCandidateAdharFrontPic !=
                                          null
                                      ? AppConstants.successGreen
                                      : AppConstants.appRed,
                                ),
                                label: Text(
                                    questionAnswersController
                                                .currentCandidateAdharFrontPic !=
                                            null
                                        ? "Uploaded"
                                        : "Click Image",
                                    style: AppConstants.bodyItalic),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Aadhar Back Photos Card  -->
                  Card(
                    color: questionAnswersController
                                .currentCandidateAdharBackPic !=
                            null
                        ? AppConstants.successGreen.withOpacity(0.8)
                        : AppConstants.appRed.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(
                              AppConstants.borderRadiusCircular),
                          bottomLeft: Radius.circular(
                              AppConstants.borderRadiusCircular)),
                    ),
                    margin: EdgeInsets.only(
                        bottom: AppConstants.paddingExtraLarge * 2),
                    child: InkWell(
                      onTap: () async {
                        await Get.find<QuestionAnswersController>()
                            .initializeCamera(null);
                        Get.to(CustomImageUploaderWidget(
                            candidate: candidate, fileName: "Aadhar Back"));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(
                                    AppConstants.borderRadiusCircular),
                                bottomLeft: Radius.circular(
                                    AppConstants.borderRadiusCircular)),
                            child: questionAnswersController
                                        .currentCandidateAdharBackPic !=
                                    null
                                ? Image.file(
                                    File(questionAnswersController
                                            .currentCandidateAdharBackPic ??
                                        ""),
                                    height: Get.height * 0.2,
                                    width: Get.width * 0.5,
                                    fit: BoxFit.fill,
                                  )
                                : Image.asset(
                                    ImageUrls.placeholderImage,
                                    height: Get.height * 0.2,
                                    width: Get.width * 0.5,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                          SizedBox(
                            width: AppConstants.paddingExtraLarge,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Aadhar Back",
                                style: AppConstants.titleBold,
                              ),
                              Chip(
                                backgroundColor: questionAnswersController
                                            .currentCandidateAdharBackPic !=
                                        null
                                    ? AppConstants.successGreen.withOpacity(0.2)
                                    : AppConstants.appRed.withOpacity(0.2),
                                avatar: Icon(
                                  questionAnswersController
                                              .currentCandidateAdharBackPic !=
                                          null
                                      ? Icons.check
                                      : Icons.camera_alt,
                                  color: questionAnswersController
                                              .currentCandidateAdharBackPic !=
                                          null
                                      ? AppConstants.successGreen
                                      : AppConstants.appRed,
                                ),
                                label: Text(
                                    questionAnswersController
                                                .currentCandidateAdharBackPic !=
                                            null
                                        ? "Uploaded"
                                        : "Click Image",
                                    style: AppConstants.bodyItalic),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  questionAnswersController.isLoadingResponse == true
                      ? const Center(
                          child: CustomLoadingIndicator(),
                        )
                      : CustomElevatedButton(
                          onTap: () async {
                            // await questionAnswersController
                            //     .insertCandidateDocuments(candidate.id);
                            questionAnswersController
                                .changeIsLoadingResponse(true);
                            if (await questionAnswersController
                                    .insertCandidateDocuments(candidate.id) !=
                                null) {
                              questionAnswersController
                                  .updateCandidatePracticalOrVivaDocumentsFlag(
                                      "P", candidate);
                              if (AppConstants.isOnlineMode == true) {
                                await Get.find<AssessorDashboardController>()
                                    .syncVivaAndPracticalOnlyOneCanddidateDocumentsOnline(
                                        candidate.id.toString());
                              }
                              questionAnswersController
                                  .submitStudentDocuments();
                              await Get.find<AssessorDashboardController>()
                                  .getOfflineStudentsList();
                              // Get.find<AssessorDashboardController>()
                              //     .getAllCompletedDocumentsCandidatesList();

                              questionAnswersController
                                  .changeIsLoadingResponse(false);
                              Get.back();
                              CustomSnackBar.customSnackBar(true,
                                  "${candidate.name} Documents Saved Successfully");
                            } else {
                              CustomSnackBar.customSnackBar(false,
                                  "${candidate.name} All Documents are Mandatory",
                                  isLong: true);
                              questionAnswersController
                                  .changeIsLoadingResponse(false);
                            }
                          },
                          text: "Submit")
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
