import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:mytat/common-components/CustomCountdownWidget.dart';
import 'package:mytat/common-components/CustomDrawerWidget.dart';
import 'package:mytat/common-components/CustomDropDownMenu.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/common-components/CustomLoadingIndicator.dart';
import 'package:mytat/common-components/CustomMcqQuestionsCardWidget.dart';
import 'package:mytat/common-components/CustomSnackbar.dart';
import 'package:mytat/common-components/CustomToastMessage.dart';
import 'package:mytat/common-components/CustomWarnigDialog.dart';
import 'package:mytat/common-components/tensor-flow-components/camera_view.dart';
import 'package:mytat/controller/Candidate-Side-Controllers/CandidateOnboardingController.dart';
import 'package:mytat/model/StudentsBatchModel.dart';
import 'package:mytat/model/Syncing-Models/CandidateMCQAnswersModel.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:mytat/view/Candidate-Module/candidate_view__answers_summary_screen.dart';
import 'package:mytat/view/Candidate-Module/candidate_view_answer_summary.dart';
import 'package:mytat/view/tensor_flow_screen.dart';

// GlobalKey drawerKey = GlobalKey();

class McqQuestionScreen extends StatelessWidget {
  final Batches candidate;
  final bool isFromSummary;
  final String? timerValue;
  // final McqAnswers? candidateAnswer;

  const McqQuestionScreen(
      {super.key,
      required this.candidate,
      this.isFromSummary = false,
      this.timerValue
      // this.candidateAnswer
      });

