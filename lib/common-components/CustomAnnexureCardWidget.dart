import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/common-components/CustomLoadingIndicator.dart';
import 'package:mytat/common-components/CustomSnackbar.dart';
import 'package:mytat/common-components/CustomUploadCardWidget.dart';
import 'package:mytat/common-components/CustomWarnigDialog.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/QuestionAnswersController.dart';
import 'package:mytat/controller/SplashController.dart';
import 'package:mytat/model/AssessorDocumentsModel.dart';
import 'package:mytat/model/Syncing-Models/AssessorAnnexureListUploadModel.dart';
import 'package:mytat/utilities/AppConstants.dart';

import '../model/Online-Models/ServerDateTimeModel.dart';

class CustomAnnexureCardWidget extends StatelessWidget {
  const CustomAnnexureCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TextEditingController annexureDocumentController = TextEditingController();
    return GetBuilder<QuestionAnswersController>(
      builder: (questionAnswersController) {
        return Padding(
          padding:
              EdgeInsets.symmetric(horizontal: AppConstants.paddingExtraLarge),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusMedium)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(AppConstants.paddingDefault),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadiusMedium),
                    child: questionAnswersController.currentClickedFile != null
                        ? Image.file(
                            height: 150,
                            width: 140,
                            File(questionAnswersController.currentClickedFile ??
                                ""))
                        : Icon(
                            Icons.image,
                            size: 120,
                            color: AppConstants.appGrey,
                          ),
                  ),
                  SizedBox(width: AppConstants.paddingDefault),
                  Visibility(
                    visible: questionAnswersController
                        .assessorLocalDocumentsList.isNotEmpty,
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButton<Annexurelist>(
                            isExpanded: true,
                            items: questionAnswersController
                                .assessorLocalDocumentsList
                                .map(
                              (Annexurelist option) {
                                return DropdownMenuItem<Annexurelist>(
                                  value: option,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: AppConstants.paddingSmall),
                                    child: Text(
                                      option.name ?? "",
                                      style: AppConstants.subHeading,
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                            onChanged: (Annexurelist? newValue) {
                              questionAnswersController
                                  .setAnnexureDropdownValue(newValue!);
                            },
                            value: questionAnswersController
                                .currentSelectedAnnexure,
                            hint: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: AppConstants.paddingSmall),
                              child: const Text(
                                'Select an option',
                              ),
                            ),
                            style: TextStyle(
                              fontSize: AppConstants.paddingDefault,
                            ),
                            underline: Container(),
                            elevation: 2,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            dropdownColor: Colors.white,
                          ),
                          // CustomTextField(
                          //   textController: annexureDocumentController,
                          //   lable: "Document Name",
                          //   suffixIcon: const Icon(Icons.edit),
                          // ),
                          SizedBox(height: AppConstants.paddingExtraLarge),
                          // CustomElevatedButton(
                          //   onTap: () async {
                          //     if (questionAnswersController
                          //                 .currentSelectedAnnexure !=
                          //             null &&
                          //         questionAnswersController
                          //                 .currentClickedFile !=
                          //             null) {
                          //       await Get.find<SplashController>()
                          //           .getLocation();
                          //       questionAnswersController.addToAnnexureList(
                          //           AssessorAnnexurelistUploadModel(
                          //               id: questionAnswersController
                          //                   .currentSelectedAnnexure!.id,
                          //               image: questionAnswersController
                          //                   .currentClickedFile!,
                          //               name: questionAnswersController
                          //                   .currentSelectedAnnexure!.name,
                          //               lat: AppConstants.locationInformation,
                          //               long:
                          //                   "${AppConstants.latitude}, ${AppConstants.longitude}"));
                          //       Get.dialog(
                          //           barrierDismissible: false,
                          //           const CustomSuccessDialog(
                          //               title: "Adding to Annexure List",
                          //               logo: CustomLoadingIndicator()));
                          //       await Future.delayed(const Duration(seconds: 2),
                          //           () {
                          //         Get.back();
                          //       });
                          //     } else {
                          //       await questionAnswersController
                          //           .initializeCamera(null,
                          //               isLowResolutions: false);
                          //       if (questionAnswersController
                          //               .currentSelectedAnnexure !=
                          //           null) {
                          //         Get.to(CustomImageUploaderWidget(
                          //             isAssessorClicking: true,
                          //             isAnnexure: true,
                          //             fileName: questionAnswersController
                          //                     .currentSelectedAnnexure!.name ??
                          //                 ""));
                          //       } else {
                          //         CustomSnackBar.customSnackBar(
                          //             true, "Select Document Type First");
                          //       }
                          //     }
                          //   },
                          //   text: questionAnswersController
                          //                   .currentSelectedAnnexure !=
                          //               null &&
                          //           questionAnswersController
                          //                   .currentClickedFile !=
                          //               null
                          //       ? "Save"
                          //       : "Click Photo",
                          //   width: double.infinity,
                          //   height: AppConstants.mediumButtonSized,
                          //   buttonColor: questionAnswersController
                          //                   .currentSelectedAnnexure !=
                          //               null &&
                          //           questionAnswersController
                          //                   .currentClickedFile !=
                          //               null
                          //       ? AppConstants.successGreen
                          //       : AppConstants.appSecondary,
                          // ),
                          if (questionAnswersController
                                      .currentSelectedAnnexure !=
                                  null &&
                              questionAnswersController.currentClickedFile !=
                                  null)
                            CustomElevatedButton(
                              onTap: () async {
                                if (questionAnswersController
                                            .currentSelectedAnnexure !=
                                        null &&
                                    questionAnswersController
                                            .currentClickedFile !=
                                        null) {
                                  Get.dialog(
                                      barrierDismissible: false,
                                      const CustomSuccessDialog(
                                          title: "Adding to Annexure List",
                                          logo: CustomLoadingIndicator()));
                                  await Get.find<SplashController>()
                                      .getLocation();
                                  if (AppConstants.isOnlineMode == true) {
                                    if (questionAnswersController
                                                .currentClickedFile !=
                                            null &&
                                        questionAnswersController
                                                .currentSelectedAnnexure !=
                                            null) {
                                      await Get.find<
                                              AssessorDashboardController>()
                                          .syncAssessorOneDocumentOnline(
                                              questionAnswersController
                                                  .currentSelectedAnnexure!
                                                  .name!,
                                              questionAnswersController
                                                  .currentClickedFile!);
                                      questionAnswersController
                                          .resetAnnexureDropdown();
                                    }
                                  } else {
                                    questionAnswersController.addToAnnexureList(
                                        AssessorAnnexurelistUploadModel(
                                            id: questionAnswersController
                                                .currentSelectedAnnexure!.id,
                                            image: questionAnswersController
                                                .currentClickedFile!,
                                            name: questionAnswersController
                                                .currentSelectedAnnexure!.name,
                                            lat: AppConstants
                                                .locationInformation,
                                            long:
                                                "${AppConstants.latitude}, ${AppConstants.longitude}",
                                            time:
                                                "${AppConstants.getFormatedCurrentDate(DateTime.now())}, ${AppConstants.getFormatedCurrentTime(DateTime.now())}"));
                                  }
                                  await Future.delayed(
                                      const Duration(seconds: 2), () {
                                    Get.back();
                                  });
                                }
                              },
                              buttonStyle: AppConstants.commonButtonStyle,
                              text: questionAnswersController
                                              .currentSelectedAnnexure !=
                                          null &&
                                      questionAnswersController
                                              .currentClickedFile !=
                                          null
                                  ? "Save"
                                  : "Click Photo",
                              width: double.infinity,
                              height: AppConstants.mediumButtonSized,
                              buttonColor: questionAnswersController
                                              .currentSelectedAnnexure !=
                                          null &&
                                      questionAnswersController
                                              .currentClickedFile !=
                                          null
                                  ? AppConstants.successGreen
                                  : AppConstants.appSecondary,
                            ),
                          if (questionAnswersController.currentClickedFile ==
                              null)
                            CustomElevatedButton(
                              onTap: () async {
                                if (questionAnswersController
                                        .currentSelectedAnnexure !=
                                    null) {
                                  try {
                                    Get.dialog(Dialog(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                AppConstants.paddingDefault,
                                            vertical:
                                                AppConstants.paddingDefault *
                                                    2),
                                        height: 185,
                                        width: Get.width,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Upload From",
                                              style: AppConstants.titleBold,
                                            ),
                                            SizedBox(
                                              height:
                                                  AppConstants.paddingDefault,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    Navigator.pop(
                                                        context); // Close the dialog
                                                    await questionAnswersController
                                                        .pickFile();
                                                  },
                                                  child: Container(
                                                    width: 140,
                                                    height: 90,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                      color: AppConstants
                                                          .appPrimary,
                                                    )),
                                                    child: Center(
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: AppConstants
                                                                .paddingDefault,
                                                          ),
                                                          Icon(
                                                            Icons.photo,
                                                            size: AppConstants
                                                                    .paddingExtraLarge *
                                                                2,
                                                            color: AppConstants
                                                                .appPrimary,
                                                          ),
                                                          SizedBox(
                                                            height: AppConstants
                                                                .paddingSmall,
                                                          ),
                                                          Text(
                                                            "Gallery",
                                                            style: AppConstants
                                                                .subHeadingBold
                                                                .copyWith(
                                                              color: AppConstants
                                                                  .appPrimary,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    Navigator.pop(
                                                        context); // Close the dialog
                                                    await questionAnswersController
                                                        .initializeCamera(null,
                                                            isLowResolutions:
                                                                false);

                                                    Get.to(CustomImageUploaderWidget(
                                                        isAssessorClicking:
                                                            true,
                                                        isAnnexure: true,
                                                        fileName:
                                                            questionAnswersController
                                                                    .currentSelectedAnnexure!
                                                                    .name ??
                                                                ""));
                                                  },
                                                  child: Container(
                                                    width: 140,
                                                    height: 90,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                      color: AppConstants
                                                          .appSecondary,
                                                    )),
                                                    child: Center(
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: AppConstants
                                                                .paddingDefault,
                                                          ),
                                                          Icon(
                                                              Icons
                                                                  .photo_camera_outlined,
                                                              color: AppConstants
                                                                  .appSecondary,
                                                              size: AppConstants
                                                                      .paddingExtraLarge *
                                                                  2),
                                                          SizedBox(
                                                            height: AppConstants
                                                                .paddingSmall,
                                                          ),
                                                          Text(
                                                            "Camera",
                                                            style: AppConstants
                                                                .subHeadingBold
                                                                .copyWith(
                                                              color: AppConstants
                                                                  .appSecondary,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                                    // showDialog(
                                    //   context: Get.context!,
                                    //   builder: (BuildContext context) {
                                    //     return
                                    //     AlertDialog(
                                    //       title: Center(
                                    //         child: Text(
                                    //           "Upload From",
                                    //           style: AppConstants.titleBold,
                                    //         ),
                                    //       ),
                                    //       actionsAlignment:
                                    //           MainAxisAlignment.center,
                                    //       actions: <Widget>[
                                    //         TextButton(
                                    //             onPressed: () async {
                                    //               Navigator.pop(
                                    //                   context); // Close the dialog
                                    //               await questionAnswersController
                                    //                   .pickFile();
                                    //             },
                                    //             child: Column(
                                    //               children: [
                                    //                 Icon(
                                    //                   Icons
                                    //                       .photo_album_outlined,
                                    //                   size: AppConstants
                                    //                           .paddingExtraLarge *
                                    //                       2,
                                    //                   color:
                                    //                       AppConstants.appBlack,
                                    //                 ),
                                    //                 Text(
                                    //                   "Gallery",
                                    //                   style: AppConstants
                                    //                       .subHeadingBold,
                                    //                 ),
                                    //               ],
                                    //             )),
                                    //         TextButton(
                                    //             onPressed: () async {
                                    //               Navigator.pop(
                                    //                   context); // Close the dialog
                                    //               await questionAnswersController
                                    //                   .initializeCamera(null,
                                    //                       isLowResolutions:
                                    //                           false);

                                    //               Get.to(CustomImageUploaderWidget(
                                    //                   isAssessorClicking: true,
                                    //                   isAnnexure: true,
                                    //                   fileName:
                                    //                       questionAnswersController
                                    //                               .currentSelectedAnnexure!
                                    //                               .name ??
                                    //                           ""));
                                    //             },
                                    //             child: Column(
                                    //               children: [
                                    //                 Icon(
                                    //                   Icons
                                    //                       .photo_camera_outlined,
                                    //                   size: AppConstants
                                    //                           .paddingExtraLarge *
                                    //                       2,
                                    //                   color:
                                    //                       AppConstants.appBlack,
                                    //                 ),
                                    //                 Text(
                                    //                   "Camera",
                                    //                   style: AppConstants
                                    //                       .subHeadingBold,
                                    //                 ),
                                    //               ],
                                    //             )),
                                    //       ],
                                    //     );
                                    //   },
                                    // );
                                  } catch (e) {
                                    print('Error picking document: $e');
                                    // CustomSnackBar.customSnackBar(false, "Failed to Upload the Image!");
                                  }
                                } else {
                                  CustomSnackBar.customSnackBar(
                                      true, "Select Document Type First");
                                }
                              },
                              buttonStyle: AppConstants.commonButtonStyle,
                              text: "Click Photo",
                              width: double.infinity,
                              height: AppConstants.mediumButtonSized,
                              buttonColor: questionAnswersController
                                              .currentSelectedAnnexure !=
                                          null &&
                                      questionAnswersController
                                              .currentClickedFile !=
                                          null
                                  ? AppConstants.successGreen
                                  : AppConstants.appSecondary,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
