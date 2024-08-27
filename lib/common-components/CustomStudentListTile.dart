import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomToastMessage.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/QuestionAnswersController.dart';
import 'package:mytat/model/StudentsBatchModel.dart';
import 'package:mytat/question-answers-screens/practicel_question_screens.dart';
import 'package:mytat/question-answers-screens/viva_question_screens.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:mytat/view/Assessor-Module/assessor_document_upload.dart';

class CustomStudentListTile extends StatelessWidget {
  final Batches candidate;
  final bool? isVivaCompleted;
  final bool? isPracticleCompleted;
  final bool? isDocumentationCompleted;
  final int? index;

  const CustomStudentListTile(
      {super.key,
      this.isDocumentationCompleted,
      this.isPracticleCompleted,
      this.isVivaCompleted,
      required this.candidate,
      this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AssessorDashboardController>(
        builder: (assessorDashboardController) {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: AppConstants.paddingExtraLarge,
            vertical: AppConstants.fontSmall),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.borderRadiusLarge)),
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: Get.width * 0.6,
                              child: Text(
                                "${index! + 1}) Name: ${candidate.name ?? ""}",
                                style: AppConstants.titleBold,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.6,
                              child: Text(
                                "ID: ${candidate.enrollmentNo ?? ""}",
                                style: AppConstants.titleBold,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        isDocumentationCompleted == true
                            ? SizedBox(
                                height: 50,
                                width: 40,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      left: 0,
                                      bottom: 0,
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: AppConstants.successGreen,
                                        size: AppConstants.fontExtraLarge * 1.5,
                                      ),
                                    ),
                                    Positioned(
                                      top: -3,
                                      right: -5,
                                      child: Icon(
                                        Icons.check,
                                        color: AppConstants.successGreen,
                                        size: AppConstants.fontExtraLarge * 1.5,
                                      ),
                                    ),
                                  ],
                                ))
                            // Icon(
                            //     Icons.check,
                            //     color: AppConstants.successGreen,
                            //     size: AppConstants.fontExtraLarge * 2,
                            //   )
                            : InkWell(
                                onTap: () {
                                  Get.to(AssessorDocumentUploadScreen(
                                    candidate: candidate,
                                    docsList: [],
                                  ));
                                },
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: AppConstants.paddingExtraLarge * 2,
                                  color: AppConstants.appGrey,
                                ),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: AppConstants.paddingDefault,
                    ),
                    Row(
                      mainAxisAlignment: assessorDashboardController
                                  .pQuestions.isNotEmpty &&
                              assessorDashboardController.vQuestions.isNotEmpty
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible:
                              assessorDashboardController.vQuestions.isNotEmpty,
                          child: InkWell(
                            onTap: () async {
                              if (isVivaCompleted == false) {
                                // if (isVivaCompleted == false) {
                                //   if (isDocumentationCompleted == true) {
                                await Get.find<QuestionAnswersController>()
                                    .initializeCamera(null);
                                Get.find<QuestionAnswersController>()
                                    .openCamera();
                                await assessorDashboardController
                                    .getOfflineVivaQuestions();
                                //  exam date time code

                                // step wise marking code
                                await Get.find<QuestionAnswersController>()
                                    .getSpecificQuestionSteps(
                                        assessorDashboardController
                                            .vQuestions[0].id
                                            .toString());
                                // step wise marking code

                                await Get.find<AssessorDashboardController>()
                                    .getCurrentDateTimeModeSpecific();

                                Get.find<QuestionAnswersController>()
                                    .setCandidateVivaStartDate(
                                        AppConstants.getFormatedCurrentDate(
                                            DateTime.now()));
                                Get.find<QuestionAnswersController>()
                                    .setCandidateVivaStartTime(
                                        AppConstants.getFormatedCurrentTime(
                                            DateTime.now()));
                                //  exam date time code
                                Get.to(VivaQuestionScreen(
                                    candidate: candidate,
                                    vQuestions: assessorDashboardController
                                        .vQuestions));
                                //   } else {
                                //     CustomSnackBar.customSnackBar(false,
                                //         "Please Upload ${candidate.name} Documents first");
                                //   }
                                // }
                              }
                            },
                            child: Chip(
                                label: SizedBox(
                                  width: Get.width * 0.30,
                                  child: Center(
                                    child: Text(
                                      "VIVA",
                                      style: AppConstants.subHeading
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                                backgroundColor: isVivaCompleted == false
                                    ? AppConstants.appGrey
                                    : AppConstants.successGreen),
                          ),
                        ),
                        Visibility(
                          visible:
                              assessorDashboardController.pQuestions.isNotEmpty,
                          child: InkWell(
                            onTap: () async {
                              if (isPracticleCompleted == false) {
                                // if (isDocumentationCompleted == true) {
                                if (assessorDashboardController
                                    .pQuestions.isNotEmpty) {
                                  // if (isVivaCompleted == true) {
                                  await Get.find<QuestionAnswersController>()
                                      .initializeCamera(null);
                                  Get.find<QuestionAnswersController>()
                                      .openCamera();
                                  await assessorDashboardController
                                      .getOfflinePracticleQuestions();

                                  // step wise marking code
                                  await Get.find<QuestionAnswersController>()
                                      .getSpecificQuestionSteps(
                                          assessorDashboardController
                                              .pQuestions[0].id
                                              .toString());
                                  // step wise marking code

                                  await Get.find<AssessorDashboardController>()
                                      .getCurrentDateTimeModeSpecific();

                                  //  exam date time code
                                  Get.find<QuestionAnswersController>()
                                      .setCandidatePracticalStartDate(
                                          AppConstants.getFormatedCurrentDate(
                                              DateTime.now()));
                                  Get.find<QuestionAnswersController>()
                                      .setCandidatePracticalStartTime(
                                          AppConstants.getFormatedCurrentTime(
                                              DateTime.now()));
                                  //  exam date time code
                                  Get.to(PracticleQuestionScreen(
                                    candidate: candidate,
                                    pQuestions:
                                        assessorDashboardController.pQuestions,
                                    index: index,
                                  ));
                                  // } else {
                                  //   CustomSnackBar.customSnackBar(false,
                                  //       "Please Complete ${candidate.name} Viva first",
                                  //       isLong: true);
                                  // }
                                } else {
                                  await Get.find<QuestionAnswersController>()
                                      .initializeCamera(null);
                                  Get.find<QuestionAnswersController>()
                                      .openCamera();
                                  await assessorDashboardController
                                      .getOfflinePracticleQuestions();
                                  Get.to(PracticleQuestionScreen(
                                    candidate: candidate,
                                    pQuestions:
                                        assessorDashboardController.pQuestions,
                                    index: index,
                                  ));
                                }
                                // } else {
                                //   CustomSnackBar.customSnackBar(false,
                                //       "Please Complete ${candidate.name} Documentation first",
                                //       isLong: true);
                                // }
                              }
                            },
                            child: Chip(
                                label: SizedBox(
                                  width: Get.width * 0.35,
                                  child: Center(
                                    child: Text(
                                      "PRACTICAL",
                                      style: AppConstants.subHeading
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                                backgroundColor: isPracticleCompleted == false
                                    ? AppConstants.appGrey
                                    : AppConstants.successGreen),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class CustomGroupStudentListTile extends StatelessWidget {
  final Batches candidate;
  final bool? isVivaCompleted;
  final bool? isPracticleCompleted;
  final bool? isDocumentationCompleted;
  final int? index;

  const CustomGroupStudentListTile(
      {super.key,
      this.isDocumentationCompleted,
      this.isPracticleCompleted,
      this.isVivaCompleted,
      required this.candidate,
      this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AssessorDashboardController>(
        builder: (assessorDashboardController) {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: AppConstants.paddingExtraLarge,
            vertical: AppConstants.fontSmall),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.borderRadiusLarge)),
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: Get.width * 0.6,
                              child: Text(
                                "${index! + 1}) Name: ${candidate.name ?? ""}",
                                // "Name: ${candidate.name ?? ""}",
                                style: AppConstants.titleBold,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.6,
                              child: Text(
                                "ID: ${candidate.enrollmentNo ?? ""}",
                                style: AppConstants.titleBold,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Checkbox(
                            value: assessorDashboardController
                                .isCandidateAlreadyAddedToGroup(
                                    candidate.id.toString()),
                            onChanged: (value) {
                              print(
                                  assessorDashboardController.selectedExamType);
                              if (assessorDashboardController
                                      .selectedExamType ==
                                  null) {
                                CustomToast.showToast(
                                    "Please Select Exam type first");
                              } else {
                                if (assessorDashboardController
                                        .selectedExamType ==
                                    "Viva") {
                                  if (isVivaCompleted == true) {
                                    CustomToast.showToast(
                                        "${candidate.name} has already submitted the Viva");
                                  } else {
                                    if (assessorDashboardController
                                            .isCandidateAlreadyAddedToGroup(
                                                candidate.id.toString()) ==
                                        false) {
                                      assessorDashboardController
                                          .addToSelectedCandidates(candidate);
                                    } else {
                                      assessorDashboardController
                                          .removeFromSelectedCandidates(
                                              candidate);
                                    }
                                  }
                                }
                                if (assessorDashboardController
                                        .selectedExamType ==
                                    "Practical") {
                                  if (isPracticleCompleted == true) {
                                    CustomToast.showToast(
                                        "${candidate.name} has already submitted the Practical");
                                  } else {
                                    if (isDocumentationCompleted == true) {
                                      if (assessorDashboardController
                                              .isCandidateAlreadyAddedToGroup(
                                                  candidate.id.toString()) ==
                                          false) {
                                        assessorDashboardController
                                            .addToSelectedCandidates(candidate);
                                      } else {
                                        assessorDashboardController
                                            .removeFromSelectedCandidates(
                                                candidate);
                                      }
                                    } else {
                                      CustomToast.showToast(
                                          "Please Upload ${candidate.name} Documents First");
                                    }
                                  }
                                }
                              }
                            })
                      ],
                    ),
                    SizedBox(
                      height: AppConstants.paddingDefault,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Visibility(
                        //     visible: assessorDashboardController
                        //         .vQuestions.isNotEmpty,
                        //     child: Chip(
                        //       label: Row(
                        //         children: [
                        //           Text(
                        //             "Viva",
                        //             style: AppConstants.subHeadingBold,
                        //           ),
                        //           isVivaCompleted == false
                        //               ? const Icon(
                        //                   Icons.close,
                        //                   color: Colors.red,
                        //                 )
                        //               : const Icon(
                        //                   Icons.check,
                        //                   color: Colors.green,
                        //                 )
                        //         ],
                        //       ),
                        //     )),
                        // SizedBox(
                        //   width: AppConstants.paddingDefault,
                        // ),

                        Visibility(
                            visible: assessorDashboardController
                                .pQuestions.isNotEmpty,
                            child: Chip(
                              backgroundColor: isPracticleCompleted == true
                                  ? Colors.green
                                  : const Color.fromARGB(255, 199, 199, 199),
                              label: Row(
                                children: [
                                  Text(
                                    "Practical ",
                                    style: AppConstants.subHeadingBold.copyWith(
                                        color: isPracticleCompleted == true
                                            ? Colors.white
                                            : const Color(0xff333333)),
                                  ),
                                  isPracticleCompleted == false
                                      ? const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        )
                                      : const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        )
                                ],
                              ),
                            )),
                        SizedBox(
                          width: AppConstants.paddingDefault,
                        ),
                        isDocumentationCompleted == true
                            ? SizedBox(
                                height: 50,
                                width: 40,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      left: 0,
                                      bottom: 0,
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: AppConstants.successGreen,
                                        size: AppConstants.fontExtraLarge * 1.5,
                                      ),
                                    ),
                                    Positioned(
                                      top: -3,
                                      right: -5,
                                      child: Icon(
                                        Icons.check,
                                        color: AppConstants.successGreen,
                                        size: AppConstants.fontExtraLarge * 1.5,
                                      ),
                                    ),
                                  ],
                                ))
                            : InkWell(
                                onTap: () {
                                  Get.to(AssessorDocumentUploadScreen(
                                    candidate: candidate,
                                    docsList: [],
                                  ));
                                },
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: AppConstants.paddingExtraLarge * 1.5,
                                  color: AppConstants.appGrey,
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
