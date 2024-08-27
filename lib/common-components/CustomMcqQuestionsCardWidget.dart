import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
// import 'package:mytat/common-components/CustomFutureImageBuilder.dart';
import 'package:mytat/controller/Candidate-Side-Controllers/CandidateOnboardingController.dart';
import 'package:mytat/utilities/AppConstants.dart';

class CustomMcqOptionWidget extends StatelessWidget {
  final List<String> optionList;
  final List<String> optionImages;
  final bool isFromSummary;

  const CustomMcqOptionWidget(
      {super.key,
      required this.optionList,
      required this.optionImages,
      required this.isFromSummary});

  @override
  Widget build(BuildContext context) {
    CandidateOnboardingController candidateOnboardingController =
        Get.find<CandidateOnboardingController>();

    return Padding(
      padding: EdgeInsets.all(AppConstants.paddingSmall),
      child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: optionList.length,
          itemBuilder: ((context, index) {
            if (optionList[index] == "null" || optionList[index] == "") {
              return optionImages[index] == "null" || optionImages[index] == ""
                  ? const SizedBox.shrink()
                  : GestureDetector(
                      onTap: () {
                        if (isFromSummary == true) {
                          candidateOnboardingController
                              .changeIfAnswerChanged(true);
                          candidateOnboardingController
                              .changeIfSummaryAnswerChanged(true);
                        }
                        candidateOnboardingController.setSelectedOption(
                            "${index == 0 ? "A" : index == 1 ? "B" : index == 2 ? "C" : index == 3 ? "D" : "E"}${optionImages[index]}",
                            index);
                        candidateOnboardingController.changeAnswer();
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: AppConstants.paddingDefault),
                        child: Container(
                          color: AppConstants.theoryBg,
                          child: Row(
                            children: [
                              Text(
                                index == 0
                                    ? "A"
                                    : index == 1
                                        ? "B"
                                        : index == 2
                                            ? "C"
                                            : index == 3
                                                ? "D"
                                                : "E",
                                style: AppConstants.subHeadingBold,
                              ),
                              SizedBox(
                                width: AppConstants.paddingDefault,
                              ),
                              Transform.scale(
                                scale: 1.1,
                                child: Radio<String?>(
                                  splashRadius: 0,
                                  visualDensity: const VisualDensity(
                                    horizontal: VisualDensity.minimumDensity,
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  value:
                                      ("${index == 0 ? "A" : index == 1 ? "B" : index == 2 ? "C" : index == 3 ? "D" : "E"}${optionImages[index]}"),
                                  groupValue: candidateOnboardingController
                                      .currentSelectedAnswer,
                                  onChanged: (value) {
                                    if (isFromSummary == true) {
                                      candidateOnboardingController
                                          .changeIfAnswerChanged(true);
                                      candidateOnboardingController
                                          .changeIfSummaryAnswerChanged(true);
                                    }
                                    candidateOnboardingController
                                        .setSelectedOption(value!, index);
                                    candidateOnboardingController
                                        .changeAnswer();
                                  },
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (isFromSummary == true) {
                                    candidateOnboardingController
                                        .changeIfAnswerChanged(true);
                                    candidateOnboardingController
                                        .changeIfSummaryAnswerChanged(true);
                                  }
                                  candidateOnboardingController.setSelectedOption(
                                      "${index == 0 ? "A" : index == 1 ? "B" : index == 2 ? "C" : index == 3 ? "D" : "E"}${optionImages[index]}",
                                      index);
                                  candidateOnboardingController.changeAnswer();
                                  candidateOnboardingController
                                      .showDefaultDialogUsingData(
                                          AppConstants.base64ToBytes(
                                              optionImages[index].toString()));
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: AppConstants.paddingDefault),
                                  child: Image.memory(
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.fill,
                                      AppConstants.base64ToBytes(
                                          optionImages[index].toString())),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
            }
            return GestureDetector(
              onTap: () {
                if (isFromSummary == true) {
                  candidateOnboardingController.changeIfAnswerChanged(true);
                  candidateOnboardingController
                      .changeIfSummaryAnswerChanged(true);
                }
                candidateOnboardingController.setSelectedOption(
                    optionList[index], index);
                candidateOnboardingController.changeAnswer();
              },
              child: Container(
                color: AppConstants.theoryBg,
                child: Row(
                  children: [
                    Text(
                      index == 0
                          ? "A"
                          : index == 1
                              ? "B"
                              : index == 2
                                  ? "C"
                                  : index == 3
                                      ? "D"
                                      : "E",
                      style: AppConstants.subHeadingBold,
                    ),
                    SizedBox(
                      width: AppConstants.paddingDefault,
                    ),
                    Transform.scale(
                      scale: 1.1,
                      child: Radio<String?>(
                        splashRadius: 0,
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: (optionList[index]),
                        groupValue:
                            candidateOnboardingController.currentSelectedAnswer,
                        onChanged: (value) {
                          if (isFromSummary == true) {
                            candidateOnboardingController
                                .changeIfAnswerChanged(true);
                            candidateOnboardingController
                                .changeIfSummaryAnswerChanged(true);
                          }
                          candidateOnboardingController.setSelectedOption(
                              value!, index);
                          candidateOnboardingController.changeAnswer();
                        },
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Html(
                            data: optionList[index],
                            style: {
                              "body": Style(
                                  // margin: EdgeInsets.zero,
                                  fontSize: FontSize(
                                      candidateOnboardingController.fontSize),
                                  // fontWeight: FontWeight.normal,
                                  lineHeight: LineHeight.number(1))
                            },
                          ),
                          // Extra language code here
                          if (candidateOnboardingController.selectedVernacularLanguage!.id.toString() != "-1" &&
                              candidateOnboardingController.getSelectedVernacularLanguageOption(
                                      candidateOnboardingController
                                          .selectedVernacularLanguage!.id
                                          .toString(),
                                      candidateOnboardingController
                                          .currentMcqQuestion!.id
                                          .toString(),
                                      index) !=
                                  null &&
                              candidateOnboardingController.getSelectedVernacularLanguageOption(
                                      candidateOnboardingController
                                          .selectedVernacularLanguage!.id
                                          .toString(),
                                      candidateOnboardingController
                                          .currentMcqQuestion!.id
                                          .toString(),
                                      index) !=
                                  "")
                            Html(
                                style: {
                                  "body": Style(
                                      // margin: EdgeInsets.zero,
                                      fontSize: FontSize(
                                          candidateOnboardingController
                                              .fontSize),
                                      // fontWeight: FontWeight.normal,
                                      lineHeight: LineHeight.number(1))
                                },
                                data: candidateOnboardingController
                                        .getSelectedVernacularLanguageOption(
                                            candidateOnboardingController
                                                .selectedVernacularLanguage!.id
                                                .toString(),
                                            candidateOnboardingController.currentMcqQuestion!.id.toString(),
                                            index) ??
                                    ""),
                          // Extra language code here
                          if (optionImages[index] != "" &&
                              optionImages[index] != "null")
                            GestureDetector(
                              onTap: () {
                                if (isFromSummary == true) {
                                  candidateOnboardingController
                                      .changeIfAnswerChanged(true);
                                  candidateOnboardingController
                                      .changeIfSummaryAnswerChanged(true);
                                }
                                candidateOnboardingController.setSelectedOption(
                                    optionList[index], index);
                                candidateOnboardingController.changeAnswer();

                                candidateOnboardingController
                                    .showDefaultDialogUsingData(
                                        AppConstants.base64ToBytes(
                                            optionImages[index].toString()));
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: AppConstants.paddingDefault),
                                child: Image.memory(
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.fill,
                                    AppConstants.base64ToBytes(
                                        optionImages[index].toString())),
                              ),
                            ),

                          // Padding(
                          //   padding: EdgeInsets.only(
                          //       left: AppConstants.paddingDefault),
                          //   child: Image.memory(
                          //       height: 80,
                          //       width: 80,
                          //       fit: BoxFit.fill,
                          //       AppConstants.base64ToBytes(
                          //           optionImages[index].toString())),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          })),
    );
  }
}
