import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CenterPicsCustomCard.dart';
import 'package:mytat/common-components/CustomAnnexureCardWidget.dart';
import 'package:mytat/common-components/CustomAppBar.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/common-components/CustomToastMessage.dart';
import 'package:mytat/common-components/CustomWarnigDialog.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/QuestionAnswersController.dart';
import 'package:mytat/utilities/AppConstants.dart';

class OnlineAssessorDocumentsManagementScreen extends StatelessWidget {
  const OnlineAssessorDocumentsManagementScreen({super.key});

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
        appBar: CustomAppBar(
            icon: const Icon(Icons.arrow_back),
            title: "Assessor Documents Upload",
            onpressed: () {
              if (Get.find<QuestionAnswersController>().isCameraOpen) {
                Get.find<QuestionAnswersController>().closeCamera();
              }
              Get.back();
            }),
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
                    CenterPicsCustomCardOnline(
                        title: "Profile Pic",
                        fileUrl: questionAnswersController
                            .getSpecificUploadedAssessorDocuments(
                                "Profile Pic")),
                    CenterPicsCustomCardOnline(
                        title: "Aadhar Pic",
                        fileUrl: questionAnswersController
                            .getSpecificUploadedAssessorDocuments(
                                "Aadhar Pic")),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CenterPicsCustomCardOnline(
                        title: "Center Pic",
                        fileUrl: questionAnswersController
                            .getSpecificUploadedAssessorDocuments(
                                "Center Pic")),
                    CenterPicsCustomCardOnline(
                        title: "Center Video",
                        fileUrl: questionAnswersController
                            .getSpecificUploadedAssessorDocuments(
                                "Center Video")),
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
                questionAnswersController
                        .alreadySynedAssessorDocumentsList.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: AppConstants.paddingExtraLarge,
                            left: AppConstants.paddingExtraLarge,
                            right: AppConstants.paddingExtraLarge),
                        child: ListView.builder(
                            itemCount: questionAnswersController
                                .alreadySynedAssessorDocumentsList.length,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              if (questionAnswersController
                                          .alreadySynedAssessorDocumentsList[
                                              index]
                                          .caption
                                          .toString() ==
                                      "Center Video" ||
                                  questionAnswersController
                                          .alreadySynedAssessorDocumentsList[
                                              index]
                                          .caption
                                          .toString() ==
                                      "Assessor Profile" ||
                                  questionAnswersController
                                          .alreadySynedAssessorDocumentsList[
                                              index]
                                          .caption
                                          .toString() ==
                                      "Assessor Aadhar" ||
                                  questionAnswersController
                                          .alreadySynedAssessorDocumentsList[
                                              index]
                                          .caption
                                          .toString() ==
                                      "Center Pic") {
                                return const SizedBox.shrink();
                              }
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
                                            child: Image.network(
                                              questionAnswersController
                                                  .alreadySynedAssessorDocumentsList[
                                                      index]
                                                  .captionVal
                                                  .toString(),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          SizedBox(
                                            width: AppConstants.paddingDefault,
                                          ),
                                          Expanded(
                                            child: Text(
                                              questionAnswersController
                                                  .alreadySynedAssessorDocumentsList[
                                                      index]
                                                  .caption
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
                                                  Get.dialog(
                                                      barrierDismissible: true,
                                                      CustomSuccessDialog(
                                                          title:
                                                              "Do you want to Delete ${questionAnswersController.alreadySynedAssessorDocumentsList[index].caption}?",
                                                          logo: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              CustomElevatedButton(
                                                                  height: 35,
                                                                  width: 120,
                                                                  buttonColor:
                                                                      AppConstants
                                                                          .successGreen,
                                                                  onTap: () {
                                                                    Get.back();
                                                                  },
                                                                  text:
                                                                      "Cancel"),
                                                              CustomElevatedButton(
                                                                  height: 35,
                                                                  width: 120,
                                                                  buttonColor:
                                                                      AppConstants
                                                                          .appRed,
                                                                  onTap:
                                                                      () async {
                                                                    Get.find<AssessorDashboardController>().deleteAssessorOneDocumentOnline(questionAnswersController
                                                                        .alreadySynedAssessorDocumentsList[
                                                                            index]
                                                                        .caption
                                                                        .toString());
                                                                    Get.back();
                                                                    CustomToast
                                                                        .showToast(
                                                                            "${questionAnswersController.alreadySynedAssessorDocumentsList[index].caption} Deleted");
                                                                  },
                                                                  text:
                                                                      "Delete"),
                                                            ],
                                                          )));
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: AppConstants.appRed,
                                                )),
                                          )
                                        ],
                                      )),
                                ),
                              );
                            }),
                      )
                    : const SizedBox.shrink(),
                SizedBox(height: AppConstants.paddingDefault),
                // CustomElevatedButton(
                //     onTap: () {
                //       if (questionAnswersController.isCameraOpen) {
                //         questionAnswersController.closeCamera();
                //       }
                //       Get.back();
                //     },
                //     text: "Submit"),
                SizedBox(
                  height: AppConstants.paddingExtraLarge,
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
