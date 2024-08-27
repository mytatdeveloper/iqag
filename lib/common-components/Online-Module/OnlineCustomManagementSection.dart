import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomGridCardView.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/Online-Controller/OnlineAssessorDashboardController.dart';
import 'package:mytat/controller/QuestionAnswersController.dart';
import 'package:mytat/controller/SplashController.dart';
import 'package:mytat/model/GridCardModel.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:mytat/view/Assessor-Module/assessor_completed_students_theory_screen.dart';
import 'package:mytat/view/Assessor-Module/student_group_practical_viva_screen.dart';

class OnlineCustomManagementSection extends StatelessWidget {
  final List<GridCardModel> customList;
  final String title;
  final bool isStudenttheory;
  final int crossAxisCount;
  final double height;

  const OnlineCustomManagementSection(
      {super.key,
      required this.customList,
      required this.title,
      this.crossAxisCount = 3,
      this.isStudenttheory = false,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AssessorDashboardController>(
        builder: (assessorDashboardController) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: AppConstants.paddingExtraLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppConstants.titleBold,
            ),
            SizedBox(
              height: AppConstants.paddingSmall / 2,
            ),
            Container(
              width: Get.width * 0.2,
              height: 2,
              color: AppConstants.appPrimary,
            ),
            SizedBox(
              height: AppConstants.paddingExtraLarge,
            ),
            CustomGridCardView(
                height: height,
                isSpacingNeeded: true,
                // customList[0].title != "Start P/V",
                padding: AppConstants.paddingExtraLarge,
                icon: customList[0].icon,
                title: customList[0].title,
                onTilePressed: () async {
                  if (title == "Documents Management") {
                    if (AppConstants.isOnlineMode == true) {
                      await Get.find<QuestionAnswersController>()
                          .getAssessorOnlineSubmittedDocumentsList();
                    }
                    // await Get.find<AssessorDashboardController>()
                    //     .importAssessorDocumentsList(isResetNeeded: true);
                    Get.find<SplashController>().getLocation();
                    // load last documents saved
                    Get.find<QuestionAnswersController>()
                        .loadLastSubmittedCenterDocuments();
                    // load last documents saved
                    await Get.find<QuestionAnswersController>()
                        .getAssessorDocumentsListFromDb();
                    Get.to(customList[0].screeToNavigate);
                  } else if (title == "Practical/Viva Management") {
                    Get.dialog(
                        barrierDismissible: false,
                        Dialog(
                          child: Padding(
                            padding:
                                EdgeInsets.all(AppConstants.paddingDefault),
                            child: Text(
                              "Please Wait....",
                              style: AppConstants.subHeadingBold,
                            ),
                          ),
                        ));
                    await Get.find<AssessorDashboardController>().importBatch(
                        AppConstants.assesmentId.toString(),
                        isResetNeeded: true);
                    await Get.find<OnlineAssessorDashboardController>()
                        .getAllTemporaryQuestionsList();
                    if (assessorDashboardController.fetchingLatestData ==
                        false) {
                      Get.back();
                    }

                    if (Get.find<OnlineAssessorDashboardController>()
                            .tempPQuestionsList
                            .isEmpty &&
                        Get.find<OnlineAssessorDashboardController>()
                            .tempVQuestionsList
                            .isNotEmpty) {
                      Get.find<SplashController>().getLocation();

                      // added line of code for the check icon
                      await Get.find<AssessorDashboardController>()
                          .getOfflineStudentsList();

                      await Get.find<QuestionAnswersController>()
                          .getMarkingOptionsList();

                      Get.find<AssessorDashboardController>()
                          .getAllCompletedDocumentsCandidatesList();
                      Get.find<AssessorDashboardController>()
                          .getAllCompletedPracticalCandidatesList();
                      Get.find<AssessorDashboardController>()
                          .getAllCompletedVivaCandidatesList();

                      // added line of code for the check icon

                      // Added Line of Code if Practical or Viva is not there
                      await Get.find<AssessorDashboardController>()
                          .getOfflineVivaQuestions();
                      await Get.find<AssessorDashboardController>()
                          .getOfflinePracticleQuestions();
                      // Added Line of Code if Practical or Viva is not there
                      Get.to(customList[0].screeToNavigate);
                    } else {
                      Get.dialog(Dialog(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: AppConstants.paddingDefault * 1.5,
                              horizontal: AppConstants.paddingDefault),
                          height: 160,
                          width: Get.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Select - Viva/Practical Type",
                                style: AppConstants.titleBold,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      Get.find<SplashController>()
                                          .getLocation();

                                      // added line of code for the check icon
                                      await Get.find<
                                              AssessorDashboardController>()
                                          .getOfflineStudentsList();

                                      await Get.find<
                                              QuestionAnswersController>()
                                          .getMarkingOptionsList();

                                      Get.find<AssessorDashboardController>()
                                          .getAllCompletedDocumentsCandidatesList();
                                      Get.find<AssessorDashboardController>()
                                          .getAllCompletedPracticalCandidatesList();
                                      Get.find<AssessorDashboardController>()
                                          .getAllCompletedVivaCandidatesList();

                                      // added line of code for the check icon

                                      // Added Line of Code if Practical or Viva is not there
                                      await Get.find<
                                              AssessorDashboardController>()
                                          .getOfflineVivaQuestions();
                                      await Get.find<
                                              AssessorDashboardController>()
                                          .getOfflinePracticleQuestions();
                                      // Added Line of Code if Practical or Viva is not there
                                      Get.back();
                                      Get.to(customList[0].screeToNavigate);
                                    },
                                    child: Container(
                                      width: 140,
                                      height: 80,
                                      padding: EdgeInsets.symmetric(
                                          vertical: AppConstants.paddingSmall),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppConstants.appPrimary),
                                      ),
                                      child: Center(
                                          child: Column(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: AppConstants.appPrimary,
                                            size:
                                                AppConstants.paddingExtraLarge *
                                                    2,
                                          ),
                                          Text(
                                            "Individual P/V",
                                            style: AppConstants.subHeadingBold
                                                .copyWith(
                                              color: AppConstants.appPrimary,
                                            ),
                                          ),
                                        ],
                                      )),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      Get.find<SplashController>()
                                          .getLocation();

                                      // added line of code for the check icon
                                      await Get.find<
                                              AssessorDashboardController>()
                                          .getOfflineStudentsList();
                                      await Get.find<
                                              QuestionAnswersController>()
                                          .getMarkingOptionsList();

                                      Get.find<AssessorDashboardController>()
                                          .getAllCompletedDocumentsCandidatesList();
                                      Get.find<AssessorDashboardController>()
                                          .getAllCompletedPracticalCandidatesList();
                                      Get.find<AssessorDashboardController>()
                                          .getAllCompletedVivaCandidatesList();

                                      // added line of code for the check icon

                                      // Added Line of Code if Practical or Viva is not there
                                      await Get.find<
                                              AssessorDashboardController>()
                                          .getOfflineVivaQuestions();
                                      await Get.find<
                                              AssessorDashboardController>()
                                          .getOfflinePracticleQuestions();
                                      Get.find<AssessorDashboardController>()
                                          .setListType();

                                      if (Get.find<
                                              AssessorDashboardController>()
                                          .pQuestions
                                          .isNotEmpty) {
                                        Get.find<AssessorDashboardController>()
                                            .changeSelectedExamType(Get.find<
                                                    AssessorDashboardController>()
                                                .groupTestType[0]);
                                      }

                                      // Added Line of Code if Practical or Viva is not there
                                      Get.back();
                                      Get.to(
                                          const StudentGroupVivaPracticalListScreen());
                                    },
                                    child: Container(
                                      width: 140,
                                      height: 80,
                                      padding: EdgeInsets.symmetric(
                                          vertical: AppConstants.paddingSmall),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppConstants.appSecondary),
                                      ),
                                      child: Center(
                                          child: Column(
                                        children: [
                                          Icon(
                                            Icons.group,
                                            color: AppConstants.appSecondary,
                                            size:
                                                AppConstants.paddingExtraLarge *
                                                    2,
                                          ),
                                          Text(
                                            "Group Practical",
                                            style: AppConstants.subHeadingBold
                                                .copyWith(
                                              color: AppConstants.appSecondary,
                                            ),
                                          ),
                                        ],
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ));

                      // await Get.find<AssessorDashboardController>()
                      //     .getOfflineStudentsList();
                      // await Get.find<QuestionAnswersController>()
                      //     .getMarkingOptionsList();

                      // Get.find<AssessorDashboardController>()
                      //     .getAllCompletedDocumentsCandidatesList();
                      // Get.find<AssessorDashboardController>()
                      //     .getAllCompletedPracticalCandidatesList();
                      // Get.find<AssessorDashboardController>()
                      //     .getAllCompletedVivaCandidatesList();

                      // // Added Line of Code if Practical or Viva is not there
                      // await Get.find<AssessorDashboardController>()
                      //     .getOfflineVivaQuestions();
                      // await Get.find<AssessorDashboardController>()
                      //     .getOfflinePracticleQuestions();
                      // // Added Line of Code if Practical or Viva is not there

                      // Get.to(customList[0].screeToNavigate);
                    }
                  } else if (title == "Student Theory") {
                    await Get.find<AssessorDashboardController>()
                        .getAllTemporaryQuestionsList();
                    await Get.find<AssessorDashboardController>()
                        .getOnlineAssessmentTakenList(
                            AppConstants.assesmentId ?? "");
                    Get.to(const AllTheoryCompletedStudentsList());
                  }
                })
          ],
        ),
      );
    });
  }
}
