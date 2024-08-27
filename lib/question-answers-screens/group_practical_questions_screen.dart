import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomAppBar.dart';
import 'package:mytat/common-components/CustomLoadingIndicator.dart';
import 'package:mytat/common-components/CustomToastMessage.dart';
import 'package:mytat/common-components/CustomWarnigDialog.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/QuestionAnswersController.dart';
import 'package:mytat/model/AssesmentQuestionsModel.dart';
import 'package:mytat/model/QuestionStepMarkingAnswerModel.dart';
import 'package:mytat/model/StudentsBatchModel.dart';
import 'package:mytat/model/Syncing-Models/AssessorQuestionAnswerReplyModel.dart';
import 'package:mytat/services/db_helper.dart';
import 'package:mytat/utilities/AppConstants.dart';

import '../common-components/CustomCameraWidget.dart';

class GroupPracticleQuestionScreen extends StatelessWidget {
  final List<PQuestions> pQuestions;
  final List<Batches> candidates;
  // final int? index;

  const GroupPracticleQuestionScreen({
    super.key,
    required this.pQuestions,
    required this.candidates,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Get.find<QuestionAnswersController>().isRecording == true) {
          CustomToast.showToast("You Can not go back while recording");

          return false;
        } else {
          Get.dialog(CustomWarningDialog(
            title: "Are You Sure want to Exit the Practical?",
            onPress: () async {
              if (Get.find<QuestionAnswersController>().isCameraOpen == true) {
                Get.find<QuestionAnswersController>().closeCamera();
              }
              await Get.find<QuestionAnswersController>()
                  .resetStepsAndMarkings();
              await Get.find<QuestionAnswersController>().clearFile();

              await Get.find<QuestionAnswersController>()
                  .rateStudentMarksByAssessor(null);

              // added line of code
              await Get.find<AssessorDashboardController>()
                  .resetCandidatesGroup(isUpdateNeeded: true);
              if (Get.find<QuestionAnswersController>()
                      .currentPracticleQuestion !=
                  0) {
                Get.find<AssessorDashboardController>()
                    .getAllCompletedPracticalCandidatesList();
                Get.find<QuestionAnswersController>()
                    .resetPracticleQuestion(isCloseCameraNeeded: false);
              }
              // added line of code
              Get.back();
              Get.back();
            },
          ));

          return true;
        }
      },
      child: GetBuilder<QuestionAnswersController>(
          builder: (questionAnswerController) {
        return Scaffold(
            backgroundColor: AppConstants.appBackground,
            appBar: CustomAppBar(
                duration: Duration(
                    seconds: int.parse(pQuestions[questionAnswerController
                                    .currentPracticleQuestion]
                                .questime !=
                            null
                        ? pQuestions[questionAnswerController
                                .currentPracticleQuestion]
                            .questime
                            .toString()
                        : "30")),
                showTimer: true,
                onpressed: () {
                  if (Get.find<QuestionAnswersController>().isRecording ==
                      true) {
                    CustomToast.showToast(
                        "You Can not go back while recording");
                  } else {
                    Get.dialog(CustomWarningDialog(
                      title: "Are You Sure want to Exit the Practical?",
                      onPress: () async {
                        if (Get.find<QuestionAnswersController>()
                                .isCameraOpen ==
                            true) {
                          Get.find<QuestionAnswersController>().closeCamera();
                        }
                        await Get.find<QuestionAnswersController>()
                            .resetStepsAndMarkings();
                        await Get.find<QuestionAnswersController>().clearFile();

                        await Get.find<QuestionAnswersController>()
                            .rateStudentMarksByAssessor(null);

                        // added line of code
                        await Get.find<AssessorDashboardController>()
                            .resetCandidatesGroup(isUpdateNeeded: true);
                        if (Get.find<QuestionAnswersController>()
                                .currentPracticleQuestion !=
                            0) {
                          await Get.find<AssessorDashboardController>()
                              .getAllCompletedPracticalCandidatesList();
                          await Get.find<QuestionAnswersController>()
                              .resetPracticleQuestion(
                                  isCloseCameraNeeded: false);
                        }
                        // added line of code
                        Get.back();
                        Get.back();
                      },
                    ));
                  }
                },
                icon: const Icon(Icons.arrow_back),
                title: "Practical Questions"),
            body: Container(
                height: Get.height,
                width: Get.width,
                decoration: BoxDecoration(
                    color: AppConstants.appPrimary.withOpacity(0.2),
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadiusLarge)),
                margin: EdgeInsets.all(AppConstants.paddingDefault),
                child: Stack(
                  children: [
                    Positioned(
                      top: AppConstants.paddingDefault,
                      left: AppConstants.paddingDefault,
                      right: AppConstants.paddingDefault,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusMedium)),
                        margin: EdgeInsets.only(
                          bottom: AppConstants.paddingDefault + 5,
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingSmall),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Batches?>(
                            isExpanded: true,
                            value: questionAnswerController
                                .selectedGroupOngoingCandidate,
                            hint: const Text('Select Candidate',
                                style: TextStyle()),
                            onChanged: (newValue) async {
                              await questionAnswerController
                                  .setSelectedCandidateFromGroup(newValue);

                              questionAnswerController
                                  .resetStepsAndMarkingsForGroupCandidate();

                              questionAnswerController.updateLastAnswer(
                                questionAnswerController
                                    .selectedGroupOngoingCandidate,
                              );

                              if (questionAnswerController
                                  .groupCandidateAnswersList.isNotEmpty) {
                                questionAnswerController
                                    .setGroupCandidateLastMarking(
                                        questionAnswerController
                                            .selectedGroupOngoingCandidate!);
                              }
                            },
                            items: candidates.map<DropdownMenuItem<Batches?>>(
                                (Batches? value) {
                              return DropdownMenuItem<Batches?>(
                                value: value,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${value!.name}  -  ${value.enrollmentNo}",
                                        style: TextStyle(
                                            color: AppConstants.appPrimary),
                                      ),
                                    ),
                                    if (questionAnswerController
                                            .currentQuestionStepsList.isNotEmpty
                                        ? questionAnswerController
                                                .isCandidateStepMarkingDone(
                                                    value.id.toString()) ==
                                            true
                                        : questionAnswerController
                                            .isCandidateOverAllMarkingDone(
                                                value.id.toString()))
                                      Icon(
                                        Icons.check,
                                        color: AppConstants.appGreen,
                                      ),
                                    // Expanded(
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.end,
                                    //     crossAxisAlignment:
                                    //         CrossAxisAlignment.end,
                                    //     children: [
                                    //       // if (questionAnswerController
                                    //       //         .currentQuestionStepsList
                                    //       //         .isNotEmpty
                                    //       //     ? questionAnswerController
                                    //       //             .isCandidateStepMarkingDone(
                                    //       //                 value!.id
                                    //       //                     .toString()) ==
                                    //       //         true
                                    //       //     : questionAnswerController
                                    //       //         .isCandidateOverAllMarkingDone(
                                    //       //             value!.id.toString()))
                                    //       //   Icon(
                                    //       //     Icons.check,
                                    //       //     color: AppConstants.appGreen,
                                    //       //   ),
                                    //       // SizedBox(
                                    //       //   width: AppConstants.paddingSmall,
                                    //       // ),
                                    //       // SizedBox(
                                    //       //   width: Get.width * 0.25,
                                    //       //   child: Text(
                                    //       //     "value.enrollmentNo!value.enrollmentNo!value.enrollmentNo!value.enrollmentNo!value.enrollmentNo!value.enrollmentNo!",
                                    //       //     maxLines: 2,
                                    //       //     overflow: TextOverflow.ellipsis,
                                    //       //   ),
                                    //       // ),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 80,
                      left: AppConstants.paddingDefault,
                      right: AppConstants.paddingDefault,
                      bottom: AppConstants.paddingExtraLarge * 3,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Html(
                                data:
                                    "Q${questionAnswerController.currentPracticleQuestion + 1} - ${pQuestions[questionAnswerController.currentPracticleQuestion].title}"),
                            const Divider(
                              thickness: 2,
                            ),
                            if (questionAnswerController.isCameraOpen &&
                                questionAnswerController.currentClickedFile ==
                                    null)
                              CameraWidget(
                                  cameraController: questionAnswerController
                                      .cameraController),
                            // added widget
                            if (questionAnswerController.currentClickedFile !=
                                null)
                              Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: Get.height * 0.2,
                                      color: AppConstants.successGreen,
                                    ),
                                    Text(
                                      questionAnswerController
                                          .currentClickedFile
                                          .toString()
                                          .replaceFirst(
                                              AppConstants.replacementPath, ""),
                                      style: AppConstants.body,
                                    )
                                  ],
                                ),
                              ),
                            if (questionAnswerController
                                .currentQuestionStepsList.isEmpty)
                              ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: questionAnswerController
                                    .customRatingOptionsList.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      if (questionAnswerController
                                              .isRecording ==
                                          true) {
                                        CustomToast.showToast(
                                            "Please Stop Recording First");
                                      } else {
                                        questionAnswerController
                                            .rateGroupStudentMarksByAssessor(
                                                isViva: false,
                                                questionAnswerController
                                                        .customRatingOptionsList[
                                                    index],
                                                questionAnswerController
                                                    .selectedGroupOngoingCandidate!,
                                                pQuestions[questionAnswerController
                                                        .currentPracticleQuestion]
                                                    .id
                                                    .toString());
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Transform.scale(
                                          scale: 1.1,
                                          child: Radio<String?>(
                                              splashRadius: 0,
                                              visualDensity:
                                                  const VisualDensity(
                                                horizontal: VisualDensity
                                                    .minimumDensity,
                                              ),
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              value: questionAnswerController
                                                  .customRatingOptionsList[
                                                      index]
                                                  .title,
                                              groupValue: questionAnswerController
                                                          .selectedGroupCandidateMarksByAssessor !=
                                                      null
                                                  ? questionAnswerController
                                                      .selectedGroupCandidateMarksByAssessor!
                                                      .title
                                                  : null,
                                              onChanged: (value) {
                                                if (questionAnswerController
                                                        .isRecording ==
                                                    true) {
                                                  CustomToast.showToast(
                                                      "Please Stop Recording First");
                                                } else {
                                                  questionAnswerController.rateGroupStudentMarksByAssessor(
                                                      isViva: false,
                                                      questionAnswerController
                                                              .customRatingOptionsList[
                                                          index],
                                                      questionAnswerController
                                                          .selectedGroupOngoingCandidate!,
                                                      pQuestions[questionAnswerController
                                                              .currentPracticleQuestion]
                                                          .id
                                                          .toString());
                                                }
                                                // questionAnswerController
                                                //     .rateStudentMarksByAssessor(
                                                //         questionAnswerController
                                                //                 .customRatingOptionsList[
                                                //             index]);
                                              }),
                                        ),
                                        SizedBox(
                                          width: AppConstants.paddingDefault,
                                        ),
                                        Text(questionAnswerController
                                            .customRatingOptionsList[index]
                                            .title
                                            .toString()),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            // step wise marking code
                            if (questionAnswerController
                                .currentQuestionStepsList.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: AppConstants.paddingDefault),
                                    child: Text(
                                      "Current Question Step ${questionAnswerController.currentStepToShow + 1}/${questionAnswerController.currentQuestionStepsList.length}",
                                      style: AppConstants.subHeadingBold,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            AppConstants.borderRadiusSmall)),
                                    padding: EdgeInsets.all(
                                        AppConstants.paddingSmall),
                                    child: Html(
                                        style: {
                                          "body": Style(
                                              padding: EdgeInsets.zero,
                                              margin: EdgeInsets.zero)
                                        },
                                        data:
                                            "Step ${questionAnswerController.currentStepToShow + 1}-  ${questionAnswerController.currentQuestionStepsList[questionAnswerController.currentStepToShow].sTitle.toString()}"),
                                  ),
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: questionAnswerController
                                        .customRatingOptionsList.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          questionAnswerController
                                              .rateStudentStepWiseMarkingByAssessor(
                                                  questionAnswerController
                                                          .customRatingOptionsList[
                                                      index]);
                                          questionAnswerController
                                              .addToStepMarkingList(
                                                  questionAnswerController
                                                      .selectedGroupOngoingCandidate!,
                                                  "p",
                                                  isGroup: true);
                                        },
                                        child: Row(
                                          children: [
                                            Transform.scale(
                                              scale: 1.1,
                                              child: Radio<String?>(
                                                  splashRadius: 0,
                                                  visualDensity:
                                                      const VisualDensity(
                                                    horizontal: VisualDensity
                                                        .minimumDensity,
                                                  ),
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  value: questionAnswerController
                                                      .customRatingOptionsList[
                                                          index]
                                                      .title,
                                                  groupValue: questionAnswerController
                                                              .selectedStepMarksByAssessor !=
                                                          null
                                                      ? questionAnswerController
                                                          .selectedStepMarksByAssessor!
                                                          .title
                                                      : null,
                                                  // value: questionAnswerController
                                                  //         .customRatingOptionsList[
                                                  //     index],
                                                  // groupValue:
                                                  //     questionAnswerController
                                                  //         .selectedStepMarksByAssessor,
                                                  onChanged: (value) {
                                                    questionAnswerController
                                                        .rateStudentStepWiseMarkingByAssessor(
                                                            questionAnswerController
                                                                    .customRatingOptionsList[
                                                                index]);
                                                    questionAnswerController
                                                        .addToStepMarkingList(
                                                            questionAnswerController
                                                                .selectedGroupOngoingCandidate!,
                                                            "p",
                                                            isGroup: true);
                                                  }),
                                            ),
                                            SizedBox(
                                              width:
                                                  AppConstants.paddingDefault,
                                            ),
                                            Text(questionAnswerController
                                                .customRatingOptionsList[index]
                                                .title
                                                .toString()),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Visibility(
                                          visible: questionAnswerController
                                                  .currentStepToShow !=
                                              0,
                                          child: InkWell(
                                            onTap: () {
                                              questionAnswerController
                                                  .loadQuestionPreviousStep(
                                                      questionAnswerController
                                                          .selectedGroupOngoingCandidate,
                                                      isGroup: true);
                                            },
                                            child: Icon(
                                              Icons.arrow_circle_left_sharp,
                                              size: AppConstants
                                                      .paddingExtraLarge *
                                                  2,
                                              color: AppConstants.appPrimary,
                                            ),
                                          )),
                                      Visibility(
                                          visible: questionAnswerController
                                                  .currentStepToShow !=
                                              questionAnswerController
                                                      .currentQuestionStepsList
                                                      .length -
                                                  1,
                                          child: InkWell(
                                            onTap: () async {
                                              questionAnswerController
                                                  .loadQuestionNextStep(
                                                      questionAnswerController
                                                          .selectedGroupOngoingCandidate,
                                                      isGroup: true);
                                            },
                                            child: Icon(
                                              Icons.arrow_circle_right_sharp,
                                              size: AppConstants
                                                      .paddingExtraLarge *
                                                  2,
                                              color: AppConstants.appPrimary,
                                            ),
                                          )),
                                    ],
                                  )
                                ],
                              )
                            // step wise marking code
                          ],
                        ),
                      ),
                    ),
                    questionAnswerController.currentPracticleQuestion <
                            pQuestions.length - 1
                        ? Positioned(
                            bottom: 0,
                            left: AppConstants.paddingDefault,
                            right: AppConstants.paddingDefault,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.4,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                AppConstants.borderRadiusSmall),
                                          ),
                                          primary: questionAnswerController
                                                  .isRecording
                                              ? AppConstants.appRed
                                              : AppConstants.successGreen),
                                      onPressed: () {
                                        if (questionAnswerController
                                            .isRecording) {
                                          if (questionAnswerController
                                              .canStopTheVideo(
                                                  pQuestions: pQuestions)) {
                                            questionAnswerController
                                                .stopRecording(
                                                    isCandidateQuestions: true);
                                            if (questionAnswerController
                                                    .isTimerStart ==
                                                true) {
                                              questionAnswerController
                                                  .cancelTimer();
                                            }
                                          } else {
                                            CustomToast.showToast(
                                                "Please make minimum 1 minute of Video");
                                          }
                                        } else {
                                          Get.find<
                                                  AssessorDashboardController>()
                                              .getCurrentDateTimeModeSpecific();
                                          questionAnswerController
                                              .startRecording(
                                                  isCandidateQuestions: true);
                                          // start timer
                                          questionAnswerController.startTimer(
                                              int.parse(pQuestions[
                                                          questionAnswerController
                                                              .currentPracticleQuestion]
                                                      .questime ??
                                                  "30"));
                                        }
                                      },
                                      child: Text(
                                          style: const TextStyle(),
                                          questionAnswerController.isRecording
                                              ? "Stop Recording"
                                              : "Start Recording")),
                                ),
                                questionAnswerController
                                        .currentQuestionStepsList.isNotEmpty
                                    ? SizedBox(
                                        width: Get.width * 0.4,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(AppConstants
                                                          .borderRadiusSmall),
                                                ),
                                                primary:
                                                    AppConstants.appPrimary),
                                            onPressed: () async {
                                              if (questionAnswerController
                                                      .isRecording !=
                                                  true) {
                                                if (questionAnswerController
                                                        .currentQuestionStepAnswersList
                                                        .length ==
                                                    questionAnswerController
                                                            .currentQuestionStepsList
                                                            .length *
                                                        candidates.length) {
                                                  // remove marking
                                                  await questionAnswerController
                                                      .insertOnlyTotalMarkingOfGroupCandidates(
                                                          candidates,
                                                          pQuestions);
                                                  // remove marking

                                                  questionAnswerController
                                                      .resetGroupCandidateMarks();

                                                  // step wise marking code
                                                  await questionAnswerController
                                                      .insertStepAnswersToDatabase();
                                                  // step wise marking code

                                                  //  stopping timer
                                                  if (questionAnswerController
                                                          .isTimerStart ==
                                                      true) {
                                                    questionAnswerController
                                                        .cancelTimer();
                                                  }
                                                  // loading next question here
                                                  questionAnswerController
                                                      .loadNextPracticleQuestion();

                                                  // step wise marking code
                                                  questionAnswerController
                                                      .resetStepsAndMarkings();
                                                  await questionAnswerController
                                                      .getSpecificQuestionSteps(
                                                          pQuestions[questionAnswerController
                                                                  .currentPracticleQuestion]
                                                              .id
                                                              .toString());
                                                  // step wise marking code
                                                } else {
                                                  CustomToast.showToast(
                                                      "You can not skip the Steps Marking");
                                                }
                                              } else {
                                                CustomToast.showToast(
                                                    "Please, Stop recording first");
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text("Next"),
                                                Icon(
                                                  Icons.navigate_next,
                                                  size: AppConstants
                                                      .fontExtraLarge,
                                                ),
                                              ],
                                            )),
                                      )
                                    : SizedBox(
                                        width: Get.width * 0.4,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(AppConstants
                                                          .borderRadiusSmall),
                                                ),
                                                primary:
                                                    AppConstants.appPrimary),
                                            onPressed: () async {
                                              if (questionAnswerController
                                                      .isRecording !=
                                                  true) {
                                                if (questionAnswerController
                                                        .groupCandidateAnswersList
                                                        .length ==
                                                    candidates.length) {
                                                  await questionAnswerController
                                                      .insertAllGroupCandidateDataToLocalDatabase(
                                                          isViva: false);
                                                  questionAnswerController
                                                      .resetGroupCandidateMarks();

                                                  // step wise marking code
                                                  await questionAnswerController
                                                      .insertStepAnswersToDatabase();
                                                  // step wise marking code

                                                  //  stopping timer
                                                  if (questionAnswerController
                                                          .isTimerStart ==
                                                      true) {
                                                    questionAnswerController
                                                        .cancelTimer();
                                                  }
                                                  // loading next question here
                                                  questionAnswerController
                                                      .loadNextPracticleQuestion();

                                                  // step wise marking code
                                                  questionAnswerController
                                                      .resetStepsAndMarkings();
                                                  await questionAnswerController
                                                      .getSpecificQuestionSteps(
                                                          pQuestions[questionAnswerController
                                                                  .currentPracticleQuestion]
                                                              .id
                                                              .toString());
                                                  // step wise marking code
                                                } else {
                                                  CustomToast.showToast(
                                                      "Please Mark All the Candidates");
                                                }
                                              } else {
                                                CustomToast.showToast(
                                                    "Please, Stop recording first");
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text("Next"),
                                                Icon(
                                                  Icons.navigate_next,
                                                  size: AppConstants
                                                      .fontExtraLarge,
                                                ),
                                              ],
                                            )),
                                      ),
                              ],
                            ),
                          )
                        : Positioned(
                            bottom: 0,
                            left: AppConstants.paddingDefault,
                            right: AppConstants.paddingDefault,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.4,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                AppConstants.borderRadiusSmall),
                                          ),
                                          primary: questionAnswerController
                                                  .isRecording
                                              ? AppConstants.appRed
                                              : AppConstants.successGreen),
                                      onPressed: () {
                                        if (questionAnswerController
                                            .isRecording) {
                                          if (questionAnswerController
                                              .canStopTheVideo(
                                                  pQuestions: pQuestions)) {
                                            questionAnswerController
                                                .stopRecording(
                                                    isCandidateQuestions: true);
                                            if (questionAnswerController
                                                    .isTimerStart ==
                                                true) {
                                              questionAnswerController
                                                  .cancelTimer();
                                            }
                                          } else {
                                            CustomToast.showToast(
                                                "Please make minimum 1 minute of Video");
                                          }
                                        } else {
                                          Get.find<
                                                  AssessorDashboardController>()
                                              .getCurrentDateTimeModeSpecific();
                                          questionAnswerController
                                              .startRecording(
                                                  isCandidateQuestions: true);
                                          // start timer
                                          questionAnswerController.startTimer(
                                              int.parse(pQuestions[
                                                          questionAnswerController
                                                              .currentPracticleQuestion]
                                                      .questime ??
                                                  "30"));
                                        }
                                      },
                                      child: Text(
                                          questionAnswerController.isRecording
                                              ? "Stop Recording"
                                              : "Start Recording")),
                                ),
                                questionAnswerController
                                        .currentQuestionStepsList.isNotEmpty
                                    ? SizedBox(
                                        width: Get.width * 0.4,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(AppConstants
                                                          .borderRadiusSmall),
                                                ),
                                                primary:
                                                    AppConstants.appPrimary),
                                            onPressed: () async {
                                              if (questionAnswerController
                                                      .currentQuestionStepAnswersList
                                                      .length ==
                                                  questionAnswerController
                                                          .currentQuestionStepsList
                                                          .length *
                                                      candidates.length) {
                                                if (questionAnswerController
                                                        .isRecording ==
                                                    true) {
                                                  await questionAnswerController
                                                      .stopRecording(
                                                          isCandidateQuestions:
                                                              true);
                                                }
                                                // remove marking
                                                await questionAnswerController
                                                    .insertOnlyTotalMarkingOfGroupCandidates(
                                                        candidates, pQuestions);
                                                // remove marking
                                                // await questionAnswerController
                                                //     .insertAllGroupCandidateDataToLocalDatabase(
                                                //         isViva: false);
                                                questionAnswerController
                                                    .resetGroupCandidateMarks();
                                                //  stopping timer
                                                if (questionAnswerController
                                                        .isTimerStart ==
                                                    true) {
                                                  questionAnswerController
                                                      .cancelTimer();
                                                }
                                                questionAnswerController
                                                    .closeCamera();
                                                Get.dialog(
                                                    barrierDismissible: false,
                                                    const CustomSuccessDialog(
                                                        title: "Saving Results",
                                                        logo:
                                                            CustomLoadingIndicator()));

                                                questionAnswerController
                                                    .resetGroupCandidateMarks();

                                                questionAnswerController
                                                    .resetPracticleQuestion();

                                                Get.find<
                                                        AssessorDashboardController>()
                                                    .getAllCompletedPracticalCandidatesList();

                                                Get.find<
                                                        AssessorDashboardController>()
                                                    .resetCandidatesGroup();

                                                // step wise marking code
                                                await questionAnswerController
                                                    .insertStepAnswersToDatabase();
                                                // step wise marking code

                                                //  stopping timer
                                                if (questionAnswerController
                                                        .isTimerStart ==
                                                    true) {
                                                  questionAnswerController
                                                      .cancelTimer();
                                                }
                                                for (int i = 0;
                                                    i < candidates.length;
                                                    i++) {
                                                  await questionAnswerController
                                                      .updateCandidatePracticalOrVivaFlag(
                                                          "P", candidates[i]);
                                                }
                                                await Get.find<
                                                        AssessorDashboardController>()
                                                    .getOfflineStudentsList();
                                                // Syncing Documents Practicals and Viva of One Candidate
                                                if (AppConstants.isOnlineMode ==
                                                    true) {
                                                  for (int currentIndex = 0;
                                                      currentIndex <
                                                          candidates.length;
                                                      currentIndex++) {
                                                    List<AssessorQuestionAnswersReplyModel>
                                                        databasePracticalsRecordedInsertedAnswers =
                                                        [];
                                                    databasePracticalsRecordedInsertedAnswers =
                                                        await DatabaseHelper()
                                                            .getCandidatesPracticleAnswers();
                                                    for (var i = 0;
                                                        i <
                                                            databasePracticalsRecordedInsertedAnswers
                                                                .length;
                                                        i++) {
                                                      if (candidates[
                                                                  currentIndex]
                                                              .id ==
                                                          databasePracticalsRecordedInsertedAnswers[
                                                                  i]
                                                              .studentId) {
                                                        await Get.find<
                                                                AssessorDashboardController>()
                                                            .oneCandidatePacticals(
                                                                databasePracticalsRecordedInsertedAnswers[
                                                                    i]);
                                                      }
                                                    }
                                                    // step wise marking code
                                                    List<QuestionStepMarkingAnswerModel>
                                                        tempStepAnswersList =
                                                        [];
                                                    tempStepAnswersList =
                                                        await DatabaseHelper()
                                                            .getAllStepAnswers();
                                                    for (int j = 0;
                                                        j <
                                                            tempStepAnswersList
                                                                .length;
                                                        j++) {
                                                      if (candidates[currentIndex]
                                                                  .id ==
                                                              tempStepAnswersList[
                                                                      j]
                                                                  .candidateId &&
                                                          tempStepAnswersList[j]
                                                                  .answerType ==
                                                              "p") {
                                                        await Get.find<
                                                                AssessorDashboardController>()
                                                            .oneCandidateVivaStepMarksSync(
                                                                tempStepAnswersList[
                                                                    j]);
                                                      }
                                                    }
                                                    // step wise marking code
                                                  }
                                                }
                                                Future.delayed(
                                                    const Duration(seconds: 2),
                                                    () {
                                                  Get.back();
                                                  Get.back();
                                                });
                                                // step wise marking code
                                                questionAnswerController
                                                    .resetStepsAndMarkings();
                                                // step wise marking code
                                              } else {
                                                CustomToast.showToast(
                                                    "Please Mark All the Candidates");
                                              }
                                            },
                                            child:
                                                const Text("Save Practical")),
                                      )
                                    : SizedBox(
                                        width: Get.width * 0.4,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(AppConstants
                                                          .borderRadiusSmall),
                                                ),
                                                primary:
                                                    AppConstants.appPrimary),
                                            onPressed: () async {
                                              if (questionAnswerController
                                                      .groupCandidateAnswersList
                                                      .length ==
                                                  candidates.length) {
                                                if (questionAnswerController
                                                        .isRecording ==
                                                    true) {
                                                  await questionAnswerController
                                                      .stopRecording(
                                                          isCandidateQuestions:
                                                              true);
                                                }
                                                await questionAnswerController
                                                    .insertAllGroupCandidateDataToLocalDatabase(
                                                        isViva: false);
                                                questionAnswerController
                                                    .resetGroupCandidateMarks();
                                                //  stopping timer
                                                if (questionAnswerController
                                                        .isTimerStart ==
                                                    true) {
                                                  questionAnswerController
                                                      .cancelTimer();
                                                }
                                                questionAnswerController
                                                    .closeCamera();
                                                Get.dialog(
                                                    barrierDismissible: false,
                                                    const CustomSuccessDialog(
                                                        title: "Saving Results",
                                                        logo:
                                                            CustomLoadingIndicator()));

                                                questionAnswerController
                                                    .resetGroupCandidateMarks();

                                                questionAnswerController
                                                    .resetPracticleQuestion();

                                                Get.find<
                                                        AssessorDashboardController>()
                                                    .getAllCompletedPracticalCandidatesList();

                                                Get.find<
                                                        AssessorDashboardController>()
                                                    .resetCandidatesGroup();

                                                // step wise marking code
                                                await questionAnswerController
                                                    .insertStepAnswersToDatabase();
                                                // step wise marking code

                                                //  stopping timer
                                                if (questionAnswerController
                                                        .isTimerStart ==
                                                    true) {
                                                  questionAnswerController
                                                      .cancelTimer();
                                                }
                                                for (int i = 0;
                                                    i < candidates.length;
                                                    i++) {
                                                  await questionAnswerController
                                                      .updateCandidatePracticalOrVivaFlag(
                                                          "P", candidates[i]);
                                                }
                                                await Get.find<
                                                        AssessorDashboardController>()
                                                    .getOfflineStudentsList();
                                                // Syncing Documents Practicals and Viva of One Candidate
                                                if (AppConstants.isOnlineMode ==
                                                    true) {
                                                  for (int currentIndex = 0;
                                                      currentIndex <
                                                          candidates.length;
                                                      currentIndex++) {
                                                    List<AssessorQuestionAnswersReplyModel>
                                                        databasePracticalsRecordedInsertedAnswers =
                                                        [];
                                                    databasePracticalsRecordedInsertedAnswers =
                                                        await DatabaseHelper()
                                                            .getCandidatesPracticleAnswers();
                                                    for (var i = 0;
                                                        i <
                                                            databasePracticalsRecordedInsertedAnswers
                                                                .length;
                                                        i++) {
                                                      if (candidates[
                                                                  currentIndex]
                                                              .id ==
                                                          databasePracticalsRecordedInsertedAnswers[
                                                                  i]
                                                              .studentId) {
                                                        await Get.find<
                                                                AssessorDashboardController>()
                                                            .oneCandidatePacticals(
                                                                databasePracticalsRecordedInsertedAnswers[
                                                                    i]);
                                                      }
                                                    }
                                                    // step wise marking code
                                                    List<QuestionStepMarkingAnswerModel>
                                                        tempStepAnswersList =
                                                        [];
                                                    tempStepAnswersList =
                                                        await DatabaseHelper()
                                                            .getAllStepAnswers();
                                                    for (int j = 0;
                                                        j <
                                                            tempStepAnswersList
                                                                .length;
                                                        j++) {
                                                      if (candidates[currentIndex]
                                                                  .id ==
                                                              tempStepAnswersList[
                                                                      j]
                                                                  .candidateId &&
                                                          tempStepAnswersList[j]
                                                                  .answerType ==
                                                              "p") {
                                                        await Get.find<
                                                                AssessorDashboardController>()
                                                            .oneCandidateVivaStepMarksSync(
                                                                tempStepAnswersList[
                                                                    j]);
                                                      }
                                                    }
                                                    // step wise marking code
                                                  }
                                                }
                                                Future.delayed(
                                                    const Duration(seconds: 2),
                                                    () {
                                                  Get.back();
                                                  Get.back();
                                                });
                                                // step wise marking code
                                                questionAnswerController
                                                    .resetStepsAndMarkings();
                                                // step wise marking code
                                              } else {
                                                CustomToast.showToast(
                                                    "Please Mark All the Candidates");
                                              }
                                            },
                                            child:
                                                const Text("Save Practical")),
                                      ),
                              ],
                            ),
                          )
                  ],
                )));
      }),
    );
  }
}
