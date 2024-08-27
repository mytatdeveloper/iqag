import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomGridCardView.dart';
import 'package:mytat/common-components/CustomSnackbar.dart';
import 'package:mytat/common-components/CustomWarnigDialog.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/Candidate-Side-Controllers/CandidateOnboardingController.dart';
import 'package:mytat/controller/Online-Controller/OnlineAssessorDashboardController.dart';
import 'package:mytat/controller/QuestionAnswersController.dart';
import 'package:mytat/controller/SplashController.dart';
import 'package:mytat/model/CandidateSubmitDocumentsModel.dart';
import 'package:mytat/model/GridCardModel.dart';
import 'package:mytat/model/StudentsBatchModel.dart';
import 'package:mytat/model/Syncing-Models/AssessorAnnexureListUploadModel.dart';
import 'package:mytat/model/Syncing-Models/CandidateMCQAnswersModel.dart';
import 'package:mytat/model/Syncing-Models/CandidateScreenshotUploadModel.dart';
import 'package:mytat/services/db_helper.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:mytat/view/Assessor-Module/assessor_dashboard_screen.dart';
import 'package:mytat/view/Assessor-Module/student_group_practical_viva_screen.dart';
import 'package:mytat/view/Authorization/login_type_screen.dart';
import 'package:mytat/view/completed_student_viva_and_practical_screen.dart';

import '../view/completed_student_theory_screen.dart';