  @override
  Widget build(BuildContext context) {
    late final Stream<KioskMode> currentMode = watchKioskMode();

    void handleStop(bool? didStop) {
      if (didStop == false) {
        CustomToast.showToast(
          'Kiosk mode could not be stopped or was not active to begin with.',
        );
      }
    }

    return GetBuilder<CandidateOnboardingController>(
        builder: (candidateOnboardingController) {
      return WillPopScope(
        onWillPop: () async {
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(AppConstants.borderRadiusLarge))),
              title: Text(
                'Submit Assessment',
                style: AppConstants.titleBold,
              ),
              content: Text(
                'You are not allowed to exit the On Going assessment without submitting?',
                style: AppConstants.subHeading,
              ),
              actions: [
                CustomElevatedButton(
                    width: Get.width * 0.8,
                    height: AppConstants.mediumButtonSized,
                    buttonColor: AppConstants.appPrimary,
                    onTap: () {
                      Get.back();
                    },
                    text: "OK"),
              ],
            ),
          );
        },
        child: StreamBuilder(
            stream: currentMode,
            builder: (context, snapshot) {
              return Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: candidateOnboardingController
                            .isLoadingNextQuestion ==
                        true
                    ? Padding(
                        padding: EdgeInsets.only(
                            bottom: AppConstants.paddingDefault),
                        child: const CustomLoadingIndicator(),
                      )
                    : Padding(
                        padding: EdgeInsets.only(
                            bottom: AppConstants.paddingDefault),
                        child: isFromSummary == true
                            ? Visibility(
                                visible: candidateOnboardingController
                                        .isSummaryAnswerChanged ==
                                    true,
                                child: CustomElevatedButton(
                                  width: Get.width * 0.6,
                                  height: 40,
                                  onTap: () async {
                                    Get.dialog(
                                        barrierDismissible: false,
                                        const CustomSuccessDialog(
                                            title: "Saving Answer",
                                            logo: CustomLoadingIndicator()));
                                    await closeTensorFlowCamera();
                                    candidateOnboardingController
                                        .changeIfSummaryAnswerChanged(false);
                                    candidateOnboardingController
                                        .addToCandidateAnswersList(McqAnswers(
                                            answerId:
                                                candidateOnboardingController
                                                    .currentSelectedOption,
                                            questionId:
                                                candidateOnboardingController
                                                        .currentMcqQuestion!
                                                        .id ??
                                                    "",
                                            assessmentId: candidate.assmentId,
                                            markForReview:
                                                candidateOnboardingController
                                                    .markForReview,
                                            candidateId: candidate.id,
                                            // timer value code
                                            answerTime:
                                                candidateOnboardingController
                                                    .formatTime(currentTime)
                                            // timer value code
                                            ));
                                    Get.back();
                                    Get.off(const ViewAnswersSummaryScreen());
                                    // Get.back();
                                  },
                                  text: "Change Answer",
                                  buttonColor: AppConstants.appPrimary,
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    candidateOnboardingController.moveForward ==
                                            "Y"
                                        ? MainAxisAlignment.center
                                        : candidateOnboardingController
                                                    .currentQuestionIndex ==
                                                0
                                            ? MainAxisAlignment.center
                                            : MainAxisAlignment.spaceBetween,
                                // candidateOnboardingController
                                //                     .currentQuestionIndex +
                                //                 1 ==
                                //             1 ||
                                //         candidateOnboardingController.moveForward ==
                                //             "N"
                                //     ? MainAxisAlignment.center
                                //     : MainAxisAlignment.spaceBetween,
                                children: [
                                  Visibility(
                                    visible: candidateOnboardingController
                                                .moveForward ==
                                            "Y"
                                        ? false
                                        : candidateOnboardingController
                                                .currentQuestionIndex !=
                                            0,
                                    child: CustomElevatedButton(
                                      width: Get.width * 0.5,
                                      height: AppConstants.largebuttonSized,
                                      borderRadius:
                                          AppConstants.borderRadiusCircular,
                                      onTap: () {
                                        // if (candidateOnboardingController.moveForward == "N") {
                                        // if (candidateOnboardingController
                                        //         .isAnswerChangedUsingPrevious ==
                                        //     true) {
                                        if (candidateOnboardingController
                                                    .currentSelectedAnswer !=
                                                null &&
                                            candidateOnboardingController
                                                    .isAnswerChanged ==
                                                true) {
                                          candidateOnboardingController.addToCandidateAnswersList(
                                              McqAnswers(
                                                  answerId:
                                                      candidateOnboardingController
                                                          .currentSelectedOption,
                                                  assessmentId:
                                                      candidate.assmentId,
                                                  questionId:
                                                      candidateOnboardingController
                                                              .currentMcqQuestion!
                                                              .id ??
                                                          "",
                                                  markForReview:
                                                      candidateOnboardingController
                                                          .markForReview,
                                                  candidateId: candidate.id,
                                                  // timer value code
                                                  answerTime:
                                                      candidateOnboardingController
                                                          .formatTime(
                                                              currentTime)
                                                  // timer value code
                                                  ));
                                          candidateOnboardingController
                                              .setMarkForReview(0);
                                          candidateOnboardingController
                                              .clearAnswer();
                                          // }
                                        }

                                        candidateOnboardingController
                                            .previousQuestion();
                                        // } else {
                                        //   CustomSnackBar.customSnackBar(
                                        //       true, "You can not go to the question");
                                        // }
                                      },
                                      text: "Previous",
                                      buttonColor: AppConstants.appSecondary,
                                    ),
                                  ),
                                  CustomElevatedButton(
                                    width: Get.width * 0.5,
                                    height: AppConstants.largebuttonSized,
                                    borderRadius:
                                        AppConstants.borderRadiusCircular,
                                    onTap: () async {
                                      candidateOnboardingController
                                                      .currentQuestionIndex +
                                                  1 ==
                                              candidateOnboardingController
                                                  .mcqQuestions.length
                                          ? {
                                              candidateOnboardingController
                                                  .setIsLoadingNextQuestion(
                                                      false),
                                              if (candidateOnboardingController
                                                      .assessmentDurationInformation!
                                                      .mandatoryQuestion ==
                                                  "Y")
                                                {
                                                  if (candidateOnboardingController
                                                          .currentSelectedAnswer !=
                                                      null)
                                                    {
                                                      Get.dialog(
                                                          barrierDismissible:
                                                              false,
                                                          const CustomSuccessDialog(
                                                              title:
                                                                  "Saving Answers",
                                                              logo:
                                                                  CustomLoadingIndicator())),
                                                      await closeTensorFlowCamera(),
                                                      // disabling temporary real time tracking
                                                      // candidateOnboardingController
                                                      //     .disableTemporaryRealTime(
                                                      //         true),
                                                      // adding to the candidate answers list
                                                      candidateOnboardingController.addToCandidateAnswersList(McqAnswers(
                                                          answerId:
                                                              candidateOnboardingController
                                                                  .currentSelectedOption,
                                                          questionId:
                                                              candidateOnboardingController
                                                                      .currentMcqQuestion!
                                                                      .id ??
                                                                  "",
                                                          assessmentId: candidate
                                                              .assmentId,
                                                          markForReview:
                                                              candidateOnboardingController
                                                                  .markForReview,
                                                          candidateId:
                                                              candidate.id,
                                                          answerTime:
                                                              candidateOnboardingController
                                                                  .formatTime(
                                                                      currentTime))),
                                                      candidateOnboardingController
                                                          .clearAnswer(),
                                                      candidateOnboardingController
                                                          .setMarkForReview(0),
                                                      Get.back(),

                                                      Get.off(
                                                          ViewCandidateAnswersSummaryScreen(
                                                        candidate: candidate,
                                                      ))
                                                    }
                                                  else
                                                    {
                                                      CustomSnackBar.customSnackBar(
                                                          false,
                                                          "All Questions are mandatory!")
                                                    }
                                                }
                                              else
                                                {
                                                  Get.dialog(
                                                      barrierDismissible: false,
                                                      const CustomSuccessDialog(
                                                          title:
                                                              "Saving Answers",
                                                          logo:
                                                              CustomLoadingIndicator())),
                                                  await closeTensorFlowCamera(),
                                                  // disabling temporary real time tracking
                                                  // candidateOnboardingController
                                                  //     .disableTemporaryRealTime(true),
                                                  if (candidateOnboardingController
                                                          .currentSelectedAnswer !=
                                                      null)
                                                    {
                                                      candidateOnboardingController.addToCandidateAnswersList(
                                                          McqAnswers(
                                                              assessmentId:
                                                                  candidate
                                                                      .assmentId,
                                                              answerId:
                                                                  candidateOnboardingController
                                                                      .currentSelectedOption,
                                                              markForReview:
                                                                  candidateOnboardingController
                                                                      .markForReview,
                                                              questionId:
                                                                  candidateOnboardingController
                                                                          .currentMcqQuestion!
                                                                          .id ??
                                                                      "",
                                                              candidateId:
                                                                  candidate.id,
                                                              // timer value code
                                                              answerTime:
                                                                  candidateOnboardingController
                                                                      .formatTime(
                                                                          currentTime)
                                                              // timer value code

                                                              )),
                                                    },
                                                  candidateOnboardingController
                                                      .clearAnswer(),
                                                  candidateOnboardingController
                                                      .setMarkForReview(0),
                                                  Get.back(),
                                                  Get.to(
                                                      ViewCandidateAnswersSummaryScreen(
                                                    candidate: candidate,
                                                  ))
                                                },
                                            }
                                          : {
                                              if (candidateOnboardingController
                                                      .assessmentDurationInformation!
                                                      .mandatoryQuestion ==
                                                  "Y")
                                                {
                                                  if (candidateOnboardingController
                                                          .currentSelectedAnswer !=
                                                      null)
                                                    {
                                                      // adding to the candidate answers list
                                                      candidateOnboardingController.addToCandidateAnswersList(
                                                          McqAnswers(
                                                              answerId: candidateOnboardingController
                                                                  .currentSelectedOption,
                                                              questionId:
                                                                  candidateOnboardingController
                                                                          .currentMcqQuestion!
                                                                          .id ??
                                                                      "",
                                                              assessmentId:
                                                                  candidate
                                                                      .assmentId,
                                                              markForReview:
                                                                  candidateOnboardingController
                                                                      .markForReview,
                                                              candidateId:
                                                                  candidate.id,
                                                              // timer value code
                                                              answerTime:
                                                                  candidateOnboardingController
                                                                      .formatTime(
                                                                          currentTime)
                                                              // timer value code
                                                              )),
                                                      candidateOnboardingController
                                                          .setIsLoadingNextQuestion(
                                                              true),
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  300),
                                                          () async {
                                                        await candidateOnboardingController
                                                            .nextQuestion();
                                                        candidateOnboardingController
                                                            .setIsLoadingNextQuestion(
                                                                false);
                                                      }),
                                                      candidateOnboardingController
                                                          .clearAnswer(),
                                                      candidateOnboardingController
                                                          .setMarkForReview(0),
                                                    }
                                                  else
                                                    {
                                                      CustomSnackBar.customSnackBar(
                                                          false,
                                                          "All Questions are mandatory!")
                                                    }
                                                }
                                              else
                                                {
                                                  if (candidateOnboardingController
                                                              .currentSelectedAnswer !=
                                                          null &&
                                                      candidateOnboardingController
                                                              .isAnswerChanged ==
                                                          true)
                                                    {
                                                      candidateOnboardingController.addToCandidateAnswersList(
                                                          McqAnswers(
                                                              answerId: candidateOnboardingController
                                                                  .currentSelectedOption,
                                                              assessmentId:
                                                                  candidate
                                                                      .assmentId,
                                                              questionId:
                                                                  candidateOnboardingController
                                                                          .currentMcqQuestion!
                                                                          .id ??
                                                                      "",
                                                              markForReview:
                                                                  candidateOnboardingController
                                                                      .markForReview,
                                                              candidateId:
                                                                  candidate.id,
                                                              // timer value code
                                                              answerTime:
                                                                  candidateOnboardingController
                                                                      .formatTime(
                                                                          currentTime)
                                                              // timer value code
                                                              )),
                                                      candidateOnboardingController
                                                          .setMarkForReview(0),
                                                      candidateOnboardingController
                                                          .clearAnswer(),
                                                    },
                                                  candidateOnboardingController
                                                      .setIsLoadingNextQuestion(
                                                          true),
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 300),
                                                      () async {
                                                    await candidateOnboardingController
                                                        .nextQuestion();
                                                    candidateOnboardingController
                                                        .setIsLoadingNextQuestion(
                                                            false);
                                                  })
                                                },
                                            };
                                    },
                                    text: candidateOnboardingController
                                                    .currentQuestionIndex +
                                                1 ==
                                            candidateOnboardingController
                                                .mcqQuestions.length
                                        ? "Finish"
                                        : "Next",
                                    buttonColor: AppConstants.appGreen,
                                  ),
                                ],
                              ),
                      ),
                appBar: AppBar(
                  elevation: 0,
                  title: Text(
                      "Assessment: ${candidateOnboardingController.assessmentDurationInformation!.assmentName}"),
                  backgroundColor: AppConstants.appPrimary,
                  leadingWidth: AppConstants.paddingExtraLarge * 2,
                ),
                drawer: const CustomDrawerWidget(),
                body: Padding(
                  padding: EdgeInsets.all(AppConstants.paddingExtraLarge / 2),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (candidateOnboardingController.webProctoring ==
                                "Y")
                              SizedBox(
                                  height: AppConstants.largebuttonSized * 2,
                                  width: AppConstants.largebuttonSized * 2,
                                  child: FaceDetectorView()),
                            SizedBox(
                              width:
                                  candidateOnboardingController.webProctoring ==
                                          "Y"
                                      ? Get.width * 0.62
                                      : Get.width * 0.9,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Time Remaining:",
                                        style: AppConstants.titleBold,
                                        textAlign: TextAlign.center,
                                      ),
                                      CountdownTimerWidget(
                                        isFromSummary: isFromSummary,
                                        candidate: candidate,
                                        timeDuration: Duration(
                                          seconds: isFromSummary == true
                                              ? currentTime.inSeconds
                                              : candidateOnboardingController
                                                  .convertMinutesToSeconds(
                                                      candidateOnboardingController
                                                              .assessmentDurationInformation!
                                                              .testDuration ??
                                                          "60"),
                                        ),
                                        isObservor: candidateOnboardingController
                                                .assessmentDurationInformation!
                                                .tabSwitchesAllowed ??
                                            "N",
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5.5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Current Question:",
                                        style: AppConstants.titleBold,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        " ${candidateOnboardingController.currentQuestionIndex + 1} / ${candidateOnboardingController.mcqQuestions.length}",
                                        style: AppConstants.title
                                            .copyWith(fontSize: 22),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5.5,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.zoom_out,
                                        size: AppConstants.paddingExtraLarge *
                                            1.5,
                                      ),
                                      Expanded(
                                        child: SliderTheme(
                                          data:
                                              SliderTheme.of(context).copyWith(
                                            trackHeight:
                                                4.0, // Adjust track height as needed
                                            thumbColor: Colors.blue,
                                            overlayColor:
                                                Colors.blue.withAlpha(32),
                                            activeTrackColor: Colors.blue,
                                            inactiveTrackColor: Colors.grey,
                                            valueIndicatorColor: Colors.blue,
                                            valueIndicatorTextStyle:
                                                const TextStyle(
                                                    color: Colors.white),
                                            trackShape:
                                                const RectangularSliderTrackShape(),
                                            // Adjust padding here
                                            overlayShape:
                                                const RoundSliderOverlayShape(
                                                    overlayRadius: 0.0),
                                            thumbShape:
                                                const RoundSliderThumbShape(
                                                    enabledThumbRadius: 8.0),
                                          ),
                                          child: Slider(
                                            inactiveColor: AppConstants.appGrey,
                                            activeColor:
                                                AppConstants.appPrimary,
                                            value: candidateOnboardingController
                                                .fontSize,
                                            min: 16.0,
                                            max: 40.0,
                                            divisions:
                                                24, // divisions are optional
                                            onChanged: (fontSize) {
                                              candidateOnboardingController
                                                  .changeFontSize(fontSize);
                                            },
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.zoom_in,
                                        size: AppConstants.paddingExtraLarge *
                                            1.5,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: AppConstants.paddingDefault,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Name - (ID):  ",
                              style: AppConstants.titleBold,
                            ),
                            Expanded(
                              child: Text(
                                "${candidateOnboardingController.currentOngoingCandidate != null ? candidateOnboardingController.currentOngoingCandidate!.name! : ""} - (${candidateOnboardingController.candidateEnrollment})",
                                // "candidate.name.toString()",
                                style: AppConstants.title,
                                textAlign: TextAlign.right,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: AppConstants.paddingSmall,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Mark For Review",
                              style: AppConstants.titleBold,
                              textAlign: TextAlign.center,
                            ),
                            Checkbox(
                                activeColor: AppConstants.appRed,
                                value: (candidateOnboardingController
                                        .markForReview ==
                                    1),
                                onChanged: (value) {
                                  // if (candidateOnboardingController
                                  //         .currentSelectedAnswer !=
                                  //     null) {
                                  candidateOnboardingController.changeAnswer();
                                  if (value == true) {
                                    candidateOnboardingController
                                        .setMarkForReview(1);
                                  } else {
                                    candidateOnboardingController
                                        .setMarkForReview(0);
                                  }
                                  // } else {
                                  //   CustomSnackBar.customSnackBar(
                                  //       false, "Select any option  first");
                                  // }
                                }),
                          ],
                        ),
                        // if (candidateOnboardingController.vernacularLanguage ==
                        //     "Y")
                        if (candidateOnboardingController
                                .availableTheoryPaperLanguageList.length >
                            1)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Select Language:",
                                  style: AppConstants.titleBold),
                              const SizedBox(
                                  height: 35,
                                  width: 180,
                                  child: CustomVernacularDropdownMenu())
                            ],
                          ),
                        // font size
                        SizedBox(
                          height: AppConstants.paddingSmall - 5,
                        ),
                        // if (candidateOnboardingController.vernacularLanguage ==
                        //     "Y")
                        if (candidateOnboardingController
                                .availableTheoryPaperLanguageList.length >
                            1)
                          SizedBox(
                            height: AppConstants.paddingLarge,
                          ),
                        Divider(
                          color: AppConstants.appSecondary,
                          thickness: 2,
                        ),
                        SizedBox(
                          height: AppConstants.paddingExtraLarge,
                        ),
                        Html(
                            style: {
                              "body": Style(
                                  // margin: EdgeInsets.zero,
                                  fontSize: FontSize(
                                      candidateOnboardingController.fontSize),
                                  // fontWeight: FontWeight.normal,
                                  lineHeight: LineHeight.number(1))
                            },
                            data:
                                "Q${candidateOnboardingController.currentQuestionIndex + 1}: ${candidateOnboardingController.currentMcqQuestion!.title}"),
                        if (candidateOnboardingController
                                .selectedVernacularLanguage!.id
                                .toString() !=
                            "-1")
                          Html(
                              style: {
                                "body": Style(
                                    // margin: EdgeInsets.zero,
                                    fontSize: FontSize(
                                        candidateOnboardingController.fontSize),
                                    // fontWeight: FontWeight.normal,
                                    lineHeight: LineHeight.number(1))
                              },
                              data:
                                  "${candidateOnboardingController.getSelectedVernacularLanguageQuestion(candidateOnboardingController.selectedVernacularLanguage!.id.toString(), candidateOnboardingController.currentMcqQuestion!.id.toString()) ?? candidateOnboardingController.currentMcqQuestion!.title}"),
                        if (candidateOnboardingController
                                    .currentMcqQuestion!.titleImg !=
                                "" &&
                            candidateOnboardingController
                                    .currentMcqQuestion!.titleImg !=
                                null)
                          GestureDetector(
                            onTap: () {
                              candidateOnboardingController
                                  .showDefaultDialogUsingData(
                                      AppConstants.base64ToBytes(
                                          candidateOnboardingController
                                              .currentMcqQuestion!.titleImg
                                              .toString()));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: AppConstants.paddingDefault),
                              child: Image.memory(
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.fill,
                                  AppConstants.base64ToBytes(
                                      candidateOnboardingController
                                          .currentMcqQuestion!.titleImg
                                          .toString())),
                            ),
                          ),
                        SizedBox(
                          height: AppConstants.paddingLarge,
                        ),
                        CustomMcqOptionWidget(
                          isFromSummary: isFromSummary,
                          optionList: [
                            candidateOnboardingController
                                .currentMcqQuestion!.option1
                                .toString(),
                            candidateOnboardingController
                                .currentMcqQuestion!.option2
                                .toString(),
                            candidateOnboardingController
                                .currentMcqQuestion!.option3
                                .toString(),
                            candidateOnboardingController
                                .currentMcqQuestion!.option4
                                .toString(),
                            candidateOnboardingController
                                .currentMcqQuestion!.option5
                                .toString(),
                          ],
                          optionImages: [
                            candidateOnboardingController
                                .currentMcqQuestion!.option1Img
                                .toString(),
                            candidateOnboardingController
                                .currentMcqQuestion!.option2Img
                                .toString(),
                            candidateOnboardingController
                                .currentMcqQuestion!.option3Img
                                .toString(),
                            candidateOnboardingController
                                .currentMcqQuestion!.option4Img
                                .toString(),
                            candidateOnboardingController
                                .currentMcqQuestion!.option5Img
                                .toString(),
                          ],
                        ),
                        SizedBox(height: AppConstants.largebuttonSized),
                      ],
                    ),
                  ),
                ),
              );
            }),
      );
    });
  }
}
