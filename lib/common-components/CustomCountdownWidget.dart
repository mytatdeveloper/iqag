// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:mytat/common-components/CustomLoadingIndicator.dart';
import 'package:mytat/common-components/CustomSnackbar.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/Candidate-Side-Controllers/CandidateOnboardingController.dart';
import 'package:mytat/model/StudentsBatchModel.dart';
import 'package:mytat/services/db_helper.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:mytat/view/Authorization/login_type_screen.dart';
import 'package:mytat/view/candidate_feedback_form.dart';
import 'package:mytat/view/user_mode_screen.dart';

import 'tensor-flow-components/camera_view.dart';

late Timer _timer;
Duration currentTime = const Duration();

class CountdownTimerWidget extends StatefulWidget {
  final Duration timeDuration;
  final Batches candidate;
  final String? isObservor;
  final bool isFromSummary;

  // final bool? isFromSummary;

  const CountdownTimerWidget(
      {super.key,
      required this.timeDuration,
      required this.candidate,
      this.isObservor,
      required this.isFromSummary

      // this.isFromSummary
      });

  @override
  _CountdownTimerWidgetState createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  @override
  void initState() {
    super.initState();
    print("Time Duration Recieved here: ${widget.timeDuration}");
    _startTimer();
  }

  void _startTimer() {
    if (widget.isFromSummary) {
      _timer.cancel();
    }
    currentTime = widget.timeDuration;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (currentTime.inSeconds > 0) {
          currentTime = currentTime - const Duration(seconds: 1);
        } else {
          _timer.cancel();
          _showTimeUpDialog();
          Future.delayed(const Duration(seconds: 2), () async {
            if (await Get.find<CandidateOnboardingController>()
                .syncAnswerToLocalDB()) {
              Get.find<CandidateOnboardingController>().resetQuestionPaper();
              // exam date time code
              Get.find<CandidateOnboardingController>().setCandidateEndTime(
                  AppConstants.getFormatedCurrentTime(DateTime.now()));
              await Get.find<CandidateOnboardingController>()
                  .saveCandidateDateTimeToLocalDB(widget.candidate);
              // exam date time code
              // saving student to the database
              await Get.find<CandidateOnboardingController>()
                  .saveStudentDB(widget.candidate);
              // syncing the screenshots captured
              await Get.find<CandidateOnboardingController>()
                  .syncCandidatesScreenshotsToDB();
              print(
                  "TOTAL CLICKED PHOTOS: ===============> ${Get.find<CandidateOnboardingController>().clickedPhotosList.length}");

              // clear the answers of the variables
              Get.find<CandidateOnboardingController>().clearAnswer();

              CustomSnackBar.customSnackBar(true,
                  "${widget.candidate.name} record submitted successfully!");

              // Getting completed MCQ Candidates List
              Get.find<AssessorDashboardController>()
                  .getAllCompletedStudentsMcqList();
              // camera closing

              if (Get.find<CandidateOnboardingController>().webProctoring ==
                  "Y") {
                // observor code
                if (Get.find<CandidateOnboardingController>()
                        .assessmentDurationInformation!
                        .tabSwitchesAllowed ==
                    "Y") {
                  stopKioskMode();
                  Get.find<CandidateOnboardingController>().removeObservor();
                }
                // observor code
                print("INSIDE WEB PROCTORING CONDITION: ===============>");
                stopCaptureTimer();
                await stopLiveFeed();
              }

              // Feedback Code
              await Get.find<CandidateOnboardingController>()
                  .getAllFeedbackQuestions();

              if (Get.find<CandidateOnboardingController>()
                  .feedbackQuestionsList
                  .isNotEmpty) {
                Get.offAll(CandidateFeedbackForm(
                  candidateId: widget.candidate.id.toString(),
                  assessmentId: widget.candidate.assmentId.toString(),
                  candidate: widget.candidate,
                  isObservorNeeded: Get.find<CandidateOnboardingController>()
                          .assessmentDurationInformation!
                          .tabSwitchesAllowed ??
                      "N",
                ));
              } else {
                if (AppConstants.isOnlineMode == true) {
                  await Get.find<AssessorDashboardController>().syncMcqOneByOne(
                      widget.candidate, 0,
                      isDocumentLinkNeeded: false);
                  await DatabaseHelper().clearDatabase();
                  // Get.find<AuthController>().logOutUser();
                }

                Get.offAll(AppConstants.isOnlineMode == true
                    ? const UserModeScreen()
                    : const LoginTypeScreen(
                        isOnline: false,
                        isFromStudentLogout: true,
                      ));
              }
              Get.find<CandidateOnboardingController>()
                  .clearBaseDurationVariables();
              Get.find<CandidateOnboardingController>()
                  .clearCandidateDocuments();

              // Feedback Code
            } else {
              CustomSnackBar.customSnackBar(
                  false, "Failed to Submit the record");
            }
          });
        }
      });
    });
  }

  String _formatTime(Duration duration) {
    String hours = (duration.inHours).toString().padLeft(2, '0');
    String minutes = ((duration.inMinutes % 60)).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    if (int.parse(hours) > 0) {
      return "$hours:$minutes:$seconds";
    } else {
      return "$minutes:$seconds";
    }
  }

  void _showTimeUpDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: GetBuilder<CandidateOnboardingController>(
              builder: (candidateOnboardingController) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadiusLarge)),
              title: Text(
                'Time Over!',
                style: AppConstants.titleBold,
              ),
              content: Text(
                'Your Time is Over! Please wait....',
                style: AppConstants.subHeading,
              ),
              actions: [
                candidateOnboardingController.isUploading == true &&
                        AppConstants.isOnlineMode == true
                    ? const Center(child: CustomLoadingIndicator())
                    : const SizedBox.shrink()
              ],
            );
          }),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatTime(currentTime),
      style: AppConstants.title.copyWith(fontSize: 22),
    );
  }
}
