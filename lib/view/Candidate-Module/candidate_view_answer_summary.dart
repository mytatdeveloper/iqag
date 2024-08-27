import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomAppBar.dart';
import 'package:mytat/common-components/CustomIndicatorWidget.dart';
import 'package:mytat/common-components/CustomQuestionCountWidget.dart';
import 'package:mytat/controller/Candidate-Side-Controllers/CandidateOnboardingController.dart';
import 'package:mytat/question-answers-screens/mcq_questions_screen.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:mytat/view/Candidate-Module/candidate_view__answers_summary_screen.dart';

class ViewAnswersSummaryScreen extends StatelessWidget {
  const ViewAnswersSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.off(ViewCandidateAnswersSummaryScreen(
          candidate: Get.find<CandidateOnboardingController>()
              .currentOngoingCandidate!,
        ));
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(
            icon: const Icon(Icons.arrow_back),
            onpressed: () {
              Get.off(ViewCandidateAnswersSummaryScreen(
                candidate: Get.find<CandidateOnboardingController>()
                    .currentOngoingCandidate!,
              ));
            },
            title: "Answers Summary"),
        body: GetBuilder<CandidateOnboardingController>(
            builder: (candidateOnboardingController) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppConstants.paddingExtraLarge),
              child: Column(
                children: [
                  // if (candidateOnboardingController.webProctoring == "Y")
                  //   SizedBox(
                  //       height: AppConstants.largebuttonSized * 3,
                  //       width: AppConstants.largebuttonSized * 3,
                  //       child: FaceDetectorView()),
                  // SizedBox(
                  //   height: AppConstants.paddingExtraLarge,
                  // ),
                  CustomQuestionCountWidget(
                    markForReview:
                        candidateOnboardingController.getTotalMarkForReview(),
                    questionsAttempted: candidateOnboardingController
                        .candidateAnswersList.length,
                    totalQuestions:
                        candidateOnboardingController.mcqQuestions.length,
                    notAttempted:
                        candidateOnboardingController.mcqQuestions.length -
                            candidateOnboardingController
                                .candidateAnswersList.length,
                  ),
                  const CustomIndicatorWidget(),
                  SizedBox(
                    height: AppConstants.paddingDefault,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Questions",
                        style: AppConstants.titleBold,
                      ),
                      Text(
                        "Answers",
                        style: AppConstants.titleBold,
                      ),
                      const SizedBox(
                        width: 1,
                      ),
                      Text(
                        "To Do",
                        style: AppConstants.titleBold,
                      ),
                    ],
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount:
                          candidateOnboardingController.mcqQuestions.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${index + 1}",
                              style: AppConstants.subHeadingBold,
                            ),
                            candidateOnboardingController.getAnswer(
                                        candidateOnboardingController
                                            .mcqQuestions[index]) !=
                                    null
                                ? Text(
                                    candidateOnboardingController
                                        .getAnswer(candidateOnboardingController
                                            .mcqQuestions[index])
                                        .toString(),
                                    style: AppConstants.subHeadingBold,
                                  )
                                : Text(
                                    "-",
                                    style: AppConstants.subHeadingBold,
                                  ),
                            candidateOnboardingController.isAnswered(
                                    candidateOnboardingController
                                        .mcqQuestions[index])
                                ? InkWell(
                                    onTap: () {
                                      // candidateOnboardingController
                                      //     .disableTemporaryRealTime(false);
                                      candidateOnboardingController
                                          .setCurrentMcqQuestion(index);
                                      Get.to(McqQuestionScreen(
                                        candidate: candidateOnboardingController
                                            .presentCandidate!,
                                        isFromSummary: true,
                                      ));

                                      // candidateOnboardingController
                                      //     .setQuestionToChange(
                                      //         candidateOnboardingController
                                      //             .getQuestionToChange(
                                      //                 candidateOnboardingController
                                      //                     .mcqQuestions[index]));
                                      // Get.off(ChangeAnswerScreen(
                                      //     candidateAnswer:
                                      //         candidateOnboardingController
                                      //             .lastAnswer,
                                      //     question: candidateOnboardingController
                                      //         .mcqQuestions[index]));
                                    },
                                    child: Chip(
                                        backgroundColor:
                                            candidateOnboardingController
                                                    .isMarkForReview(
                                                        candidateOnboardingController
                                                                .mcqQuestions[
                                                            index])
                                                ? AppConstants.appSecondary
                                                : AppConstants.appGreen,
                                        padding: EdgeInsets.zero,
                                        label: Text(
                                          "Change Answer",
                                          style: AppConstants.subHeadingItalic
                                              .copyWith(color: Colors.white),
                                        )),
                                  )
                                : InkWell(
                                    onTap: () {
                                      // disabling temporary real time tracking
                                      // candidateOnboardingController
                                      //     .disableTemporaryRealTime(true);
                                      candidateOnboardingController
                                          .setCurrentMcqQuestion(index);
                                      Get.to(McqQuestionScreen(
                                        candidate: candidateOnboardingController
                                            .presentCandidate!,
                                        isFromSummary: true,
                                      ));
                                      // candidateOnboardingController
                                      //     .setNotAnsweredQuestionToChange(
                                      //         candidateOnboardingController
                                      //             .mcqQuestions[index]);

                                      // Get.off(ChangeAnswerScreen(
                                      //     candidateAnswer: null,
                                      //     question: candidateOnboardingController
                                      //             .currentChangeQuestion ??
                                      //         MQuestions()));
                                    },
                                    child: Chip(
                                        backgroundColor: AppConstants.appRed,
                                        padding: EdgeInsets.zero,
                                        label: Text(
                                          "Not Answered",
                                          style: AppConstants.subHeadingItalic
                                              .copyWith(color: Colors.white),
                                        )),
                                  )
                          ],
                        );
                      }),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
