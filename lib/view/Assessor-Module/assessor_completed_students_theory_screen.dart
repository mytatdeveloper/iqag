import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomAnimatedIconWidget.dart';
import 'package:mytat/common-components/CustomAppBar.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/common-components/CustomLoadingIndicator.dart';
import 'package:mytat/common-components/CustomNoDataScreen.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/utilities/AppConstants.dart';

class AllTheoryCompletedStudentsList extends StatelessWidget {
  const AllTheoryCompletedStudentsList({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            icon: const Icon(Icons.arrow_back),
            onpressed: () {
              Get.back();
            },
            title: "Students List"),
        body: GetBuilder<AssessorDashboardController>(
            builder: (assessorDashboardController) {
          return Padding(
            padding: EdgeInsets.all(AppConstants.paddingDefault),
            child: assessorDashboardController.completedMcqListOnline.isEmpty &&
                    AppConstants.isOnlineMode == true
                ? CustomNoDataScreen(
                    title: "No Students Record Found",
                    childWidget: CustomAnimatedIconWidget(
                        icon: const Icon(Icons.no_accounts_sharp),
                        animationType: AnimationType.Color,
                        iconSize: AppConstants.fontExtraLarge * 4),
                  )
                : assessorDashboardController
                            .completedStudentsMcqList.isEmpty &&
                        AppConstants.isOnlineMode != true
                    ? CustomNoDataScreen(
                        title: "No Students Record Found",
                        childWidget: CustomAnimatedIconWidget(
                            icon: const Icon(Icons.no_accounts_sharp),
                            animationType: AnimationType.Color,
                            iconSize: AppConstants.fontExtraLarge * 4),
                      )
                    : AppConstants.isOnlineMode == true
                        ? SingleChildScrollView(
                            child: ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: assessorDashboardController
                                    .completedMcqListOnline.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Padding(
                                      padding: EdgeInsets.only(
                                          top: AppConstants.paddingSmall / 2),
                                      child: Text(
                                        "${index + 1})",
                                        style: AppConstants.subHeadingBold,
                                      ),
                                    ),
                                    minLeadingWidth: 1,
                                    // Icon(
                                    //   Icons.person,
                                    //   color: AppConstants.appPrimary,
                                    //   size: AppConstants.fontExtraLarge * 2,
                                    // ),
                                    title: Text(
                                      "${assessorDashboardController.completedMcqListOnline[index].name.toString()} -  ${assessorDashboardController.completedMcqListOnline[index].enrollmentNumber.toString()}",
                                      style: AppConstants.subHeadingBold,
                                    ),
                                    // subtitle: Text(
                                    //   assessorDashboardController
                                    //       .completedMcqListOnline[index].id
                                    //       .toString(),
                                    //   style: AppConstants.bodyItalic,
                                    // ),
                                    trailing: Wrap(
                                      children: [
                                        if (assessorDashboardController
                                                .tempPQuestionsList
                                                .isNotEmpty ||
                                            assessorDashboardController
                                                .tempVQuestionsList.isNotEmpty)
                                          Chip(
                                              backgroundColor:
                                                  assessorDashboardController
                                                              .completedMcqListOnline[
                                                                  index]
                                                              .isVideo ==
                                                          "Yes"
                                                      ? AppConstants
                                                          .successGreen
                                                      : AppConstants.appGrey,
                                              label:
                                                  const Text("Practical/Viva")),
                                        SizedBox(
                                          width: AppConstants.paddingDefault,
                                        ),
                                        if (assessorDashboardController
                                            .tempMQuestionsList.isNotEmpty)
                                          Chip(
                                              backgroundColor:
                                                  assessorDashboardController
                                                              .completedMcqListOnline[
                                                                  index]
                                                              .isMCQ ==
                                                          "Yes"
                                                      ? AppConstants
                                                          .successGreen
                                                      : AppConstants.appGrey,
                                              label: const Text("MCQ")),
                                      ],
                                    ),
                                  );
                                }),
                          )
                        : SingleChildScrollView(
                            child: ListView.builder(
                                itemCount: assessorDashboardController
                                    .completedStudentsMcqList.length,
                                shrinkWrap: true,
                                primary: false,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                      leading: Text(
                                        "${index + 1})",
                                        style: AppConstants.subHeadingBold,
                                      ),
                                      minLeadingWidth: 1,
                                      contentPadding: EdgeInsets.zero,
                                      // leading: Icon(
                                      //   Icons.person,
                                      //   color: AppConstants.appPrimary,
                                      //   size: AppConstants.fontExtraLarge * 2,
                                      // ),
                                      title: Text(
                                        assessorDashboardController
                                            .completedStudentsMcqList[index]
                                            .name
                                            .toString(),
                                        style: AppConstants.subHeadingBold,
                                      ),
                                      subtitle: Text(
                                        assessorDashboardController
                                            .completedStudentsMcqList[index].id
                                            .toString(),
                                        style: AppConstants.bodyItalic,
                                      ),
                                      trailing: assessorDashboardController
                                                  .isCandidateMcqSynced(
                                                      assessorDashboardController
                                                          .completedStudentsMcqList[
                                                              index]
                                                          .id
                                                          .toString()) ==
                                              true
                                          ? CustomElevatedButton(
                                              buttonColor:
                                                  AppConstants.successGreen,
                                              ispaddingNeeded: false,
                                              borderRadius: AppConstants
                                                  .borderRadiusCircular,
                                              width: Get.width * 0.2,
                                              height: AppConstants
                                                  .mediumButtonSized,
                                              onTap: () async {},
                                              text: "Synced")
                                          : assessorDashboardController
                                                          .isSyncingSingleData ==
                                                      true &&
                                                  index ==
                                                      assessorDashboardController
                                                          .currentSyncingCandidate
                                              ? SizedBox(
                                                  width: Get.width * 0.5,
                                                  height: AppConstants
                                                      .largebuttonSized,
                                                  child: Chip(
                                                      backgroundColor:
                                                          AppConstants
                                                              .appBackground,
                                                      label: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Text(
                                                            assessorDashboardController
                                                                .singleSyncingTitle,
                                                            style: AppConstants
                                                                .bodyItalic,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                          const CustomLoadingIndicator()
                                                        ],
                                                      )),
                                                )
                                              : CustomElevatedButton(
                                                  buttonColor:
                                                      AppConstants.appSecondary,
                                                  ispaddingNeeded: false,
                                                  borderRadius: AppConstants
                                                      .borderRadiusCircular,
                                                  width: Get.width * 0.2,
                                                  height: AppConstants
                                                      .mediumButtonSized,
                                                  onTap: () async {
                                                    await assessorDashboardController
                                                        .syncMcqOneByOne(
                                                            assessorDashboardController
                                                                    .completedStudentsMcqList[
                                                                index],
                                                            index);
                                                  },
                                                  text: "Sync"));
                                }),
                          ),
          );
        }));
  }
}
