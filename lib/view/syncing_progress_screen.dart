import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/Candidate-Side-Controllers/CandidateOnboardingController.dart';
import 'package:mytat/utilities/AppConstants.dart';

class SyncingInProgressScreen extends StatelessWidget {
  final String? syncingTitle;
  const SyncingInProgressScreen({super.key, this.syncingTitle});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: AppConstants.appBackground,
        height: Get.height,
        width: Get.width,
        child: Padding(
          padding: EdgeInsets.all(AppConstants.paddingExtraLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // CustomAnimatedIconWidget(
              //   icon: Icon(
              //     Icons.refresh,
              //     size: AppConstants.fontExtraLarge * 4,
              //     color: AppConstants.appPrimary,
              //   ),
              //   playAutomatically: true,
              //   animationType: AnimationType.Rotate,
              //   iconSize: 100,
              // ),
              GetBuilder<AssessorDashboardController>(
                  builder: (assessorDashboardController) {
                return Column(
                  children: [
                    Visibility(
                      visible: assessorDashboardController.syncingTitle != "",
                      child: Text(
                          "Syncing ${assessorDashboardController.syncingTitle}"),
                    ),
                    SizedBox(
                      height: AppConstants.paddingDefault,
                    ),
                    Visibility(
                        visible:
                            assessorDashboardController.uploadProgress != 0.0,
                        child: SizedBox(
                          width: Get.width * 0.75,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusCircular),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                LinearProgressIndicator(
                                  color: AppConstants.appGrey,
                                  backgroundColor: AppConstants.appGrey,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppConstants.appSecondary),
                                  minHeight: AppConstants.fontLarge * 1.5,
                                  value: assessorDashboardController
                                      .uploadProgress,
                                ),
                                Text(
                                  '${(assessorDashboardController.uploadProgress * 100).toStringAsFixed(1)}%',
                                  style: AppConstants.bodyBold.copyWith(
                                      color: Colors
                                          .white), // Customize the text style
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                );
              }),
              GetBuilder<CandidateOnboardingController>(
                  builder: (candidateOnboardingController) {
                return Column(
                  children: [
                    Visibility(
                      visible: candidateOnboardingController.syncingTitle != "",
                      child: Text(
                          "Syncing ${candidateOnboardingController.syncingTitle}"),
                    ),
                    SizedBox(
                      height: AppConstants.paddingDefault,
                    ),
                    Visibility(
                        visible:
                            candidateOnboardingController.uploadProgress != 0.0,
                        child: SizedBox(
                          width: Get.width * 0.75,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusCircular),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                LinearProgressIndicator(
                                  color: AppConstants.appGrey,
                                  backgroundColor: AppConstants.appGrey,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppConstants.appSecondary),
                                  minHeight: AppConstants.fontLarge * 1.5,
                                  value: candidateOnboardingController
                                      .uploadProgress,
                                ),
                                Text(
                                  '${(candidateOnboardingController.uploadProgress * 100).toStringAsFixed(1)}%',
                                  style: AppConstants.bodyBold.copyWith(
                                      color: Colors
                                          .white), // Customize the text style
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                );
              }),
              SizedBox(
                height: AppConstants.paddingDefault,
              ),
              Text(
                "${syncingTitle ?? ""} Syncing\nin Progress...",
                style: AppConstants.titleItalic,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
