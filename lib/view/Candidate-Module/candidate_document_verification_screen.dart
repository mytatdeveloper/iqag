import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomAppBar.dart';
import 'package:mytat/common-components/CustomCardDataWidget.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/common-components/CustomLoadingIndicator.dart';
import 'package:mytat/common-components/CustomSnackbar.dart';
import 'package:mytat/common-components/CustomUploadCardCandidateWidget.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/Candidate-Side-Controllers/CandidateOnboardingController.dart';
import 'package:mytat/controller/SplashController.dart';
import 'package:mytat/model/CandidateSubmitDocumentsModel.dart';
import 'package:mytat/model/StudentsBatchModel.dart';
import 'package:mytat/services/db_helper.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:mytat/utilities/ImageUrls.dart';
import 'package:mytat/view/Authorization/login_screen.dart';
import 'package:mytat/view/Candidate-Module/candidate_instruction_screen.dart';

class CandidateDocumentVerificationScreen extends StatelessWidget {
  final Batches candidate;
  final String enrollmentNumber;

  const CandidateDocumentVerificationScreen(
      {super.key, required this.candidate, required this.enrollmentNumber});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: AppConstants.appBackground,
        appBar: CustomAppBar(
            title: "Student Authentication",
            icon: const Icon(Icons.arrow_back),
            onpressed: () {
              Get.find<CandidateOnboardingController>()
                  .clearCandidateDocuments();
              Get.offAll(LoginScreen(
                  userType: "candidate",
                  isOnline: AppConstants.isOnlineMode == true));
            }),
        body: GetBuilder<CandidateOnboardingController>(
            builder: (candidateOnboardingController) {
          return Padding(
            padding: EdgeInsets.all(AppConstants.paddingExtraLarge),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Candidate Name: ${candidate.name}",
                    style: AppConstants.titleItalic,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: AppConstants.paddingSmall,
                  ),
                  Text(
                    "Candidate ID: $enrollmentNumber",
                    style: AppConstants.titleItalic,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: AppConstants.paddingExtraLarge,
                  ),
                  // Candidate Profile Card here
                  Card(
                    color: candidateOnboardingController
                                .currentCandidateProfilePhoto !=
                            null
                        ? AppConstants.successGreen.withOpacity(0.8)
                        : AppConstants.appRed.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(
                              AppConstants.borderRadiusCircular),
                          bottomLeft: Radius.circular(
                              AppConstants.borderRadiusCircular)),
                    ),
                    margin: EdgeInsets.only(
                        bottom: AppConstants.paddingExtraLarge * 2),
                    child: InkWell(
                      onTap: () async {
                        await candidateOnboardingController.initializeCamera(1);
                        Get.to(CustomImageUploaderCandidateWidget(
                            isWatermarkNeeded:
                                candidateOnboardingController.accessLocation ==
                                    "Y",
                            candidate: candidate,
                            fileName: "Profile Photo"));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(
                                    AppConstants.borderRadiusCircular),
                                bottomLeft: Radius.circular(
                                    AppConstants.borderRadiusCircular)),
                            child: candidateOnboardingController
                                        .currentCandidateProfilePhoto !=
                                    null
                                ? Image.file(
                                    File(candidateOnboardingController
                                            .currentCandidateProfilePhoto ??
                                        ""),
                                    height: Get.height * 0.2,
                                    width: Get.width * 0.5,
                                    fit: BoxFit.fill,
                                  )
                                : Image.asset(
                                    ImageUrls.placeholderImage,
                                    height: Get.height * 0.2,
                                    width: Get.width * 0.5,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                          SizedBox(
                            width: AppConstants.paddingExtraLarge,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Profile Photo",
                                style: AppConstants.titleBold,
                              ),
                              Chip(
                                backgroundColor: candidateOnboardingController
                                            .currentCandidateProfilePhoto !=
                                        null
                                    ? AppConstants.successGreen.withOpacity(0.2)
                                    : AppConstants.appRed.withOpacity(0.2),
                                avatar: Icon(
                                  candidateOnboardingController
                                              .currentCandidateProfilePhoto !=
                                          null
                                      ? Icons.check
                                      : Icons.camera_alt,
                                  color: candidateOnboardingController
                                              .currentCandidateProfilePhoto !=
                                          null
                                      ? AppConstants.successGreen
                                      : AppConstants.appRed,
                                ),
                                label: Text(
                                    candidateOnboardingController
                                                .currentCandidateProfilePhoto !=
                                            null
                                        ? "Uploaded"
                                        : "Click Image",
                                    style: AppConstants.bodyItalic),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Candidate Profile Card here
                  Card(
                    color: candidateOnboardingController
                                .currentCandidateAdharFrontPic !=
                            null
                        ? AppConstants.successGreen.withOpacity(0.8)
                        : AppConstants.appRed.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(
                              AppConstants.borderRadiusCircular),
                          bottomLeft: Radius.circular(
                              AppConstants.borderRadiusCircular)),
                    ),
                    margin: EdgeInsets.only(
                        bottom: AppConstants.paddingExtraLarge * 2),
                    child: InkWell(
                      onTap: () async {
                        await candidateOnboardingController.initializeCamera(0);
                        Get.to(CustomImageUploaderCandidateWidget(
                            isWatermarkNeeded:
                                candidateOnboardingController.accessLocation ==
                                    "Y",
                            candidate: candidate,
                            fileName: "Aadhar Front"));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(
                                    AppConstants.borderRadiusCircular),
                                bottomLeft: Radius.circular(
                                    AppConstants.borderRadiusCircular)),
                            child: candidateOnboardingController
                                        .currentCandidateAdharFrontPic !=
                                    null
                                ? Image.file(
                                    File(candidateOnboardingController
                                            .currentCandidateAdharFrontPic ??
                                        ""),
                                    height: Get.height * 0.2,
                                    width: Get.width * 0.5,
                                    fit: BoxFit.fill,
                                  )
                                : Image.asset(
                                    ImageUrls.placeholderImage,
                                    height: Get.height * 0.2,
                                    width: Get.width * 0.5,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                          SizedBox(
                            width: AppConstants.paddingExtraLarge,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Aadhar Front",
                                style: AppConstants.titleBold,
                              ),
                              Chip(
                                backgroundColor: candidateOnboardingController
                                            .currentCandidateAdharFrontPic !=
                                        null
                                    ? AppConstants.successGreen.withOpacity(0.2)
                                    : AppConstants.appRed.withOpacity(0.2),
                                avatar: Icon(
                                  candidateOnboardingController
                                              .currentCandidateAdharFrontPic !=
                                          null
                                      ? Icons.check
                                      : Icons.camera_alt,
                                  color: candidateOnboardingController
                                              .currentCandidateAdharFrontPic !=
                                          null
                                      ? AppConstants.successGreen
                                      : AppConstants.appRed,
                                ),
                                label: Text(
                                    candidateOnboardingController
                                                .currentCandidateAdharFrontPic !=
                                            null
                                        ? "Uploaded"
                                        : "Click Image",
                                    style: AppConstants.bodyItalic),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Candidate Profile Card here
                  // Card(
                  //   color: candidateOnboardingController
                  //               .currentCandidateAdharBackPic !=
                  //           null
                  //       ? AppConstants.successGreen.withOpacity(0.8)
                  //       : AppConstants.appRed.withOpacity(0.5),
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.only(
                  //         topRight: Radius.circular(
                  //             AppConstants.borderRadiusCircular),
                  //         bottomLeft: Radius.circular(
                  //             AppConstants.borderRadiusCircular)),
                  //   ),
                  //   margin: EdgeInsets.only(
                  //       bottom: AppConstants.paddingExtraLarge * 2),
                  //   child: InkWell(
                  //     onTap: () async {
                  //       await candidateOnboardingController.initializeCamera(0);
                  //       Get.to(CustomImageUploaderCandidateWidget(
                  //           candidate: candidate, fileName: "Aadhar Back"));
                  //     },
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       children: [
                  //         ClipRRect(
                  //           borderRadius: BorderRadius.only(
                  //               topRight: Radius.circular(
                  //                   AppConstants.borderRadiusCircular),
                  //               bottomLeft: Radius.circular(
                  //                   AppConstants.borderRadiusCircular)),
                  //           child: candidateOnboardingController
                  //                       .currentCandidateAdharBackPic !=
                  //                   null
                  //               ? Image.file(
                  //                   File(candidateOnboardingController
                  //                           .currentCandidateAdharBackPic ??
                  //                       ""),
                  //                   height: Get.height * 0.2,
                  //                   width: Get.width * 0.5,
                  //                   fit: BoxFit.fill,
                  //                 )
                  //               : Image.asset(
                  //                   ImageUrls.placeholderImage,
                  //                   height: Get.height * 0.2,
                  //                   width: Get.width * 0.5,
                  //                   fit: BoxFit.fill,
                  //                 ),
                  //         ),
                  //         SizedBox(
                  //           width: AppConstants.paddingExtraLarge,
                  //         ),
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Text(
                  //               "Aadhar Back",
                  //               style: AppConstants.titleBold,
                  //             ),
                  //             Chip(
                  //               backgroundColor: candidateOnboardingController
                  //                           .currentCandidateAdharBackPic !=
                  //                       null
                  //                   ? AppConstants.successGreen.withOpacity(0.2)
                  //                   : AppConstants.appRed.withOpacity(0.2),
                  //               avatar: Icon(
                  //                 candidateOnboardingController
                  //                             .currentCandidateAdharBackPic !=
                  //                         null
                  //                     ? Icons.check
                  //                     : Icons.camera_alt,
                  //                 color: candidateOnboardingController
                  //                             .currentCandidateAdharBackPic !=
                  //                         null
                  //                     ? AppConstants.successGreen
                  //                     : AppConstants.appRed,
                  //               ),
                  //               label: Text(
                  //                   candidateOnboardingController
                  //                               .currentCandidateAdharBackPic !=
                  //                           null
                  //                       ? "Uploaded"
                  //                       : "Click Image",
                  //                   style: AppConstants.bodyItalic),
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  candidateOnboardingController.isLoadingOnline == true
                      ? const CustomLoadingIndicator()
                      : CustomElevatedButton(
                          onTap: () async {
                            if (
                                // candidateOnboardingController
                                //           .currentCandidateAdharBackPic !=
                                //       null &&
                                candidateOnboardingController
                                            .currentCandidateAdharFrontPic !=
                                        null &&
                                    candidateOnboardingController
                                            .currentCandidateProfilePhoto !=
                                        null) {
                              candidateOnboardingController
                                  .changeIsLoadingOnline(true);
                              Get.back();
                              await Get.find<SplashController>().getLocation();
                              // getting languages
                              // if (AppConstants.isOnlineMode == true) {
                              //   await Get.find<CandidateOnboardingController>()
                              //       .getAllLanguages();
                              // }

                              // Trendsetters Changes
                              // if (candidateOnboardingController
                              //         .vernacularLanguage ==
                              //     "Y") {
                              await Get.find<CandidateOnboardingController>()
                                  .getAllAvailableLanguagesForMcq();
                              // }
                              // Trendsetters Changes

                              await DatabaseHelper()
                                  .insertCandidateSubmittedDocuments(
                                      CandidateSubmitDocumentsModel(
                                          type: "T",
                                          candidateAadharBack:
                                              candidateOnboardingController
                                                      .currentCandidateAdharBackPic ??
                                                  "NA",
                                          candidateAadharFront:
                                              candidateOnboardingController
                                                  .currentCandidateAdharFrontPic,
                                          candidateId: candidate.id,
                                          candidateProfile:
                                              candidateOnboardingController
                                                  .currentCandidateProfilePhoto,
                                          latitude:
                                              AppConstants.locationInformation,
                                          longitude:
                                              "${AppConstants.latitude}, ${AppConstants.longitude}"));
                              candidateOnboardingController
                                  .clearCandidateDocuments();
                              // Online Mode New Changes
                              if (AppConstants.isOnlineMode == true) {
                                await Get.find<AssessorDashboardController>()
                                    .syncOneCandidateDocumentsOnRunTime(
                                        candidate);
                              }
                              // Online Mode New Changes

                              candidateOnboardingController
                                  .changeIsLoadingOnline(false);
                              Get.to(CandidateInstructionScreen(
                                candidate: candidate,
                              ));
                              CustomSnackBar.customSnackBar(true,
                                  "${candidate.name} Docuements Submitted Successfully");
                              candidateOnboardingController
                                  .changeIsLoadingOnline(false);

                              // Get.dialog(
                              //   Dialog(
                              //     child: Container(
                              //       padding: EdgeInsets.all(
                              //           AppConstants.paddingDefault),
                              //       height: 250,
                              //       child: Column(
                              //         children: [
                              //           Text(
                              //             "Candidate Details",
                              //             style: AppConstants.titleBold,
                              //           ),
                              //           SizedBox(
                              //             height:
                              //                 AppConstants.paddingDefault * 2,
                              //           ),
                              //           CustomDataCardWidget(
                              //             count: candidate.name.toString(),
                              //             title: "Candidate Name:",
                              //           ),
                              //           const Divider(),
                              //           CustomDataCardWidget(
                              //             count: candidate.assmentId.toString(),
                              //             title: "Assessment Id:",
                              //           ),
                              //           const Divider(),
                              //           CustomDataCardWidget(
                              //             count: enrollmentNumber.toString(),
                              //             title: "Enrollment No:",
                              //           ),
                              //           SizedBox(
                              //             height:
                              //                 AppConstants.paddingDefault * 3,
                              //           ),
                              //           Row(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.center,
                              //             children: [
                              //               CustomElevatedButton(
                              //                   height: 30,
                              //                   buttonColor:
                              //                       AppConstants.appRed,
                              //                   width: Get.width * 0.35,
                              //                   onTap: () {
                              //                     candidateOnboardingController
                              //                         .clearCandidateDocuments();
                              //                     Get.offAll(LoginScreen(
                              //                         userType: "candidate",
                              //                         isOnline: AppConstants
                              //                                 .isOnlineMode ==
                              //                             true));
                              //                   },
                              //                   text: "Reset"),
                              //               CustomElevatedButton(
                              //                   height: 30,
                              //                   buttonColor: Colors.green,
                              //                   width: Get.width * 0.35,
                              //                   onTap: () async {
                              //                     candidateOnboardingController
                              //                         .changeIsLoadingOnline(
                              //                             true);
                              //                     Get.back();
                              //                     await Get.find<
                              //                             SplashController>()
                              //                         .getLocation();
                              //                     // getting languages
                              //                     // if (AppConstants.isOnlineMode == true) {
                              //                     //   await Get.find<CandidateOnboardingController>()
                              //                     //       .getAllLanguages();
                              //                     // }
                              //                     // Trendsetters Changes
                              //                     // if (candidateOnboardingController
                              //                     //         .vernacularLanguage ==
                              //                     //     "Y") {
                              //                     await Get.find<
                              //                             CandidateOnboardingController>()
                              //                         .getAllAvailableLanguagesForMcq();
                              //                     // }
                              //                     // Trendsetters Changes
                              //                     await DatabaseHelper().insertCandidateSubmittedDocuments(CandidateSubmitDocumentsModel(
                              //                         candidateAadharBack:
                              //                             candidateOnboardingController
                              //                                     .currentCandidateAdharBackPic ??
                              //                                 "NA",
                              //                         candidateAadharFront:
                              //                             candidateOnboardingController
                              //                                 .currentCandidateAdharFrontPic,
                              //                         candidateId: candidate.id,
                              //                         candidateProfile:
                              //                             candidateOnboardingController
                              //                                 .currentCandidateProfilePhoto,
                              //                         latitude: AppConstants
                              //                             .locationInformation,
                              //                         longitude:
                              //                             "${AppConstants.latitude}, ${AppConstants.longitude}"));
                              //                     candidateOnboardingController
                              //                         .clearCandidateDocuments();
                              //                     candidateOnboardingController
                              //                         .changeIsLoadingOnline(
                              //                             false);
                              //                     Get.to(
                              //                         CandidateInstructionScreen(
                              //                       candidate: candidate,
                              //                     ));
                              //                     CustomSnackBar.customSnackBar(
                              //                         true,
                              //                         "${candidate.name} Docuements Submitted Successfully");
                              //                     candidateOnboardingController
                              //                         .changeIsLoadingOnline(
                              //                             false);
                              //                   },
                              //                   text: "OK")
                              //             ],
                              //           )
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              //   barrierDismissible: false,
                              // );
                            } else {
                              CustomSnackBar.customSnackBar(true,
                                  "All Documents Submission are mandatory");
                            }
                          },
                          text: "Submit Documents")
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
