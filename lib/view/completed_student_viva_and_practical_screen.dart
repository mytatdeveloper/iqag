import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomAppBar.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/common-components/CustomLoadingIndicator.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/Candidate-Side-Controllers/CandidateOnboardingController.dart';
import 'package:mytat/utilities/AppConstants.dart';

class CompletedCandidateVivaAndPracticalStudentListScreen
    extends StatelessWidget {
  const CompletedCandidateVivaAndPracticalStudentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppConstants.appPrimary,
        child: GetBuilder<CandidateOnboardingController>(
            builder: (candidateOnboardingController) {
          return SafeArea(
              child: Scaffold(
                  appBar: CustomAppBar(
                      title: "Candidate Viva & Practical Sync Status"),
                  body: Padding(
                    padding: EdgeInsets.only(
                        left: AppConstants.paddingDefault,
                        top: AppConstants.paddingDefault),
                    child: candidateOnboardingController
                            .totalPracticalVivaAnswersSynced.isEmpty
                        ? Center(
                            child: Text(
                              "No Candidate Records Found!",
                              style: AppConstants.subHeadingBold,
                            ),
                          )
                        : ListView.builder(
                            itemCount:
                                // candidateOnboardingController
                                //     .candidatesList.length,
                                candidateOnboardingController
                                    .totalPracticalVivaAnswersSynced.length,
                            itemBuilder: ((context, index) {
                              return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(candidateOnboardingController
                                          .candidatesList[index].name
                                          .toString()),
                                    ],
                                  ),
                                  subtitle: Text(candidateOnboardingController
                                      .candidatesList[index].enrollmentNo
                                      .toString()),
                                  leading: Padding(
                                    padding: EdgeInsets.only(
                                        top: AppConstants.paddingDefault / 2),
                                    child: Text(
                                      "${index + 1})",
                                      style: AppConstants.title,
                                    ),
                                  ),
                                  minLeadingWidth: 1,
                                  // Icon(
                                  //   Icons.account_circle,
                                  //   size: AppConstants.paddingExtraLarge * 2,
                                  // ),
                                  trailing: candidateOnboardingController.getLocalStoredVivaAnswersCount(
                                                  candidateOnboardingController
                                                      .totalPracticalVivaAnswersSynced[
                                                          index]
                                                      .userId
                                                      .toString()) ==
                                              -1 &&
                                          int.parse(candidateOnboardingController.totalPracticalVivaAnswersSynced[index].cnt.toString()) ==
                                              0
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              right:
                                                  AppConstants.paddingDefault),
                                          child: Chip(
                                            label: Text(
                                              "Not Attempted",
                                              style: AppConstants.body.copyWith(
                                                  color: Colors.white),
                                            ),
                                            backgroundColor:
                                                AppConstants.appGrey,
                                          ),
                                        )
                                      : index ==
                                              candidateOnboardingController
                                                  .currentSyncingIndex
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  right: AppConstants.paddingDefault),
                                              child: const CustomLoadingIndicator())
                                          : int.parse(candidateOnboardingController.totalPracticalVivaAnswersSynced[index].cnt.toString()) != 0
                                              ? Container(
                                                  margin: EdgeInsets.only(
                                                      right: AppConstants
                                                          .paddingDefault),
                                                  width: 100,
                                                  child: Chip(
                                                    label: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: const [
                                                        Text(
                                                          "Synced",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                        )
                                                      ],
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                )
                                              : CustomElevatedButton(
                                                  borderRadius: AppConstants
                                                      .borderRadiusCircular,
                                                  buttonColor:
                                                      AppConstants.appSecondary,
                                                  onTap: () async {
                                                    candidateOnboardingController
                                                        .setCurrentSyncingCandidateIndex(
                                                            index);
                                                    await Get.find<
                                                            AssessorDashboardController>()
                                                        .syncVivaAndPracicalOnlySpecificCandidate(
                                                            candidateOnboardingController
                                                                .totalPracticalVivaAnswersSynced[
                                                                    index]
                                                                .userId
                                                                .toString());

                                                    await candidateOnboardingController
                                                        .getTotalPracticalAndVivaAnswersSynced();
                                                  },
                                                  text: "Sync",
                                                  height: 30,
                                                  width: 120,
                                                ));
                            })),
                  )));
        }));
  }
}
