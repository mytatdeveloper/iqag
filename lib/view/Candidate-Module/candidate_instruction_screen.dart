import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:mytat/common-components/CustomAppBar.dart';
import 'package:mytat/common-components/CustomDropDownMenu.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/common-components/CustomLoadingIndicator.dart';
import 'package:mytat/common-components/CustomStepperWidget.dart';
import 'package:mytat/common-components/CustomWarnigDialog.dart';
import 'package:mytat/common-components/tensor-flow-components/camera_view.dart';
import 'package:mytat/controller/Candidate-Side-Controllers/CandidateOnboardingController.dart';
import 'package:mytat/model/StudentsBatchModel.dart';
import 'package:mytat/question-answers-screens/mcq_questions_screen.dart';
import 'package:mytat/utilities/AppConstants.dart';

class CandidateInstructionScreen extends StatelessWidget {
  final Batches candidate;

  const CandidateInstructionScreen({super.key, required this.candidate});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return AppConstants.onWillPop(context);
      },
      child: Scaffold(
        backgroundColor: AppConstants.appBackground,
        appBar: CustomAppBar(
          title: "Assessment Instructions",
          // icon: const Icon(Icons.arrow_back),
          // onpressed: () {
          //   Get.back();
          // }
        ),
        body: GetBuilder<CandidateOnboardingController>(
            builder: (candidateOnboardingController) {
          return Padding(
            padding: EdgeInsets.all(AppConstants.paddingExtraLarge),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomStepper(
                    stepColor: AppConstants.appSecondary,
                    currentStep: 2,
                    instructions: AppConstants.instructionsList),
                SizedBox(
                  height: AppConstants.paddingExtraLarge,
                ),
                if (candidateOnboardingController
                        .availableTheoryPaperLanguageList.length >
                    1)
                  const CustomVernacularDropdownMenu(),
                SizedBox(
                  height: AppConstants.paddingExtraLarge,
                ),
                candidateOnboardingController.isLoadingOnline == true
                    ? const CustomLoadingIndicator()
                    : CustomElevatedButton(
                        onTap: () async {
                          Get.dialog(
                            CustomWarningDialog(
                              title:
                                  "Once you click on Ok then the timer will start and you can not exit or leave the assessment after that",
                              onPress: () async {
                                final mode = await getKioskMode();
                                if (mode == KioskMode.disabled) {
                                  startKioskMode();
                                } else {
                                  Get.back();
                                  await candidateOnboardingController
                                      .loadMcqQuestionsFromDB();
                                  await candidateOnboardingController
                                      .setBaseDurationVariables(candidate);
                                  // exam date time code
                                  candidateOnboardingController
                                      .setCandidateStartTime(
                                          AppConstants.getFormatedCurrentTime(
                                              DateTime.now()));

                                  candidateOnboardingController
                                      .setCandidateStartDate(
                                          AppConstants.getFormatedCurrentDate(
                                              DateTime.now()));
                                  // exam date time code

                                  candidateOnboardingController
                                      .changeIsLoadingOnline(true);

                                  // Trendsetters Code
                                  await candidateOnboardingController
                                      .getAllLanguageQuestions();
                                  // Trendsetters Code

                                  // camera access for web poctoring

                                  if (candidateOnboardingController
                                          .webProctoring ==
                                      "Y") {
                                    startCaptureTimer();
                                  }
                                  candidateOnboardingController
                                      .changeIsLoadingOnline(false);
                                  Get.to(McqQuestionScreen(
                                    candidate: candidate,
                                  ));
                                  // observor code
                                  // if (candidateOnboardingController
                                  //         .assessmentDurationInformation!
                                  //         .tabSwitchesAllowed ==
                                  //     "Y") {
                                  // startKioskMode();
                                  candidateOnboardingController.addObservor();
                                  // }
                                  // observor code
                                  // restricting the screen shots on start
                                  if (candidateOnboardingController
                                          .screenshare ==
                                      "N") {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback(
                                            (timeStamp) async {
                                      if (Platform.isAndroid == true) {
                                        await FlutterWindowManager.addFlags(
                                            FlutterWindowManager.FLAG_SECURE);
                                      }
                                    });
                                    // restricting the screen shots on start
                                  }
                                }
                              },
                            ),
                          );
                        },
                        width: Get.width * 0.5,
                        height: AppConstants.paddingExtraLarge * 2,
                        text: "Start",
                        borderRadius: AppConstants.borderRadiusCircular,
                        buttonColor: AppConstants.appSecondary,
                      ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
