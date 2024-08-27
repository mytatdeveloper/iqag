import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomAnimatedIconWidget.dart';
import 'package:mytat/common-components/CustomAppBar.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/common-components/CustomNoDataScreen.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:mytat/view/candidate_feedback_form.dart';

import '../../common-components/CustomLoadingIndicator.dart';

class AllVivaCompletedStudentsList extends StatelessWidget {
  const AllVivaCompletedStudentsList({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            icon: const Icon(Icons.arrow_back),
            onpressed: () {
              Get.back();
            },
            title: "Completed Viva Students List"),
        body: GetBuilder<AssessorDashboardController>(
            builder: (assessorDashboardController) {
          return Padding(
            padding: EdgeInsets.all(AppConstants.paddingExtraLarge),
            child: assessorDashboardController.studentsBatch.isEmpty
                ? CustomNoDataScreen(
                    title: "No Students Record Found",
                    childWidget: CustomAnimatedIconWidget(
                        icon: const Icon(Icons.no_accounts_sharp),
                        animationType: AnimationType.Color,
                        iconSize: AppConstants.fontExtraLarge * 4),
                  )
                : ListView.builder(
                    itemCount: assessorDashboardController.studentsBatch.length,
                    itemBuilder: (context, index) {
                      return Visibility(
                        visible: assessorDashboardController
                                .isCandidateDocumentationDone(
                                    assessorDashboardController
                                        .studentsBatch[index].id
                                        .toString()) ==
                            true,
                        //         true &&
                        //     assessorDashboardController
                        //         .pQuestions.isNotEmpty
                        // ? assessorDashboardController
                        //         .isCandidatePracticalDone(
                        //             assessorDashboardController
                        //                 .studentsBatch[index].id
                        //                 .toString()) ==
                        //     true
                        // : true &&
                        //         assessorDashboardController
                        //             .vQuestions.isNotEmpty
                        //     ? assessorDashboardController
                        //             .isCandidateVivaDone(
                        //                 assessorDashboardController
                        //                     .studentsBatch[index].id
                        //                     .toString()) ==
                        //         true
                        //     : true,
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.person,
                            color: AppConstants.appPrimary,
                            size: AppConstants.fontExtraLarge * 2,
                          ),
                          title: Text(
                            assessorDashboardController
                                .studentsBatch[index].name
                                .toString(),
                            style: AppConstants.subHeadingBold,
                          ),
                          subtitle: Text(
                            assessorDashboardController.studentsBatch[index].id
                                .toString(),
                            style: AppConstants.bodyItalic,
                          ),
                          trailing: assessorDashboardController
                                      .isCandidateVivaAndPracticalsSynced(
                                          assessorDashboardController
                                              .studentsBatch[index].id
                                              .toString()) ==
                                  true
                              ? CustomElevatedButton(
                                  buttonColor: AppConstants.successGreen,
                                  ispaddingNeeded: false,
                                  borderRadius:
                                      AppConstants.borderRadiusCircular,
                                  width: Get.width * 0.2,
                                  height: AppConstants.mediumButtonSized,
                                  onTap: () {},
                                  text: "Synced")
                              : assessorDashboardController
                                              .isSyncingSingleData ==
                                          true &&
                                      index ==
                                          assessorDashboardController
                                              .currentSyncingCandidate
                                  ? SizedBox(
                                      width: Get.width * 0.5,
                                      height: AppConstants.largebuttonSized,
                                      child: Chip(
                                          backgroundColor:
                                              AppConstants.appBackground,
                                          label: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                assessorDashboardController
                                                    .singleSyncingTitle,
                                                style: AppConstants.bodyItalic,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              const CustomLoadingIndicator()
                                            ],
                                          )),
                                    )
                                  : CustomElevatedButton(
                                      buttonColor: AppConstants.appSecondary,
                                      ispaddingNeeded: false,
                                      borderRadius:
                                          AppConstants.borderRadiusCircular,
                                      width: Get.width * 0.2,
                                      height: AppConstants.mediumButtonSized,
                                      onTap: () async {
                                        await assessorDashboardController
                                            .syncVivaAndPracicalOneByOne(
                                                assessorDashboardController
                                                    .studentsBatch[index],
                                                index);
                                      },
                                      text: "Sync"),
                        ),
                      );
                    }),
          );
        }));
  }
}
