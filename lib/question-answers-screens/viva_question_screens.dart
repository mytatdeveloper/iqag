import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomAppBar.dart';
import 'package:mytat/common-components/CustomCameraWidget.dart';
import 'package:mytat/common-components/CustomLoadingIndicator.dart';
import 'package:mytat/common-components/CustomToastMessage.dart';
import 'package:mytat/common-components/CustomWarnigDialog.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/QuestionAnswersController.dart';
import 'package:mytat/model/AssesmentQuestionsModel.dart';
import 'package:mytat/model/Syncing-Models/AssessorQuestionAnswerReplyModel.dart';
import 'package:mytat/model/VivaPracticalMarkingModel.dart';
import 'package:mytat/utilities/AppConstants.dart';

import '../model/StudentsBatchModel.dart';

class VivaQuestionScreen extends StatelessWidget {
  final List<VQuestions> vQuestions;
  final Batches candidate;
  final int? index;
  const VivaQuestionScreen(
      {super.key,
      required this.vQuestions,
      required this.candidate,
      this.index});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Get.find<QuestionAnswersController>().isRecording == true) {
          CustomToast.showToast("You Can not go back while recording");

          return false;
        } else {
          Get.dialog(CustomWarningDialog(
            title: "Are You Sure want to Exit the Viva?",
            onPress: () async {
              await Get.find<QuestionAnswersController>()
                  .resetStepsAndMarkings();
              await Get.find<QuestionAnswersController>().clearFile();

              await Get.find<QuestionAnswersController>()
                  .rateStudentMarksByAssessor(null);

              // added line of code
              if (Get.find<QuestionAnswersController>().currentVivaQuestion !=
                  0) {
                await Get.find<AssessorDashboardController>()
                    .getAllCompletedVivaCandidatesList();

                await Get.find<QuestionAnswersController>()
                    .resetVivaQuestion(isCloseCameraNeeded: false);
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
                    seconds: int.parse(
                        vQuestions[questionAnswerController.currentVivaQuestion]
                                    .questime !=
                                null
                            ? vQuestions[questionAnswerController
                                    .currentVivaQuestion]
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
                      title: "Are You Sure want to Exit the Viva?",
                      onPress: () async {
                        await Get.find<QuestionAnswersController>()
                            .resetStepsAndMarkings();
                        await Get.find<QuestionAnswersController>().clearFile();

                        await Get.find<QuestionAnswersController>()
                            .rateStudentMarksByAssessor(null);

                        // added line of code
                        if (Get.find<QuestionAnswersController>()
                                .currentVivaQuestion !=
                            0) {
                          await Get.find<AssessorDashboardController>()
                              .getAllCompletedVivaCandidatesList();
                          await Get.find<QuestionAnswersController>()
                              .resetVivaQuestion(isCloseCameraNeeded: false);
                        }
                        // added line of code

                        Get.back();
                        Get.back();
                      },
                    ));
                  }
                },
                icon: const Icon(Icons.arrow_back),
                title: "Viva Questions"),
            body: Container(
                // padding: EdgeInsets.all(AppConstants.paddingDefault),
                height: Get.height,
                width: Get.width,
                decoration: BoxDecoration(
                    color: AppConstants.appPrimary.withOpacity(0.2),
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadiusLarge)),
                margin: EdgeInsets.all(AppConstants.paddingDefault),
                child: Stack(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Positioned(
                      top: AppConstants.paddingDefault,
                      left: AppConstants.paddingDefault,
                      right: AppConstants.paddingDefault,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingDefault),
                        width: Get.width,
                        height: 60,
                        margin: EdgeInsets.only(
                            bottom: AppConstants.paddingDefault),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusSmall)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Candidate Name: ",
                                  style: AppConstants.subHeadingBold,
                                ),
                                Text(
                                  candidate.name.toString(),
                                  style: AppConstants.subHeading,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: AppConstants.paddingSmall / 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Roll Number: ",
                                  style: AppConstants.subHeadingBold,
                                ),
                                Text(
                                  candidate.enrollmentNo.toString(),
                                  style: AppConstants.subHeading,
                                ),
                              ],
                            ),
                          ],
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: AppConstants.paddingDefault,
                            ),
                            Html(
                                data:
                                    "Q${questionAnswerController.currentVivaQuestion + 1} - ${vQuestions[questionAnswerController.currentVivaQuestion].title}"),
                            const Divider(
                              thickness: 2,
                            ),
                            if (questionAnswerController.isCameraOpen &&
                                questionAnswerController.currentClickedFile ==
                                    null)
                              CameraWidget(
                                  cameraController: questionAnswerController
                                      .cameraController),
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
                            // remove overall
                            if (questionAnswerController
                                .currentQuestionStepsList.isEmpty)
                              // remove overall
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                primary: false,
                                itemCount: questionAnswerController
                                    .customRatingOptionsList.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      questionAnswerController
                                          .rateStudentMarksByAssessor(
                                              questionAnswerController
                                                      .customRatingOptionsList[
                                                  index]);
                                    },
                                    child: Row(
                                      children: [
                                        Transform.scale(
                                          scale: 1.1,
                                          child: Radio<
                                                  VivaPracticalMarkingModel>(
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
                                                  index],
                                              groupValue:
                                                  questionAnswerController
                                                      .selectedMarksByAssessor,
                                              onChanged: (value) {
                                                questionAnswerController
                                                    .rateStudentMarksByAssessor(
                                                        questionAnswerController
                                                                .customRatingOptionsList[
                                                            index]);
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
                                                  candidate, "v");
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
                                                  onChanged: (value) {
                                                    questionAnswerController
                                                        .rateStudentStepWiseMarkingByAssessor(
                                                            questionAnswerController
                                                                    .customRatingOptionsList[
                                                                index]);
                                                    questionAnswerController
                                                        .addToStepMarkingList(
                                                            candidate, "v");
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
                                                      candidate);
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
                                                      candidate);
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
                    questionAnswerController.currentVivaQuestion <
                            vQuestions.length - 1
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
                                                  vQuestions: vQuestions)) {
                                            questionAnswerController
                                                .stopRecording(
                                                    isCandidateQuestions: true);
                                            questionAnswerController
                                                .cancelTimer();
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
                                              int.parse(vQuestions[
                                                          questionAnswerController
                                                              .currentVivaQuestion]
                                                      .questime ??
                                                  "30"));
                                        }
                                        ;
                                      },
                                      child: Text(
                                          questionAnswerController.isRecording
                                              ? "Stop Recording"
                                              : "Start Recording")),
                                ),
                                // remove overall
                                questionAnswerController
                                        .currentQuestionStepsList.isNotEmpty
                                    // remove overall
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
                                                        .length) {
                                                  if (questionAnswerController
                                                          .isRecording ==
                                                      true) {
                                                    await questionAnswerController
                                                        .stopRecording(
                                                            isCandidateQuestions:
                                                                true);
                                                  }
                                                  // Inserting to the local database
                                                  await questionAnswerController
                                                      .insertCandidatesVivaAnswersToDb(
                                                          AssessorQuestionAnswersReplyModel(
                                                    lat:
                                                        "${AppConstants.latitude}, ${AppConstants.longitude}",
                                                    long: AppConstants
                                                        .locationInformation,
                                                    timeTaken:
                                                        "${Get.find<AssessorDashboardController>().currentPracticalVivaTime!.date}, ${Get.find<AssessorDashboardController>().currentPracticalVivaTime!.time}",
                                                    // lat:
                                                    //     "${AppConstants.latitude}, ${AppConstants.longitude}",
                                                    // long: AppConstants
                                                    //     .locationInformation,
                                                    // timeTaken: "2:30",
                                                    assesmentId: int.parse(
                                                        AppConstants.assesmentId
                                                            .toString()),
                                                    assesorMarks:
                                                        questionAnswerController
                                                            .getTotalStepRating()
                                                            .toString(),
                                                    marksTitle: "",
                                                    assessorId:
                                                        AppConstants.assessorId,
                                                    questionId: vQuestions[
                                                            questionAnswerController
                                                                .currentVivaQuestion]
                                                        .id,
                                                    videoUrl:
                                                        questionAnswerController
                                                            .currentClickedFile,
                                                    studentId: candidate.id,
                                                    // exam date time code
                                                    vDate: Get.find<
                                                            QuestionAnswersController>()
                                                        .candidateVivaStartDate,
                                                    vEndTime: AppConstants
                                                        .getFormatedCurrentTime(
                                                            DateTime.now()),
                                                    vStartTime: Get.find<
                                                            QuestionAnswersController>()
                                                        .candidateVivaStartTime,
                                                    pDate: 'null',
                                                    pEndTime: 'null',
                                                    pStartTime: 'null',
                                                    // exam date time code
                                                  ));
                                                  //  stopping timer

                                                  // step wise marking code
                                                  await questionAnswerController
                                                      .insertStepAnswersToDatabase();
                                                  // step wise marking code

                                                  if (questionAnswerController
                                                          .isTimerStart ==
                                                      true) {
                                                    questionAnswerController
                                                        .cancelTimer();
                                                  }
                                                  // loading next question here
                                                  questionAnswerController
                                                      .loadNextVivaQuestion();
                                                  // step wise marking code
                                                  questionAnswerController
                                                      .resetStepsAndMarkings();
                                                  await questionAnswerController
                                                      .getSpecificQuestionSteps(
                                                          vQuestions[questionAnswerController
                                                                  .currentVivaQuestion]
                                                              .id
                                                              .toString());
                                                  // step wise marking code
                                                } else {
                                                  CustomToast.showToast(
                                                      "You can not skip the Steps Marking");
                                                }
                                              } else {
                                                CustomToast.showToast(
                                                    "You can not skip the Marking");
                                              }
                                              // }
                                              // else {
                                              //   CustomToast.showToast(
                                              //       "Please, Stop recording first");
                                              // }
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
                                                        .selectedMarksByAssessor !=
                                                    null) {
                                                  if (questionAnswerController
                                                          .currentQuestionStepAnswersList
                                                          .length ==
                                                      questionAnswerController
                                                          .currentQuestionStepsList
                                                          .length) {
                                                    if (questionAnswerController
                                                            .isRecording ==
                                                        true) {
                                                      await questionAnswerController
                                                          .stopRecording(
                                                              isCandidateQuestions:
                                                                  true);
                                                    }
                                                    // Inserting to the local database
                                                    await questionAnswerController
                                                        .insertCandidatesVivaAnswersToDb(
                                                            AssessorQuestionAnswersReplyModel(
                                                      lat:
                                                          "${AppConstants.latitude}, ${AppConstants.longitude}",
                                                      long: AppConstants
                                                          .locationInformation,
                                                      timeTaken:
                                                          "${Get.find<AssessorDashboardController>().currentPracticalVivaTime!.date}, ${Get.find<AssessorDashboardController>().currentPracticalVivaTime!.time}",
                                                      // lat:
                                                      //     "${AppConstants.latitude}, ${AppConstants.longitude}",
                                                      // long: AppConstants
                                                      //     .locationInformation,
                                                      // timeTaken: "2:30",
                                                      assesmentId: int.parse(
                                                          AppConstants
                                                              .assesmentId
                                                              .toString()),
                                                      assesorMarks: double.parse(
                                                              questionAnswerController
                                                                      .selectedMarksByAssessor!
                                                                      .marks ??
                                                                  "0")
                                                          .toString(),
                                                      // questionAnswerController
                                                      //     .selectedMarksByAssessor!
                                                      //     .marks
                                                      //     .toString(),
                                                      marksTitle:
                                                          questionAnswerController
                                                              .selectedMarksByAssessor!
                                                              .title
                                                              .toString(),
                                                      assessorId: AppConstants
                                                          .assessorId,
                                                      questionId: vQuestions[
                                                              questionAnswerController
                                                                  .currentVivaQuestion]
                                                          .id,
                                                      videoUrl:
                                                          questionAnswerController
                                                              .currentClickedFile,
                                                      studentId: candidate.id,
                                                      // exam date time code
                                                      vDate: Get.find<
                                                              QuestionAnswersController>()
                                                          .candidateVivaStartDate,
                                                      vEndTime: AppConstants
                                                          .getFormatedCurrentTime(
                                                              DateTime.now()),
                                                      vStartTime: Get.find<
                                                              QuestionAnswersController>()
                                                          .candidateVivaStartTime,
                                                      pDate: 'null',
                                                      pEndTime: 'null',
                                                      pStartTime: 'null',
                                                      // exam date time code
                                                    ));
                                                    //  stopping timer

                                                    // step wise marking code
                                                    await questionAnswerController
                                                        .insertStepAnswersToDatabase();
                                                    // step wise marking code

                                                    if (questionAnswerController
                                                            .isTimerStart ==
                                                        true) {
                                                      questionAnswerController
                                                          .cancelTimer();
                                                    }
                                                    // loading next question here
                                                    questionAnswerController
                                                        .loadNextVivaQuestion();
                                                    // step wise marking code
                                                    questionAnswerController
                                                        .resetStepsAndMarkings();
                                                    await questionAnswerController
                                                        .getSpecificQuestionSteps(
                                                            vQuestions[questionAnswerController
                                                                    .currentVivaQuestion]
                                                                .id
                                                                .toString());
                                                    // step wise marking code
                                                  } else {
                                                    CustomToast.showToast(
                                                        "You can not skip the Steps Marking");
                                                  }
                                                } else {
                                                  CustomToast.showToast(
                                                      "You can not skip the Marking");
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
                                                  vQuestions: vQuestions)) {
                                            questionAnswerController
                                                .stopRecording(
                                                    isCandidateQuestions: true);
                                            questionAnswerController
                                                .cancelTimer();
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
                                              int.parse(vQuestions[
                                                          questionAnswerController
                                                              .currentVivaQuestion]
                                                      .questime ??
                                                  "30"));
                                        }
                                        ;
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
                                                      .length) {
                                                if (questionAnswerController
                                                        .isRecording ==
                                                    true) {
                                                  await questionAnswerController
                                                      .stopRecording(
                                                          isCandidateQuestions:
                                                              true);
                                                }

                                                await questionAnswerController
                                                    .insertCandidatesVivaAnswersToDb(
                                                        AssessorQuestionAnswersReplyModel(
                                                  lat:
                                                      "${AppConstants.latitude}, ${AppConstants.longitude}",
                                                  long: AppConstants
                                                      .locationInformation,
                                                  timeTaken:
                                                      "${Get.find<AssessorDashboardController>().currentPracticalVivaTime!.date}, ${Get.find<AssessorDashboardController>().currentPracticalVivaTime!.time}",
                                                  assesmentId: int.parse(
                                                      AppConstants.assesmentId
                                                          .toString()),
                                                  assesorMarks:
                                                      questionAnswerController
                                                          .getTotalStepRating()
                                                          .toString(),
                                                  marksTitle: "",
                                                  assessorId:
                                                      AppConstants.assessorId,
                                                  questionId: vQuestions[
                                                          questionAnswerController
                                                              .currentVivaQuestion]
                                                      .id,
                                                  videoUrl:
                                                      questionAnswerController
                                                          .currentClickedFile,
                                                  studentId: candidate.id,
                                                  // exam date time code
                                                  vDate: Get.find<
                                                          QuestionAnswersController>()
                                                      .candidateVivaStartDate,
                                                  vEndTime: AppConstants
                                                      .getFormatedCurrentTime(
                                                          DateTime.now()),
                                                  vStartTime: Get.find<
                                                          QuestionAnswersController>()
                                                      .candidateVivaStartTime,
                                                  pDate: 'null',
                                                  pEndTime: 'null',
                                                  pStartTime: 'null',
                                                  // exam date time code
                                                ));

                                                // step wise marking code
                                                await questionAnswerController
                                                    .insertStepAnswersToDatabase();
                                                // step wise marking code

                                                questionAnswerController
                                                    .closeCamera();
                                                Get.dialog(
                                                    barrierDismissible: false,
                                                    const CustomSuccessDialog(
                                                        title: "Saving Results",
                                                        logo:
                                                            CustomLoadingIndicator()));
                                                // questionAnswerController
                                                //     .rateStudentMarks(null);
                                                questionAnswerController
                                                    .rateStudentMarksByAssessor(
                                                        null);
                                                questionAnswerController
                                                    .resetVivaQuestion();
                                                Get.find<
                                                        AssessorDashboardController>()
                                                    .getAllCompletedVivaCandidatesList();
                                                //  stopping timer
                                                if (questionAnswerController
                                                        .isTimerStart ==
                                                    true) {
                                                  questionAnswerController
                                                      .cancelTimer();
                                                }
                                                questionAnswerController
                                                    .updateCandidatePracticalOrVivaFlag(
                                                        "V", candidate);
                                                await Get.find<
                                                        AssessorDashboardController>()
                                                    .getOfflineStudentsList();
                                                // Syncing Documents Practicals and Viva of One Candidate
                                                if (AppConstants.isOnlineMode ==
                                                    true) {
                                                  await Get.find<
                                                          AssessorDashboardController>()
                                                      .syncVivaAndPracicalOneByOne(
                                                          candidate,
                                                          index ?? 0);
                                                }
                                                Future.delayed(
                                                    const Duration(seconds: 2),
                                                    () {
                                                  Get.back();
                                                  Get.back();

                                                  // step wise marking code
                                                  questionAnswerController
                                                      .resetStepsAndMarkings();
                                                  // step wise marking code
                                                });
                                              } else {
                                                CustomToast.showToast(
                                                    "You can not skip the Steps Marking");
                                              }
                                              // Added Line Of Code for Syncing Options Hit -->
                                            },
                                            child: const Text("Save Viva")),
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
                                                      .selectedMarksByAssessor !=
                                                  null) {
                                                if (questionAnswerController
                                                        .currentQuestionStepAnswersList
                                                        .length ==
                                                    questionAnswerController
                                                        .currentQuestionStepsList
                                                        .length) {
                                                  if (questionAnswerController
                                                          .isRecording ==
                                                      true) {
                                                    await questionAnswerController
                                                        .stopRecording(
                                                            isCandidateQuestions:
                                                                true);
                                                  }

                                                  await questionAnswerController
                                                      .insertCandidatesVivaAnswersToDb(
                                                          AssessorQuestionAnswersReplyModel(
                                                    lat:
                                                        "${AppConstants.latitude}, ${AppConstants.longitude}",
                                                    long: AppConstants
                                                        .locationInformation,
                                                    timeTaken:
                                                        "${Get.find<AssessorDashboardController>().currentPracticalVivaTime!.date}, ${Get.find<AssessorDashboardController>().currentPracticalVivaTime!.time}",

                                                    assesmentId: int.parse(
                                                        AppConstants.assesmentId
                                                            .toString()),
                                                    assesorMarks: double.parse(
                                                            questionAnswerController
                                                                    .selectedMarksByAssessor!
                                                                    .marks ??
                                                                "0")
                                                        .toString(),
                                                    // questionAnswerController
                                                    //     .selectedMarksByAssessor!
                                                    //     .marks
                                                    //     .toString(),
                                                    marksTitle:
                                                        questionAnswerController
                                                            .selectedMarksByAssessor!
                                                            .title
                                                            .toString(),
                                                    assessorId:
                                                        AppConstants.assessorId,
                                                    questionId: vQuestions[
                                                            questionAnswerController
                                                                .currentVivaQuestion]
                                                        .id,
                                                    videoUrl:
                                                        questionAnswerController
                                                            .currentClickedFile,
                                                    studentId: candidate.id,
                                                    // exam date time code
                                                    vDate: Get.find<
                                                            QuestionAnswersController>()
                                                        .candidateVivaStartDate,
                                                    vEndTime: AppConstants
                                                        .getFormatedCurrentTime(
                                                            DateTime.now()),
                                                    vStartTime: Get.find<
                                                            QuestionAnswersController>()
                                                        .candidateVivaStartTime,
                                                    pDate: 'null',
                                                    pEndTime: 'null',
                                                    pStartTime: 'null',
                                                    // exam date time code
                                                  ));

                                                  // step wise marking code
                                                  await questionAnswerController
                                                      .insertStepAnswersToDatabase();
                                                  // step wise marking code

                                                  questionAnswerController
                                                      .closeCamera();
                                                  Get.dialog(
                                                      barrierDismissible: false,
                                                      const CustomSuccessDialog(
                                                          title:
                                                              "Saving Results",
                                                          logo:
                                                              CustomLoadingIndicator()));
                                                  // questionAnswerController
                                                  //     .rateStudentMarks(null);
                                                  questionAnswerController
                                                      .rateStudentMarksByAssessor(
                                                          null);
                                                  questionAnswerController
                                                      .resetVivaQuestion();
                                                  Get.find<
                                                          AssessorDashboardController>()
                                                      .getAllCompletedVivaCandidatesList();
                                                  //  stopping timer
                                                  if (questionAnswerController
                                                          .isTimerStart ==
                                                      true) {
                                                    questionAnswerController
                                                        .cancelTimer();
                                                  }
                                                  questionAnswerController
                                                      .updateCandidatePracticalOrVivaFlag(
                                                          "V", candidate);
                                                  await Get.find<
                                                          AssessorDashboardController>()
                                                      .getOfflineStudentsList();
                                                  // Syncing Documents Practicals and Viva of One Candidate
                                                  if (AppConstants
                                                          .isOnlineMode ==
                                                      true) {
                                                    await Get.find<
                                                            AssessorDashboardController>()
                                                        .syncVivaAndPracicalOneByOne(
                                                            candidate,
                                                            index ?? 0);
                                                  }
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 2), () {
                                                    Get.back();
                                                    Get.back();

                                                    // step wise marking code
                                                    questionAnswerController
                                                        .resetStepsAndMarkings();
                                                    // step wise marking code
                                                  });
                                                } else {
                                                  CustomToast.showToast(
                                                      "You can not skip the Steps Marking");
                                                }
                                              } else {
                                                CustomToast.showToast(
                                                    "You can not skip the Marking");
                                              }
                                              // Added Line Of Code for Syncing Options Hit -->
                                            },
                                            child: const Text("Save Viva")),
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
