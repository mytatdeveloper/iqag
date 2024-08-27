import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomAppBar.dart';
import 'package:mytat/common-components/CustomCameraWidget.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/common-components/CustomLoadingIndicator.dart';
import 'package:mytat/common-components/CustomWarnigDialog.dart';
import 'package:mytat/controller/Candidate-Side-Controllers/CandidateOnboardingController.dart';
import 'package:mytat/model/StudentsBatchModel.dart';
import 'package:mytat/utilities/AppConstants.dart';

class CustomImageUploaderCandidateWidget extends StatelessWidget {
  final Batches? candidate;
  final String fileName;
  final bool isWatermarkNeeded;

  const CustomImageUploaderCandidateWidget({
    super.key,
    this.candidate,
    required this.isWatermarkNeeded,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: fileName,
      ),
      body: GetBuilder<CandidateOnboardingController>(
          builder: (candidateOnboardingController) {
        return Padding(
          padding: EdgeInsets.only(bottom: AppConstants.paddingSmall),
          child: Column(
            children: [
              Expanded(
                child: candidateOnboardingController.isFileClicked
                    ? Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(File(
                                  candidateOnboardingController
                                          .currentClickedFile ??
                                      "")),
                              fit: BoxFit.fill),
                        ),
                        width: Get.width,
                      )
                    : CameraWidget(
                        width: Get.width,
                        cameraController:
                            candidateOnboardingController.cameraController),
              ),
              !candidateOnboardingController.showSaveButton
                  ? candidateOnboardingController.isClickingPhoto
                      ? const CustomLoadingIndicator()
                      : CustomElevatedButton(
                          buttonStyle: AppConstants.commonButtonStyle,
                          onTap: () async {
                            await candidateOnboardingController.takePicture(
                                isWatermarkNeeded: isWatermarkNeeded);
                          },
                          text: "Click $fileName")
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingExtraLarge),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    textStyle: AppConstants.commonButtonStyle,
                                    primary: Colors.green),
                                onPressed: () async {
                                  Get.dialog(
                                      barrierDismissible: false,
                                      const CustomSuccessDialog(
                                          title: "Saving Photo",
                                          logo: CustomLoadingIndicator()));
                                  candidateOnboardingController
                                      .saveDocumentsToLocal(fileName);
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    Get.back();
                                    Get.back();
                                  });
                                },
                                child: Text(
                                  "Save $fileName",
                                  textAlign: TextAlign.center,
                                  style: AppConstants.titleItalic
                                      .copyWith(color: Colors.white),
                                )),
                          ),
                          SizedBox(
                            width: AppConstants.paddingExtraLarge,
                          ),
                          Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    textStyle: AppConstants.commonButtonStyle,
                                    primary: AppConstants.appSecondary),
                                onPressed: () async {
                                  candidateOnboardingController
                                      .changeShowButtonVisibility();
                                },
                                child: Text(
                                  "Upload Again",
                                  textAlign: TextAlign.center,
                                  style: AppConstants.titleItalic
                                      .copyWith(color: Colors.white),
                                )),
                          ),
                        ],
                      ),
                    )
            ],
          ),
        );
      }),
    );
  }
}
