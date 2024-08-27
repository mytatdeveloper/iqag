import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomAppBar.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/common-components/CustomStudentListTile.dart';
import 'package:mytat/common-components/CustomToastMessage.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/QuestionAnswersController.dart';
import 'package:mytat/question-answers-screens/group_practical_questions_screen.dart';
import 'package:mytat/question-answers-screens/group_viva_questions_screen.dart';
import 'package:mytat/utilities/AppConstants.dart';

class StudentGroupVivaPracticalListScreen extends StatelessWidget {
  const StudentGroupVivaPracticalListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<AssessorDashboardController>().getOfflineStudentsList();
    return WillPopScope(
      onWillPop: () async {
        if (Get.find<QuestionAnswersController>().isCameraOpen == true) {
          Get.find<QuestionAnswersController>().closeCamera();
        }
        Get.find<AssessorDashboardController>().resetCandidatesGroup();
        return true;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          if (AppConstants.isOnlineMode == true) {
            await Get.find<AssessorDashboardController>().importBatch(
                AppConstants.assesmentId.toString(),
                isResetNeeded: true);
            CustomToast.showToast("Candidates List Updated Successfully");
          }
        },
        child: GetBuilder<AssessorDashboardController>(
            builder: (assessorDashboardController) {
          return Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: Visibility(
                  visible:
                      assessorDashboardController.selectedExamType != null &&
                          assessorDashboardController.pQuestions.length *
                                  assessorDashboardController
                                      .studentsBatch.length !=
                              assessorDashboardController
                                  .completedPracticalCandidatesList.length,
                  child: CustomElevatedButton(
                      onTap: () async {
                        if (assessorDashboardController
                            .selectedCandidatesGroupList.isNotEmpty) {
                          await Get.find<AssessorDashboardController>()
                              .getCurrentDateTimeModeSpecific();
                          if (assessorDashboardController.selectedExamType ==
                              "Practical") {
                            await Get.find<QuestionAnswersController>()
                                .initializeCamera(null);
                            Get.find<QuestionAnswersController>().openCamera();
                            await assessorDashboardController
                                .getOfflinePracticleQuestions();

                            Get.find<QuestionAnswersController>()
                                .setSelectedCandidateFromGroup(
                                    assessorDashboardController
                                        .selectedCandidatesGroupList[0]);

                            Get.find<QuestionAnswersController>()
                                .setCandidatePracticalStartDate(
                                    AppConstants.getFormatedCurrentDate(
                                        DateTime.now()));
                            Get.find<QuestionAnswersController>()
                                .setCandidatePracticalStartTime(
                                    AppConstants.getFormatedCurrentTime(
                                        DateTime.now()));

                            // step wise marking code
                            await Get.find<QuestionAnswersController>()
                                .getSpecificQuestionSteps(
                                    assessorDashboardController.pQuestions[0].id
                                        .toString());
                            // step wise marking code

                            //  exam date time code
                            Get.to(GroupPracticleQuestionScreen(
                                pQuestions:
                                    assessorDashboardController.pQuestions,
                                candidates: assessorDashboardController
                                    .selectedCandidatesGroupList));
                          } else if (assessorDashboardController
                                  .selectedExamType ==
                              "Viva") {
                            await Get.find<QuestionAnswersController>()
                                .initializeCamera(null);
                            Get.find<QuestionAnswersController>().openCamera();
                            await assessorDashboardController
                                .getOfflineVivaQuestions();

                            Get.find<QuestionAnswersController>()
                                .setSelectedCandidateFromGroup(
                                    assessorDashboardController
                                        .selectedCandidatesGroupList[0]);

                            Get.find<QuestionAnswersController>()
                                .setCandidateVivaStartDate(
                                    AppConstants.getFormatedCurrentDate(
                                        DateTime.now()));
                            Get.find<QuestionAnswersController>()
                                .setCandidateVivaStartTime(
                                    AppConstants.getFormatedCurrentTime(
                                        DateTime.now()));

                            // step wise marking code
                            await Get.find<QuestionAnswersController>()
                                .getSpecificQuestionSteps(
                                    assessorDashboardController.vQuestions[0].id
                                        .toString());
                            // step wise marking code

                            //  exam date time code
                            Get.to(GroupVivaQuestionScreen(
                                vQuestions:
                                    assessorDashboardController.vQuestions,
                                candidates: assessorDashboardController
                                    .selectedCandidatesGroupList));
                          }
                        } else {
                          CustomToast.showToast(
                              "Please Select Candidates First");
                        }
                      },
                      text:
                          "Start ${assessorDashboardController.selectedExamType}")),
              appBar: CustomAppBar(
                  title: "Group Candidates List",
                  icon: const Icon(Icons.arrow_back),
                  onpressed: () {
                    if (Get.find<QuestionAnswersController>().isCameraOpen ==
                        true) {
                      Get.find<QuestionAnswersController>().closeCamera();
                    }
                    Get.back();
                  }),
              body: assessorDashboardController.pQuestions.isEmpty
                  ? Center(
                      child: Text(
                        assessorDashboardController.pQuestions.isEmpty
                            ? "No Practical Questions"
                            : "Candidates Practical Done",
                        style: AppConstants.subHeadingBold,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 100),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        AppConstants.borderRadiusLarge),
                                    topRight: Radius.circular(
                                        AppConstants.borderRadiusLarge))),
                            child: ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: assessorDashboardController
                                    .studentsBatch.length,
                                itemBuilder: (context, index) {
                                  return Visibility(
                                    visible: true,
                                    child: CustomGroupStudentListTile(
                                      candidate: assessorDashboardController
                                          .studentsBatch[index],
                                      isDocumentationCompleted:
                                          assessorDashboardController
                                                  .studentsBatch[index].pImg !=
                                              "0",
                                      isPracticleCompleted:
                                          assessorDashboardController
                                                  .studentsBatch[index]
                                                  .isPracticalDone ==
                                              "Y",
                                      isVivaCompleted:
                                          assessorDashboardController
                                                  .studentsBatch[index]
                                                  .isVivaDone ==
                                              "Y",
                                      index: index,
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ));
        }),
      ),
    );
  }
}
