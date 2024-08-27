import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomAppBar.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/common-components/CustomLoadingIndicator.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/Candidate-Side-Controllers/CandidateOnboardingController.dart';
import 'package:mytat/utilities/AppConstants.dart';

class CompletedCandidateStudentListScreen extends StatelessWidget {
  const CompletedCandidateStudentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppConstants.appPrimary,
        child: GetBuilder<CandidateOnboardingController>(
            builder: (candidateOnboardingController) {
          return SafeArea(
              child: Scaffold(
                  appBar: CustomAppBar(title: "Candidate Theory Sync Status"),
                  body: Padding(
                    padding: EdgeInsets.only(left: AppConstants.paddingDefault),
                    child: ListView.builder(
                        itemCount:
                            // candidateOnboardingController.candidatesList.length,
                            candidateOnboardingController
                                .totalMcqAnswersSynced.length,
                        itemBuilder: ((context, index) {
                          return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(candidateOnboardingController.candidatesList[index].name
                                  .toString()),
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
                              minLeadingWidth: 2,
                              // Icon(
                              //   Icons.account_circle,
                              //   size: AppConstants.paddingExtraLarge * 2,
                              // ),
                              trailing: candidateOnboardingController.getLocalStoredTheoryAnswersCount(
                                              candidateOnboardingController
                                                  .totalMcqAnswersSynced[index]
                                                  .userId
                                                  .toString()) ==
                                          -1 &&
                                      int.parse(candidateOnboardingController
                                              .totalMcqAnswersSynced[index].cnt
                                              .toString()) ==
                                          0
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          right: AppConstants.paddingDefault),
                                      child: Chip(
                                        label: Text(
                                          "Not Attempted",
                                          style: AppConstants.body
                                              .copyWith(color: Colors.white),
                                        ),
                                        backgroundColor: AppConstants.appGrey,
                                      ),
                                    )
                                  : index == candidateOnboardingController.currentSyncingIndex
                                      ? Padding(padding: EdgeInsets.only(right: AppConstants.paddingDefault), child: const CustomLoadingIndicator())
                                      : int.parse(candidateOnboardingController.totalMcqAnswersSynced[index].cnt.toString()) != 0
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
                                                          color: Colors.white),
                                                    ),
                                                    Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                    )
                                                  ],
                                                ),
                                                backgroundColor: Colors.green,
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
                                                await candidateOnboardingController
                                                    .syncOneCandidateTheoryDocuments(
                                                        candidateOnboardingController
                                                            .totalMcqAnswersSynced[
                                                                index]
                                                            .userId
                                                            .toString());
                                                await candidateOnboardingController
                                                    .syncOneCandidateMcqAnswersOfCandidates(
                                                        candidateOnboardingController
                                                            .totalMcqAnswersSynced[
                                                                index]
                                                            .userId
                                                            .toString());
                                                await candidateOnboardingController
                                                    .syncOneMcqStudentForTheory(
                                                        candidateOnboardingController
                                                            .totalMcqAnswersSynced[
                                                                index]
                                                            .userId
                                                            .toString());
                                                await candidateOnboardingController
                                                    .syncOneCandidateMcqScreenshots(
                                                        candidateOnboardingController
                                                            .totalMcqAnswersSynced[
                                                                index]
                                                            .userId
                                                            .toString());
                                                // feedback code
                                                await candidateOnboardingController
                                                    .syncOneCandidateFeedback(
                                                        AppConstants.assesmentId
                                                            .toString(),
                                                        candidateOnboardingController
                                                            .totalMcqAnswersSynced[
                                                                index]
                                                            .userId
                                                            .toString());
                                                // feedback_code
                                                //  ecam time api code
                                                await Get.find<
                                                        AssessorDashboardController>()
                                                    .syncOneCandidateFinalTime(
                                                        candidateOnboardingController
                                                            .totalMcqAnswersSynced[
                                                                index]
                                                            .userId
                                                            .toString());
                                                //  ecam time api code
                                                candidateOnboardingController
                                                    .setCurrentSyncingCandidateIndex(
                                                        null);

                                                await Get.find<
                                                        CandidateOnboardingController>()
                                                    .getTotalMcqAnswersSynced();
                                              },
                                              text: "Sync",
                                              height: 30,
                                              width: 120,
                                            )
                              // candidateOnboardingController
                              //             .getLocalStoredTheoryAnswersCount(
                              //                 candidateOnboardingController
                              //                     .totalMcqAnswersSynced[index]
                              //                     .userId
                              //                     .toString()) ==
                              //         -1
                              //     ? Padding(
                              //         padding: EdgeInsets.only(
                              //             right: AppConstants.paddingDefault),
                              //         child: Chip(
                              //           label: Text(
                              //             "Not Attempted",
                              //             style: AppConstants.body
                              //                 .copyWith(color: Colors.white),
                              //           ),
                              //           backgroundColor: AppConstants.appGrey,
                              //         ),
                              //       )
                              //     : index ==
                              //             candidateOnboardingController
                              //                 .currentSyncingIndex
                              //         ? Padding(
                              //             padding:
                              //                 EdgeInsets.only(right: AppConstants.paddingDefault),
                              //             child: const CustomLoadingIndicator())
                              //         : candidateOnboardingController.getLocalStoredTheoryAnswersCount(candidateOnboardingController.totalMcqAnswersSynced[index].userId.toString()) == int.parse(candidateOnboardingController.totalMcqAnswersSynced[index].cnt.toString())
                              //             ? Container(
                              //                 margin: EdgeInsets.only(
                              //                     right: AppConstants
                              //                         .paddingDefault),
                              //                 width: 100,
                              //                 child: Chip(
                              //                   label: Row(
                              //                     mainAxisAlignment:
                              //                         MainAxisAlignment
                              //                             .spaceBetween,
                              //                     children: const [
                              //                       Text(
                              //                         "Synced",
                              //                         style: TextStyle(
                              //                             color: Colors.white),
                              //                       ),
                              //                       Icon(
                              //                         Icons.check,
                              //                         color: Colors.white,
                              //                       )
                              //                     ],
                              //                   ),
                              //                   backgroundColor: Colors.green,
                              //                 ),
                              //               )
                              //             : candidateOnboardingController.getLocalStoredTheoryAnswersCount(candidateOnboardingController.totalMcqAnswersSynced[index].userId.toString()) > int.parse(candidateOnboardingController.totalMcqAnswersSynced[index].cnt.toString()) && int.parse(candidateOnboardingController.totalMcqAnswersSynced[index].cnt.toString()) != 0
                              //                 ? CustomElevatedButton(
                              //                     borderRadius: AppConstants
                              //                         .borderRadiusCircular,
                              //                     buttonColor:
                              //                         AppConstants.appSecondary,
                              //                     onTap: () async {
                              //                       candidateOnboardingController
                              //                           .setCurrentSyncingCandidateIndex(
                              //                               index);
                              //                       await candidateOnboardingController
                              //                           .syncOneCandidateTheoryDocuments(
                              //                               candidateOnboardingController
                              //                                   .totalMcqAnswersSynced[
                              //                                       index]
                              //                                   .userId
                              //                                   .toString());
                              //                       await candidateOnboardingController
                              //                           .syncOneCandidateMcqAnswersOfCandidates(
                              //                               candidateOnboardingController
                              //                                   .totalMcqAnswersSynced[
                              //                                       index]
                              //                                   .userId
                              //                                   .toString());
                              //                       await candidateOnboardingController
                              //                           .syncOneMcqStudentForTheory(
                              //                               candidateOnboardingController
                              //                                   .totalMcqAnswersSynced[
                              //                                       index]
                              //                                   .userId
                              //                                   .toString());
                              //                       await candidateOnboardingController
                              //                           .syncOneCandidateMcqScreenshots(
                              //                               candidateOnboardingController
                              //                                   .totalMcqAnswersSynced[
                              //                                       index]
                              //                                   .userId
                              //                                   .toString());
                              //                       // feedback code
                              //                       await candidateOnboardingController
                              //                           .syncOneCandidateFeedback(
                              //                               AppConstants
                              //                                   .assesmentId
                              //                                   .toString(),
                              //                               candidateOnboardingController
                              //                                   .totalMcqAnswersSynced[
                              //                                       index]
                              //                                   .userId
                              //                                   .toString());
                              //                       // feedback_code
                              //                       //  exam time api code
                              //                       await Get.find<
                              //                               AssessorDashboardController>()
                              //                           .syncOneCandidateFinalTime(
                              //                               candidateOnboardingController
                              //                                   .totalMcqAnswersSynced[
                              //                                       index]
                              //                                   .userId
                              //                                   .toString());
                              //                       //  exam time api code
                              //                       await Get.find<
                              //                               CandidateOnboardingController>()
                              //                           .getTotalMcqAnswersSynced();

                              //                       candidateOnboardingController
                              //                           .setCurrentSyncingCandidateIndex(
                              //                               null);
                              //                     },
                              //                     text: "Partial Sync",
                              //                     height: 30,
                              //                     width: 180,
                              //                   )
                              //                 : CustomElevatedButton(
                              //                     borderRadius: AppConstants
                              //                         .borderRadiusCircular,
                              //                     buttonColor:
                              //                         AppConstants.appSecondary,
                              //                     onTap: () async {
                              //                       candidateOnboardingController
                              //                           .setCurrentSyncingCandidateIndex(
                              //                               index);
                              //                       await candidateOnboardingController
                              //                           .syncOneCandidateTheoryDocuments(
                              //                               candidateOnboardingController
                              //                                   .totalMcqAnswersSynced[
                              //                                       index]
                              //                                   .userId
                              //                                   .toString());
                              //                       await candidateOnboardingController
                              //                           .syncOneCandidateMcqAnswersOfCandidates(
                              //                               candidateOnboardingController
                              //                                   .totalMcqAnswersSynced[
                              //                                       index]
                              //                                   .userId
                              //                                   .toString());
                              //                       await candidateOnboardingController
                              //                           .syncOneMcqStudentForTheory(
                              //                               candidateOnboardingController
                              //                                   .totalMcqAnswersSynced[
                              //                                       index]
                              //                                   .userId
                              //                                   .toString());
                              //                       await candidateOnboardingController
                              //                           .syncOneCandidateMcqScreenshots(
                              //                               candidateOnboardingController
                              //                                   .totalMcqAnswersSynced[
                              //                                       index]
                              //                                   .userId
                              //                                   .toString());
                              //                       // feedback code
                              //                       await candidateOnboardingController
                              //                           .syncOneCandidateFeedback(
                              //                               AppConstants
                              //                                   .assesmentId
                              //                                   .toString(),
                              //                               candidateOnboardingController
                              //                                   .totalMcqAnswersSynced[
                              //                                       index]
                              //                                   .userId
                              //                                   .toString());
                              //                       // feedback_code
                              //                       //  ecam time api code
                              //                       await Get.find<
                              //                               AssessorDashboardController>()
                              //                           .syncOneCandidateFinalTime(
                              //                               candidateOnboardingController
                              //                                   .totalMcqAnswersSynced[
                              //                                       index]
                              //                                   .userId
                              //                                   .toString());
                              //                       //  ecam time api code
                              //                       candidateOnboardingController
                              //                           .setCurrentSyncingCandidateIndex(
                              //                               null);

                              //                       await Get.find<
                              //                               CandidateOnboardingController>()
                              //                           .getTotalMcqAnswersSynced();
                              //                     },
                              //                     text: "Sync",
                              //                     height: 30,
                              //                     width: 120,
                              //                   )
                              );
                        })),
                  )));
        }));
  }
}
