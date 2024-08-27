import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomAppBar.dart';
import 'package:mytat/common-components/CustomStudentListTile.dart';
import 'package:mytat/common-components/CustomToastMessage.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/Online-Controller/OnlineAssessorDashboardController.dart';
import 'package:mytat/controller/QuestionAnswersController.dart';
import 'package:mytat/utilities/AppConstants.dart';

class StudentListScreen extends StatelessWidget {
  const StudentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<AssessorDashboardController>().getOfflineStudentsList();
    return WillPopScope(
      onWillPop: () async {
        if (Get.find<QuestionAnswersController>().isCameraOpen == true) {
          Get.find<QuestionAnswersController>().closeCamera();
        }
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
        child: Scaffold(
          appBar: CustomAppBar(
              title: "Candidates List",
              icon: const Icon(Icons.arrow_back),
              onpressed: () {
                if (Get.find<QuestionAnswersController>().isCameraOpen ==
                    true) {
                  Get.find<QuestionAnswersController>().closeCamera();
                }
                Get.back();
              }),
          body: GetBuilder<AssessorDashboardController>(
              builder: (assessorDashboardController) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft:
                                Radius.circular(AppConstants.borderRadiusLarge),
                            topRight: Radius.circular(
                                AppConstants.borderRadiusLarge))),
                    child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount:
                            assessorDashboardController.studentsBatch.length,
                        itemBuilder: (context, index) {
                          return CustomStudentListTile(
                            candidate: assessorDashboardController
                                .studentsBatch[index],
                            isDocumentationCompleted:
                                assessorDashboardController
                                        .studentsBatch[index].pImg !=
                                    "0",
                            isVivaCompleted: assessorDashboardController
                                    .studentsBatch[index].isVivaDone ==
                                "Y",
                            isPracticleCompleted: assessorDashboardController
                                    .studentsBatch[index].isPracticalDone ==
                                "Y",
                            // assessorDashboardController.isCandidateVivaDone(
                            //         assessorDashboardController
                            //             .studentsBatch[index].id
                            //             .toString()) ==
                            //     true,
                            index: index,
                          );
                        }),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
