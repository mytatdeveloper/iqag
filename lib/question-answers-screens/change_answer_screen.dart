// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:get/get.dart';
// import 'package:mytat/common-components/CustomAppBar.dart';
// import 'package:mytat/common-components/CustomElevatedButton.dart';
// import 'package:mytat/common-components/CustomShimmerEffect.dart';
// import 'package:mytat/controller/Candidate-Side-Controllers/CandidateOnboardingController.dart';
// import 'package:mytat/model/AssesmentQuestionsModel.dart';
// import 'package:mytat/model/Syncing-Models/CandidateMCQAnswersModel.dart';
// import 'package:mytat/utilities/AppConstants.dart';
// import 'package:mytat/view/Candidate-Module/candidate_view_answer_summary.dart';

// class ChangeAnswerScreen extends StatelessWidget {
//   final McqAnswers? candidateAnswer;
//   final MQuestions? question;

//   const ChangeAnswerScreen({
//     super.key,
//     required this.candidateAnswer,
//     required this.question,
//   });

//   @override
//   Widget build(BuildContext context) {
//     Future<String> fetchTranslation(String value) async {
//       // Your translation logic here
//       String translation = await Get.find<CandidateOnboardingController>()
//           .translateText(value, AppConstants.countryCode);
//       return translation;
//     }

