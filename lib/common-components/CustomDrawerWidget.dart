import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomIndicatorWidget.dart';
import 'package:mytat/common-components/CustomSnackbar.dart';
import 'package:mytat/controller/Candidate-Side-Controllers/CandidateOnboardingController.dart';
// import 'package:mytat/question-answers-screens/mcq_questions_screen.dart';
import 'package:mytat/utilities/AppConstants.dart';

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // key: drawerKey,
      // backgroundColor: AppConstants.appGreen,
      child: SafeArea(
        child: GetBuilder<CandidateOnboardingController>(
            builder: (candidateOnboardingController) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Get.width,
                  child: Card(
                    elevation: 0,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: AppConstants.paddingSmall - 2,
                          top: AppConstants.paddingDefault,
                          bottom: AppConstants.paddingDefault,
                          right: AppConstants.paddingSmall - 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Attempted:",
                                style: AppConstants.subHeadingBold,
                              ),
                              Text(
                                " ${candidateOnboardingController.candidateAnswersList.length.toString()}",
                                style: AppConstants.subHeadingItalic,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: AppConstants.paddingSmall,
                      top: AppConstants.paddingSmall,
                      bottom: AppConstants.paddingSmall),
                  child: Text(
                    "Total Attempted Questions: ${candidateOnboardingController.candidateAnswersList.length}",
                    style: AppConstants.titleBold,
                  ),
                ),
                GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount:
                        candidateOnboardingController.mcqQuestions.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (candidateOnboardingController
                                  .assessmentDurationInformation!
                                  .mandatoryQuestion ==
                              "Y") {
                            Navigator.pop(context);
                            CustomSnackBar.customSnackBar(
                                false, "All Questions are mandatory!");
                          } else if (candidateOnboardingController
                                  .assessmentDurationInformation!.moveForward ==
                              "Y") {
                            Navigator.pop(context);
                            CustomSnackBar.customSnackBar(
                                false, "You can not Switch between questions!");
                          } else {
                            candidateOnboardingController
                                .setCurrentMcqQuestion(index);
                            Navigator.pop(context);
                          }

                          // drawerKey.c
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color:
                                  candidateOnboardingController.isMarkForReview(
                                              candidateOnboardingController
                                                  .mcqQuestions[index]) ==
                                          true
                                      ? AppConstants.appSecondary
                                      : candidateOnboardingController
                                              .isAlreadyAnswered(
                                                  candidateOnboardingController
                                                      .mcqQuestions[index])
                                          ? AppConstants.appGreen
                                          : AppConstants.appGrey,
                              borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusSmall)),
                          margin: EdgeInsets.all(AppConstants.paddingSmall),
                          height: AppConstants.largebuttonSized + 20,
                          width: AppConstants.largebuttonSized + 20,
                          child: Center(
                            child: Text(
                              "${index + 1}",
                              style: AppConstants.subHeadingBold
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    }),
                const Divider(
                  thickness: 2,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: AppConstants.paddingSmall,
                      top: AppConstants.paddingSmall,
                      bottom: AppConstants.paddingSmall),
                  child: Text(
                    "Instructions:",
                    style: AppConstants.titleBold,
                  ),
                ),
                const CustomIndicatorWidget(isDrawer: true),
              ],
            ),
          );
        }),
      ),
    );
  }
}
