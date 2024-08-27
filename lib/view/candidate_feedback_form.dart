import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:mytat/common-components/CustomAppBar.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/common-components/CustomLoadingIndicator.dart';
import 'package:mytat/common-components/CustomToastMessage.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/Candidate-Side-Controllers/CandidateOnboardingController.dart';
import 'package:mytat/model/FeedbackAnswersModel.dart';
import 'package:mytat/model/FeedbackFormQuestionsListModel.dart';
import 'package:mytat/model/StudentsBatchModel.dart';
import 'package:mytat/services/db_helper.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:mytat/view/Authorization/login_type_screen.dart';
import 'package:mytat/view/user_mode_screen.dart';

final GlobalKey<FormState> feedbackFormKey = GlobalKey<FormState>();

class CandidateFeedbackForm extends StatelessWidget {
  final String candidateId;
  final String assessmentId;
  final Batches? candidate;
  final String isObservorNeeded;

  const CandidateFeedbackForm(
      {super.key,
      required this.candidateId,
      required this.assessmentId,
      this.candidate,
      required this.isObservorNeeded});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return AppConstants.onWillPop(context);
      },
      child: Container(
          color: AppConstants.appPrimary,
          child: SafeArea(child: GetBuilder<CandidateOnboardingController>(
              builder: (candidateOnboardingController) {
            return Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: candidateOnboardingController.isUploading ==
                          true &&
                      AppConstants.isOnlineMode == true
                  ? const CustomLoadingIndicator()
                  : CustomElevatedButton(
                      onTap: () async {
                        if (feedbackFormKey.currentState!.validate()) {
                          await candidateOnboardingController
                              .storeCandidateAnswersToLocalDatabase();

                          if (AppConstants.isOnlineMode == true) {
                            await candidateOnboardingController
                                .syncOneCandidateFeedback(
                                    candidate!.assmentId.toString(),
                                    candidate!.id.toString());

                            await Get.find<AssessorDashboardController>()
                                .syncMcqOneByOne(candidate!, 0,
                                    isDocumentLinkNeeded: false);
                            await DatabaseHelper().clearDatabase();
                            // Get.find<AuthController>().logOutUser();
                          }
                          // if (isObservorNeeded == "N") {
                          stopKioskMode();
                          candidateOnboardingController.removeObservor();
                          // }
                          Get.offAll(AppConstants.isOnlineMode == true
                              ? const UserModeScreen()
                              : const LoginTypeScreen(
                                  isOnline: false,
                                  isFromStudentLogout: true,
                                ));
                          CustomToast.showToast("Thankyou For Your Feedback.");
                        }
                      },
                      text: "Submit",
                      width: Get.width,
                      height: 40,
                    ),
              appBar: CustomAppBar(
                title: "Feedback Form",
              ),
              body: candidateOnboardingController.isLoadingFeedbackQuestions ==
                      true
                  ? const Center(child: CustomLoadingIndicator())
                  : Form(
                      key: feedbackFormKey,
                      child: Padding(
                          padding: EdgeInsets.all(AppConstants.paddingDefault),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: candidateOnboardingController
                                  .feedbackQuestionsList.length,
                              itemBuilder: (context, index) {
                                return CustomFeedbackQuestionWidget(
                                  controller: TextEditingController(),
                                  question: candidateOnboardingController
                                      .feedbackQuestionsList[index],
                                  index: index,
                                  candidateId: candidateId,
                                );
                              })),
                    ),
            );
          }))),
    );
  }
}

class CustomFeedbackQuestionWidget extends StatelessWidget {
  final TextEditingController controller;
  final FeedbackQuestionModel question;
  final String candidateId;
  final int index;

  const CustomFeedbackQuestionWidget(
      {super.key,
      required this.controller,
      required this.question,
      required this.index,
      required this.candidateId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Q${index + 1}: ${question.title.toString()}",
          style: AppConstants.subHeadingBold,
        ),
        Padding(
          padding: EdgeInsets.only(
              top: AppConstants.paddingSmall,
              bottom: AppConstants.paddingExtraLarge),
          child: TextFormField(
            onChanged: (value) {
              if (value.isNotEmpty) {
                Get.find<CandidateOnboardingController>()
                    .insertOrUpdateFeedbackAnswerList(FeedbackAnswersModel(
                        answer: value,
                        questionId: question.bfqId.toString(),
                        candidateId: candidateId));
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is mandatory.';
              }
              return null;
            },
            controller: controller,
            decoration: InputDecoration(
              hintText: "Write Answer....",
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: AppConstants.appGrey),
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadiusSmall)),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusSmall),
                borderSide:
                    BorderSide(width: 2, color: AppConstants.appPrimary),
              ),
            ),
          ),
        )
      ],
    );
  }
}