//     return WillPopScope(
//       onWillPop: () async {
//         Get.off(const ViewAnswersSummaryScreen());
//         return true;
//       },
//       child: GetBuilder<CandidateOnboardingController>(
//           builder: (candidateOnboardingController) {
//         return Scaffold(
//             floatingActionButtonLocation:
//                 FloatingActionButtonLocation.centerDocked,
//             floatingActionButton: Padding(
//               padding: EdgeInsets.only(bottom: AppConstants.paddingExtraLarge),
//               child: CustomElevatedButton(
//                 width: Get.width * 0.5,
//                 height: AppConstants.largebuttonSized,
//                 borderRadius: AppConstants.borderRadiusCircular,
//                 onTap: () {
//                   if (candidateAnswer == null &&
//                       candidateOnboardingController
//                               .changedAnswserSelectedQuestion !=
//                           null) {
//                     candidateOnboardingController
//                         .addToCandidateAnswersList(McqAnswers(
//                       answerId:
//                           candidateOnboardingController.getCurrentOptionValue(),
//                       questionId: candidateOnboardingController
//                               .currentChangeQuestion!.id ??
//                           "",
//                       assessmentId: candidateOnboardingController
//                           .presentCandidate!.assmentId,
//                       markForReview:
//                           candidateOnboardingController.markForReviewSummary,
//                       candidateId:
//                           candidateOnboardingController.presentCandidate!.id,
//                     ));
//                     candidateOnboardingController.resetCurrentChangeQuestion();
//                     Get.off(const ViewAnswersSummaryScreen());
//                   } else if (candidateOnboardingController
//                           .changedAnswserSelectedQuestion ==
//                       null) {
//                     Get.off(const ViewAnswersSummaryScreen());
//                   } else {
//                     candidateOnboardingController.saveAndChnageAnswer();
//                     candidateOnboardingController.resetCurrentChangeQuestion();
//                     Get.off(const ViewAnswersSummaryScreen());
//                   }
//                 },
//                 text: "Submit",
//                 buttonColor: AppConstants.appGreen,
//               ),
//             ),
//             appBar: CustomAppBar(title: "Change Answer"),
//             body: Padding(
//               padding: EdgeInsets.all(AppConstants.fontExtraLarge),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("Mark For Review", style: AppConstants.titleBold),
//                         Checkbox(
//                             activeColor: AppConstants.appRed,
//                             value: (candidateOnboardingController
//                                     .markForReviewSummary ==
//                                 1),
//                             onChanged: (value) {
//                               if (value == true) {
//                                 candidateOnboardingController
//                                     .changeAnswerMarkforReviewStatus(1);
//                               } else {
//                                 candidateOnboardingController
//                                     .changeAnswerMarkforReviewStatus(0);
//                               }
//                             }),
//                       ],
//                     ),
//                     AppConstants.isOnlineMode == true
//                         ? FutureBuilder<String>(
//                             future:
//                                 fetchTranslation(question!.title.toString()),
//                             builder: (context, snapshot) {
//                               if (snapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return CustomShimmerEffect(); // Display a loading indicator while waiting for translation
//                               } else if (snapshot.hasError) {
//                                 return Text('Error: ${snapshot.error}');
//                               } else {
//                                 return Html(
//                                     data: snapshot.data ??
//                                         ''); // Use the translated data when available
//                               }
//                             },
//                           )
//                         : Html(data: "${question!.title}"),
//                     SizedBox(
//                       height: AppConstants.paddingLarge,
//                     ),
//                     Column(
//                       children: [
//                         Visibility(
//                           visible: question!.option1 != null &&
//                               question!.option1.toString() != "",
//                           child: RadioListTile<String>(
//                             activeColor: AppConstants.appSecondary,
//                             title: AppConstants.isOnlineMode == true
//                                 ? FutureBuilder<String>(
//                                     future: fetchTranslation(
//                                         question!.option1.toString()),
//                                     builder: (context, snapshot) {
//                                       if (snapshot.connectionState ==
//                                           ConnectionState.waiting) {
//                                         return CustomShimmerEffect(); // Display a loading indicator while waiting for translation
//                                       } else if (snapshot.hasError) {
//                                         return Text('Error: ${snapshot.error}');
//                                       } else {
//                                         return Html(
//                                             data: snapshot.data ??
//                                                 ''); // Use the translated data when available
//                                       }
//                                     },
//                                   )
//                                 : Html(data: question!.option1),
//                             value: question!.option1.toString(),
//                             groupValue: candidateOnboardingController
//                                 .changedAnswserSelectedQuestion,
//                             onChanged: (value) {
//                               candidateOnboardingController
//                                   .changeSelectedOption(value!);
//                             },
//                           ),
//                         ),
//                         Visibility(
//                           visible: question!.option2 != null &&
//                               question!.option2.toString() != "",
//                           child: RadioListTile<String>(
//                             activeColor: AppConstants.appSecondary,
//                             title: AppConstants.isOnlineMode == true
//                                 ? FutureBuilder<String>(
//                                     future: fetchTranslation(
//                                         question!.option2.toString()),
//                                     builder: (context, snapshot) {
//                                       if (snapshot.connectionState ==
//                                           ConnectionState.waiting) {
//                                         return CustomShimmerEffect(); // Display a loading indicator while waiting for translation
//                                       } else if (snapshot.hasError) {
//                                         return Text('Error: ${snapshot.error}');
//                                       } else {
//                                         return Html(
//                                             data: snapshot.data ??
//                                                 ''); // Use the translated data when available
//                                       }
//                                     },
//                                   )
//                                 : Html(data: question!.option2.toString()),
//                             value: question!.option2.toString(),
//                             groupValue: candidateOnboardingController
//                                 .changedAnswserSelectedQuestion,
//                             onChanged: (value) {
//                               candidateOnboardingController
//                                   .changeSelectedOption(value!);
//                             },
//                           ),
//                         ),
//                         Visibility(
//                           visible: question!.option3 != null &&
//                               question!.option3.toString() != "",
//                           child: RadioListTile<String>(
//                             activeColor: AppConstants.appSecondary,
//                             title: AppConstants.isOnlineMode == true
//                                 ? FutureBuilder<String>(
//                                     future: fetchTranslation(
//                                         question!.option3.toString()),
//                                     builder: (context, snapshot) {
//                                       if (snapshot.connectionState ==
//                                           ConnectionState.waiting) {
//                                         return CustomShimmerEffect(); // Display a loading indicator while waiting for translation
//                                       } else if (snapshot.hasError) {
//                                         return Text('Error: ${snapshot.error}');
//                                       } else {
//                                         return Html(
//                                             data: snapshot.data ??
//                                                 ''); // Use the translated data when available
//                                       }
//                                     },
//                                   )
//                                 : Html(data: question!.option3.toString()),
//                             value: question!.option3.toString(),
//                             groupValue: candidateOnboardingController
//                                 .changedAnswserSelectedQuestion,
//                             onChanged: (value) {
//                               candidateOnboardingController
//                                   .changeSelectedOption(value!);
//                             },
//                           ),
//                         ),
//                         Visibility(
//                           visible: question!.option4 != null &&
//                               question!.option4.toString() != "",
//                           child: RadioListTile<String>(
//                             activeColor: AppConstants.appSecondary,
//                             title: AppConstants.isOnlineMode == true
//                                 ? FutureBuilder<String>(
//                                     future: fetchTranslation(
//                                         question!.option4.toString()),
//                                     builder: (context, snapshot) {
//                                       if (snapshot.connectionState ==
//                                           ConnectionState.waiting) {
//                                         return CustomShimmerEffect(); // Display a loading indicator while waiting for translation
//                                       } else if (snapshot.hasError) {
//                                         return Text('Error: ${snapshot.error}');
//                                       } else {
//                                         return Html(
//                                             data: snapshot.data ??
//                                                 ''); // Use the translated data when available
//                                       }
//                                     },
//                                   )
//                                 : Html(data: question!.option4.toString()),
//                             value: question!.option4.toString(),
//                             groupValue: candidateOnboardingController
//                                 .changedAnswserSelectedQuestion,
//                             onChanged: (value) {
//                               candidateOnboardingController
//                                   .changeSelectedOption(value!);
//                             },
//                           ),
//                         ),
//                         Visibility(
//                           visible: question!.option5 != null &&
//                               question!.option5.toString() != "",
//                           child: RadioListTile<String>(
//                             activeColor: AppConstants.appSecondary,
//                             title: AppConstants.isOnlineMode == true
//                                 ? FutureBuilder<String>(
//                                     future: fetchTranslation(
//                                         question!.option5.toString()),
//                                     builder: (context, snapshot) {
//                                       if (snapshot.connectionState ==
//                                           ConnectionState.waiting) {
//                                         return CustomShimmerEffect(); // Display a loading indicator while waiting for translation
//                                       } else if (snapshot.hasError) {
//                                         return Text('Error: ${snapshot.error}');
//                                       } else {
//                                         return Html(
//                                             data: snapshot.data ??
//                                                 ''); // Use the translated data when available
//                                       }
//                                     },
//                                   )
//                                 : Html(data: question!.option5.toString()),
//                             value: question!.option5.toString(),
//                             groupValue: candidateOnboardingController
//                                 .changedAnswserSelectedQuestion,
//                             onChanged: (value) {
//                               candidateOnboardingController
//                                   .changeSelectedOption(value!);
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ));
//       }),
//     );
//   }
// }
