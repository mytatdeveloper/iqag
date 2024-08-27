import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/controller/Candidate-Side-Controllers/CandidateOnboardingController.dart';
import 'package:mytat/model/AssessmentAllLanguagesListModel.dart';
import 'package:mytat/model/LanguageModel.dart';
import 'package:mytat/utilities/AppConstants.dart';

class CustomDropdownMenu extends StatelessWidget {
  const CustomDropdownMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 1,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppConstants.appGrey, width: 2),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
      ),
      child: GetBuilder<CandidateOnboardingController>(
          builder: (candidateOnboardingController) {
        return DropdownButtonHideUnderline(
          child: DropdownButton<Languages>(
            value: candidateOnboardingController.selectedLanguage,
            hint: const Text('Select Language', style: TextStyle()),
            onChanged: (newValue) {
              candidateOnboardingController.selectLanguage(newValue);
            },
            items: candidateOnboardingController.languagesList
                .map<DropdownMenuItem<Languages>>((Languages value) {
              return DropdownMenuItem<Languages>(
                value: value,
                child: Text(
                  value.langName ?? "",
                  style: TextStyle(color: AppConstants.appPrimary),
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }
}

class CustomVernacularDropdownMenu extends StatelessWidget {
  const CustomVernacularDropdownMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 1,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppConstants.appGrey, width: 2),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
      ),
      child: GetBuilder<CandidateOnboardingController>(
          builder: (candidateOnboardingController) {
        return DropdownButtonHideUnderline(
          child: DropdownButton<AssessmentAvailableLanguageModel>(
            value: candidateOnboardingController.selectedVernacularLanguage,
            hint: const Text('Select Language', style: TextStyle()),
            onChanged: (newValue) {
              candidateOnboardingController
                  .changeQuestionVernacularLanguage(newValue!);
            },
            items: candidateOnboardingController
                .availableTheoryPaperLanguageList
                .map<DropdownMenuItem<AssessmentAvailableLanguageModel>>(
                    (AssessmentAvailableLanguageModel value) {
              return DropdownMenuItem<AssessmentAvailableLanguageModel>(
                value: value,
                child: Text(
                  value.name ?? "",
                  style: TextStyle(color: AppConstants.appPrimary),
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }
}
