import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:mytat/common-components/CustomAppBar.dart';
import 'package:mytat/common-components/CustomCountdownWidget.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/common-components/CustomLoadingIndicator.dart';
import 'package:mytat/common-components/CustomSnackbar.dart';
import 'package:mytat/common-components/tensor-flow-components/camera_view.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/Candidate-Side-Controllers/CandidateOnboardingController.dart';
import 'package:mytat/model/StudentsBatchModel.dart';
import 'package:mytat/services/db_helper.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:mytat/view/Authorization/login_type_screen.dart';
import 'package:mytat/view/Candidate-Module/candidate_view_answer_summary.dart';
import 'package:mytat/view/candidate_feedback_form.dart';
import 'package:mytat/view/tensor_flow_screen.dart';
import 'package:mytat/view/user_mode_screen.dart';

class ViewCandidateAnswersSummaryScreen extends StatelessWidget {
  final Batches candidate;
  final int? index;

  const ViewCandidateAnswersSummaryScreen({
    super.key,
    required this.candidate,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          // icon: const Icon(Icons.arrow_back),
          // onpressed: () {
          //   Get.back();
          // },
          title:
              "Assessment: ${Get.find<CandidateOnboardingController>().assessmentDurationInformation!.assmentName}"),
      body: GetBuilder<CandidateOnboardingController>(
          builder: (candidateOnboardingController) {
        return WillPopScope(
          onWillPop: () async {
            CustomSnackBar.customSnackBar(true,
                "You can not go back to previous screen. yoo can change the answer from the summary",
                isLong: true);
            // candidateOnboardingController.loadCandidateAnswer();
            return false;
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // if (candidateOnboardingController.webProctoring == "Y" &&
              //     candidateOnboardingController.isUploading != true)
              //   SizedBox(
              //       height: AppConstants.largebuttonSized * 3,
              //       width: AppConstants.largebuttonSized * 3,
              //       child: FaceDetectorView()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Time Remaining:  ",
                    style: AppConstants.titleBold,
                  ),
                  CountdownTimerWidget(
                    isFromSummary: true,
                    candidate: candidate,
                    timeDuration: Duration(seconds: currentTime.inSeconds),
                    isObservor: candidateOnboardingController
                            .assessmentDurationInformation!
                            .tabSwitchesAllowed ??
                        "N",
                  ),
                ],
              ),
              SizedBox(
                height: AppConstants.paddingExtraLarge,
              ),
              if (candidateOnboardingController.isUploading != true)
                Center(
                  child: CustomElevatedButton(
                    borderRadius: AppConstants.borderRadiusCircular,
                    width: Get.width * 0.8,
                    height: AppConstants.largebuttonSized,
                    onTap: () {
                      Get.to(const ViewAnswersSummaryScreen());
                    },
                    text: "View Summary",
                    buttonColor: AppConstants.appGreen,
                  ),
                ),
              // if (candidateOnboardingController.isUploading != true &&
              //     AppConstants.isOnlineMode != true)
              SizedBox(
                height: AppConstants.paddingExtraLarge,
              ),

              if (candidateOnboardingController.isUploading == true)
                SizedBox(
                  height: AppConstants.paddingExtraLarge,
                ),
              if (candidateOnboardingController.isUploading == true)
                Center(
                  child: Text(
                    "Please Wait....",
                    style: AppConstants.subHeadingBold,
                  ),
                ),
              candidateOnboardingController.isUploading == true &&
                      AppConstants.isOnlineMode == true
                  ? const Center(child: CustomLoadingIndicator())
                  : Center(
                      child: CustomElevatedButton(
                          borderRadius: AppConstants.borderRadiusCircular,
                          width: Get.width * 0.6,
                          height: AppConstants.largebuttonSized,
                          onTap: () async {
                            if (candidateOnboardingController
                                    .assessmentDurationInformation!
                                    .appointedTime ==
                                "Y") {
                              if (int.parse(candidateOnboardingController
                                          .assessmentDurationInformation!
                                          .testDuration
                                          .toString()) -
                                      int.parse(
                                          currentTime.inMinutes.toString()) >
                                  int.parse(candidateOnboardingController
                                      .assessmentDurationInformation!
                                      .appointedTimeDuration
                                      .toString())) {
                                if (await candidateOnboardingController
                                    .syncAnswerToLocalDB()) {
                                  // camera closing
                                  if (candidateOnboardingController
                                          .webProctoring ==
                                      "Y") {
                                    print(
                                        "INSIDE WEB PROCTORING CONDITION: ===============>");
                                    stopCaptureTimer();
                                    await stopLiveFeed();
                                  }

                                  candidateOnboardingController
                                      .resetQuestionPaper();
                                  // exam date time code
                                  candidateOnboardingController
                                      .setCandidateEndTime(
                                          AppConstants.getFormatedCurrentTime(
                                              DateTime.now()));
                                  await candidateOnboardingController
                                      .saveCandidateDateTimeToLocalDB(
                                          candidate);
                                  // exam date time code
                                  // saving student to the database
                                  await candidateOnboardingController
                                      .saveStudentDB(candidate);
                                  // syncing the screenshots captured
                                  await candidateOnboardingController
                                      .syncCandidatesScreenshotsToDB();
                                  print(
                                      "TOTAL CLICKED PHOTOS: ===============> ${candidateOnboardingController.clickedPhotosList.length}");

                                  // clear the answers of the variables
                                  candidateOnboardingController.clearAnswer();

                                  CustomSnackBar.customSnackBar(true,
                                      "${candidate.name} record submitted successfully!");

                                  // Getting completed MCQ Candidates List
                                  Get.find<AssessorDashboardController>()
                                      .getAllCompletedStudentsMcqList();
                                  // Feedback Code
                                  await candidateOnboardingController
                                      .getAllFeedbackQuestions();

                                  if (candidateOnboardingController
                                      .feedbackQuestionsList.isNotEmpty) {
                                    Get.offAll(CandidateFeedbackForm(
                                      candidateId: candidate.id.toString(),
                                      assessmentId:
                                          candidate.assmentId.toString(),
                                      candidate: candidate,
                                      isObservorNeeded:
                                          candidateOnboardingController
                                                  .assessmentDurationInformation!
                                                  .tabSwitchesAllowed ??
                                              "N",
                                    ));
                                  } else {
                                    if (AppConstants.isOnlineMode == true) {
                                      await Get.find<
                                              AssessorDashboardController>()
                                          .syncMcqOneByOne(candidate, 0,
                                              isDocumentLinkNeeded: false);
                                      await DatabaseHelper().clearDatabase();
                                    }
                                    // observor code
                                    // if (candidateOnboardingController
                                    //         .assessmentDurationInformation!
                                    //         .tabSwitchesAllowed ==
                                    //     "Y") {
                                    stopKioskMode();
                                    candidateOnboardingController
                                        .removeObservor();
                                    // }
                                    // observor code
                                    Get.offAll(AppConstants.isOnlineMode == true
                                        ? const UserModeScreen()
                                        : const LoginTypeScreen(
                                            isOnline: false,
                                            isFromStudentLogout: true,
                                          ));
                                  }

                                  candidateOnboardingController
                                      .clearBaseDurationVariables();
                                  candidateOnboardingController
                                      .clearCandidateDocuments();
                                  // Feedback Code
                                } else {
                                  CustomSnackBar.customSnackBar(
                                      false, "Failed to Submit the record");
                                }
                              } else {
                                CustomSnackBar.customSnackBar(false,
                                    "You can not submit the assessment Before ${candidateOnboardingController.assessmentDurationInformation!.appointedTimeDuration} minutes");
                              }
                            } else {
                              if (await candidateOnboardingController
                                  .syncAnswerToLocalDB()) {
                                // camera closing
                                if (candidateOnboardingController
                                        .webProctoring ==
                                    "Y") {
                                  print(
                                      "INSIDE WEB PROCTORING CONDITION: ===============>");
                                  stopCaptureTimer();
                                  await stopLiveFeed();
                                }
                                // camera closing

                                candidateOnboardingController
                                    .resetQuestionPaper();
                                // exam date time code
                                candidateOnboardingController
                                    .setCandidateEndTime(
                                        AppConstants.getFormatedCurrentTime(
                                            DateTime.now()));
                                await candidateOnboardingController
                                    .saveCandidateDateTimeToLocalDB(candidate);
                                // exam date time code
                                // saving student to the database
                                await candidateOnboardingController
                                    .saveStudentDB(candidate);
                                // syncing the screenshots captured
                                await candidateOnboardingController
                                    .syncCandidatesScreenshotsToDB();
                                print(
                                    "TOTAL CLICKED PHOTOS: ===============> ${candidateOnboardingController.clickedPhotosList.length}");

                                // clear the answers of the variables
                                candidateOnboardingController.clearAnswer();

                                CustomSnackBar.customSnackBar(true,
                                    "${candidate.name} record submitted successfully!");

                                // Getting completed MCQ Candidates List
                                Get.find<AssessorDashboardController>()
                                    .getAllCompletedStudentsMcqList();

                                // Feedback Code
                                await candidateOnboardingController
                                    .getAllFeedbackQuestions();
                                if (candidateOnboardingController
                                    .feedbackQuestionsList.isNotEmpty) {
                                  Get.offAll(CandidateFeedbackForm(
                                    candidateId: candidate.id.toString(),
                                    assessmentId:
                                        candidate.assmentId.toString(),
                                    candidate: candidate,
                                    isObservorNeeded:
                                        candidateOnboardingController
                                                .assessmentDurationInformation!
                                                .tabSwitchesAllowed ??
                                            "N",
                                  ));
                                } else {
                                  if (AppConstants.isOnlineMode == true) {
                                    await Get.find<
                                            AssessorDashboardController>()
                                        .syncMcqOneByOne(candidate, 0,
                                            isDocumentLinkNeeded: false);
                                    await DatabaseHelper().clearDatabase();
                                    // Get.find<AuthController>().logOutUser();
                                  }
                                  // observor code
                                  // if (candidateOnboardingController
                                  //         .assessmentDurationInformation!
                                  //         .tabSwitchesAllowed ==
                                  //     "Y") {
                                  stopKioskMode();
                                  candidateOnboardingController
                                      .removeObservor();
                                  // }
                                  // observor code
                                  Get.offAll(AppConstants.isOnlineMode == true
                                      ? const UserModeScreen()
                                      : const LoginTypeScreen(
                                          isOnline: false,
                                          isFromStudentLogout: true,
                                        ));
                                }
                                candidateOnboardingController
                                    .clearBaseDurationVariables();
                                candidateOnboardingController
                                    .clearCandidateDocuments();
                                // Feedback Code
                              } else {
                                CustomSnackBar.customSnackBar(
                                    false, "Failed to Submit the record");
                              }
                            }
                            if (candidateOnboardingController.screenshare ==
                                "N") {
                              // restricting the screen shots on start
                              WidgetsBinding.instance
                                  .addPostFrameCallback((timeStamp) async {
                                if (Platform.isAndroid == true) {
                                  await FlutterWindowManager.clearFlags(
                                      FlutterWindowManager.FLAG_SECURE);
                                }
                              });
                              // restricting the screen shots on start
                            }
                          },
                          text: "Submit"),
                    )
            ],
          ),
        );
      }),
    );
  }
}