class CustomManagementSection extends StatelessWidget {
  final List<GridCardModel> customList;
  final String title;
  final bool isStudenttheory;
  final int crossAxisCount;
  const CustomManagementSection(
      {super.key,
      required this.customList,
      required this.title,
      this.crossAxisCount = 3,
      this.isStudenttheory = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppConstants.paddingExtraLarge),
      child: Column(
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
          GridView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: customList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: Get.width * 0.30,
                  crossAxisSpacing: 10,
                  crossAxisCount: crossAxisCount),
              itemBuilder: (context, index) => CustomGridCardView(
                  icon: customList[index].icon,
                  isSpacingNeeded: true,
                  title: customList[index].title,
                  onTilePressed: () async {
                    if (title == "Documents Management") {
                      // for documents section -->
                      if (index == 0) {
                        Get.find<SplashController>().getLocation();

                        // load last documents saved
                        Get.find<QuestionAnswersController>()
                            .loadLastSubmittedCenterDocuments();
                        // load last documents saved

                        Get.find<QuestionAnswersController>()
                            .getAssessorDocumentsListFromDb();
                        Get.to(customList[index].screeToNavigate);
                      } else if (index == 1) {
                        if (await AppConstants.checkInternetConnection() ==
                            true) {
                          Get.dialog(CustomWarningDialog(
                            onPress: () async {
                              Get.back();
                              Get.to(customList[index].screeToNavigate);
                              await Get.find<QuestionAnswersController>()
                                  .deleteAssessorUploadedDocumentsOffline();

                              DatabaseHelper dbHelper = DatabaseHelper();
                              List<AssessorAnnexurelistUploadModel>
                                  assessorAnnexureDocumentsList =
                                  await dbHelper.getAllAnnexureDocumentsData();

                              if (assessorAnnexureDocumentsList.isNotEmpty) {
                                await Get.find<AssessorDashboardController>()
                                    .syncAssessorAnnexureDocumentsToServer();
                              }
                              await Get.find<QuestionAnswersController>()
                                  .getCenterDocumentsFromSharedPreferences();
                              if (await Get.find<AssessorDashboardController>()
                                  .syncAssessorDataToServer(AppConstants
                                      .assessorDocumentsUploadModel)) {
                                CustomSnackBar.customSnackBar(true,
                                    "Yeah, Documents Management Data Synced Successfully");
                                Get.offAll(const AssessorDashboardScreen());
                              } else {
                                CustomSnackBar.customSnackBar(false,
                                    "Ops, Documents Management Data Syncing Failed may be some document is missing",
                                    isLong: true);
                                Get.offAll(const AssessorDashboardScreen());
                              }
                            },
                            bottomSpacing: AppConstants.paddingDefault,
                            title:
                                "You Should have a strong and stable internet connection to sync the data, Press OK if you are connected to a strong network",
                          ));
                        }
                      } else {
                        CustomSnackBar.customSnackBar(
                            true, "Please Wait, Feature Coming Soon....");
                      }
                    } else if (title == "Practical/Viva Management") {
                      if (index == 0) {
                        if (Get.find<AssessorDashboardController>()
                                .tempPQuestionsList
                                .isEmpty &&
                            Get.find<AssessorDashboardController>()
                                .tempVQuestionsList
                                .isNotEmpty) {
                          // added line of code for the check icon
                          Get.find<SplashController>().getLocation();

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
                          Get.to(customList[index].screeToNavigate);
                        } else {
                          Get.dialog(Dialog(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: AppConstants.paddingDefault * 1.5,
                                  horizontal: AppConstants.paddingDefault),
                              height: 160,
                              width: Get.width,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          // added line of code for the check icon
                                          Get.find<SplashController>()
                                              .getLocation();

                                          await Get.find<
                                                  AssessorDashboardController>()
                                              .getOfflineStudentsList();

                                          await Get.find<
                                                  QuestionAnswersController>()
                                              .getMarkingOptionsList();

                                          Get.find<
                                                  AssessorDashboardController>()
                                              .getAllCompletedDocumentsCandidatesList();
                                          Get.find<
                                                  AssessorDashboardController>()
                                              .getAllCompletedPracticalCandidatesList();
                                          Get.find<
                                                  AssessorDashboardController>()
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
                                          Get.to(customList[index]
                                              .screeToNavigate);
                                        },
                                        child: Container(
                                          width: 140,
                                          height: 80,
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                                  AppConstants.paddingSmall),
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
                                                size: AppConstants
                                                        .paddingExtraLarge *
                                                    2,
                                              ),
                                              Text(
                                                "Individual P/V",
                                                style: AppConstants
                                                    .subHeadingBold
                                                    .copyWith(
                                                  color:
                                                      AppConstants.appPrimary,
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

                                          Get.find<
                                                  AssessorDashboardController>()
                                              .getAllCompletedDocumentsCandidatesList();
                                          Get.find<
                                                  AssessorDashboardController>()
                                              .getAllCompletedPracticalCandidatesList();
                                          Get.find<
                                                  AssessorDashboardController>()
                                              .getAllCompletedVivaCandidatesList();

                                          // added line of code for the check icon

                                          // Added Line of Code if Practical or Viva is not there
                                          await Get.find<
                                                  AssessorDashboardController>()
                                              .getOfflineVivaQuestions();
                                          await Get.find<
                                                  AssessorDashboardController>()
                                              .getOfflinePracticleQuestions();
                                          Get.find<
                                                  AssessorDashboardController>()
                                              .setListType();
                                          if (Get.find<
                                                  AssessorDashboardController>()
                                              .pQuestions
                                              .isNotEmpty) {
                                            Get.find<
                                                    AssessorDashboardController>()
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
                                              vertical:
                                                  AppConstants.paddingSmall),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color:
                                                    AppConstants.appSecondary),
                                          ),
                                          child: Center(
                                              child: Column(
                                            children: [
                                              Icon(
                                                Icons.group,
                                                color:
                                                    AppConstants.appSecondary,
                                                size: AppConstants
                                                        .paddingExtraLarge *
                                                    2,
                                              ),
                                              Text(
                                                "Group Practical",
                                                style: AppConstants
                                                    .subHeadingBold
                                                    .copyWith(
                                                  color:
                                                      AppConstants.appSecondary,
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ));
                        }
                      } else if (index == 1) {
                        if (await AppConstants.checkInternetConnection() ==
                            true) {
                          await Get.find<CandidateOnboardingController>()
                              .getAllInsertedPracticalAndVivaAnswers();
                          await Get.find<CandidateOnboardingController>()
                              .getTotalPracticalAndVivaAnswersSynced();
                          await Get.find<CandidateOnboardingController>()
                              .getAllCandidatesList();

                          Get.to(
                              const CompletedCandidateVivaAndPracticalStudentListScreen());
                        }

                        // await Get.find<AssessorDashboardController>()
                        //     .getOfflineStudentsList();
                        // Get.find<AssessorDashboardController>()
                        //     .getAllCompletedDocumentsCandidatesList();
                        // Get.find<AssessorDashboardController>()
                        //     .getAllCompletedPracticalCandidatesList();
                        // Get.find<AssessorDashboardController>()
                        //     .getAllCompletedVivaCandidatesList();
                        // await Get.find<AssessorDashboardController>()
                        //     .getTheCompletedVivaVerificationList();

                        // Get.to(const AllVivaCompletedStudentsList());
                      } else if (index == 2) {
                        // condition for syncing all data of the candidates
                        if (await AppConstants.checkInternetConnection() ==
                            true) {
                          Get.dialog(CustomWarningDialog(
                            onPress: () async {
                              Get.back();
                              Get.to(customList[index].screeToNavigate);
                              // added line of code for already synced candidates list
                              await Get.find<AssessorDashboardController>()
                                  .getOnlyPVSyncedCandidatesList();
                              // added line of code for already synced candidates list

                              await Get.find<AssessorDashboardController>()
                                  .syncStudentDocuments();
                              await Get.find<AssessorDashboardController>()
                                  .syncVivaAnswersOfCandidates();
                              await Get.find<AssessorDashboardController>()
                                  .syncPracticleAnswersOfCandidates();

                              // time api
                              await Get.find<AssessorDashboardController>()
                                  .syncAllCandidatesFinalTime();
                              // time api

                              // step wise marking code
                              await Get.find<AssessorDashboardController>()
                                  .syncPracticleAndVivaStepAnswersOfCandidates();
                              // step wise marking code

                              // Get.back();
                              // Added Line of Code one by one
                              await Get.find<CandidateOnboardingController>()
                                  .getAllInsertedPracticalAndVivaAnswers();
                              await Get.find<CandidateOnboardingController>()
                                  .getTotalPracticalAndVivaAnswersSynced();
                              await Get.find<CandidateOnboardingController>()
                                  .getAllCandidatesList();

                              Get.off(
                                  const CompletedCandidateVivaAndPracticalStudentListScreen());
                              // Added Line of Code one by one
                            },
                            bottomSpacing: AppConstants.paddingDefault,
                            title:
                                "You Should have a strong and stable internet connection to sync the data, Press OK if you are connected to a strong network",
                          ));
                        }
                      }
                    } else {
                      if (index == 0) {
                        if (await AppConstants.checkInternetConnection() ==
                            true) {
                          await Get.find<CandidateOnboardingController>()
                              .getAllInsertedMcqAnswers();
                          await Get.find<CandidateOnboardingController>()
                              .getTotalMcqAnswersSynced();
                          await Get.find<CandidateOnboardingController>()
                              .getAllCandidatesList();

                          Get.to(const CompletedCandidateStudentListScreen());
                        }

                        // await Get.find<AssessorDashboardController>()
                        //     .getAllCompletedStudentsMcqList();
                        // await Get.find<AssessorDashboardController>()
                        //     .getTheMcqVerificationList();
                        // Get.to(customList[index].screeToNavigate);
                      } else if (index == 1) {
                        if (await AppConstants.checkInternetConnection() ==
                            true) {
                          // delete existing data code
                          Get.to(customList[index].screeToNavigate);
                          // code for checking already synced candidates data
                          await Get.find<CandidateOnboardingController>()
                              .getOnlySyncedCandidatesList();
                          // code for checking already synced candidates data
                          List<Batches> tempAllCompletedMcqBatch =
                              await DatabaseHelper()
                                  .getAllCompletedMcqStudents();
                          if (tempAllCompletedMcqBatch.isNotEmpty) {
                            await Get.find<CandidateOnboardingController>()
                                .deleteAllExistingRecordOfCandidates();
                          }
                          // delete existing data code

                          // Candidate List Syncing Process
                          List<CandidateSubmitDocumentsModel> temporaryList =
                              await DatabaseHelper()
                                  .getCandidatesSubmittedDocuments();
                          if (temporaryList.isNotEmpty) {
                            await Get.find<CandidateOnboardingController>()
                                .syncStudentSubmittedDocuments();
                          }
                          // Candidate List Syncing Process
                          List<McqAnswers> allStudentsMcqAnswers =
                              await DatabaseHelper()
                                  .getAllCandidatesMcqAnswers();
                          if (allStudentsMcqAnswers.isNotEmpty) {
                            await Get.find<CandidateOnboardingController>()
                                .syncMcqAnswersOfCandidates();
                          }
                          // Candidate List Syncing Process
                          List<Batches> allCompletedMcqBatch =
                              await DatabaseHelper()
                                  .getAllCompletedMcqStudents();
                          if (allCompletedMcqBatch.isNotEmpty) {
                            await Get.find<CandidateOnboardingController>()
                                .syncCompletedMcqStudents();
                          }
                          // Candidate Screenshots Syncing Process
                          List<CandidateScreenshotUploadModel>
                              allCandidatesScreenshots =
                              await DatabaseHelper().getCandidateScreenshots();
                          if (allCandidatesScreenshots.isNotEmpty) {
                            await Get.find<CandidateOnboardingController>()
                                .syncCompletedMcqStudentsScreenshots();
                          }
                          // feedback code
                          await Get.find<CandidateOnboardingController>()
                              .syncAllCandidateFeedback(
                                  AppConstants.assesmentId.toString());
                          // feedback code
                          // Added Line of Code one by one
                          await Get.find<CandidateOnboardingController>()
                              .getAllInsertedMcqAnswers();
                          await Get.find<CandidateOnboardingController>()
                              .getTotalMcqAnswersSynced();
                          await Get.find<CandidateOnboardingController>()
                              .getAllCandidatesList();

                          Get.off(const CompletedCandidateStudentListScreen());
                          // Added Line of Code one by one
                        }

                        // Get.back();
                      } else if (index == 2) {
                        Get.offAll(const LoginTypeScreen(
                          isOnline: false,
                          isFromStudentLogout: true,
                        ));
                      }
                    }
                  }))
        ],
      ),
    );
  }
}
