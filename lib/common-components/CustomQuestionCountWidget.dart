import 'package:flutter/material.dart';
import 'package:mytat/utilities/AppConstants.dart';

class CustomQuestionCountWidget extends StatelessWidget {
  final int totalQuestions;
  final int questionsAttempted;
  final int markForReview;
  final int notAttempted;

  const CustomQuestionCountWidget(
      {super.key,
      required this.markForReview,
      required this.questionsAttempted,
      required this.totalQuestions,
      required this.notAttempted});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.paddingDefault),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Questions: "),
                Text(
                  totalQuestions.toString(),
                  style: AppConstants.subHeading
                      .copyWith(color: AppConstants.appBlack),
                ),
              ],
            ),
            SizedBox(
              height: AppConstants.paddingSmall,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Attempted Questions:"),
                Text(
                  questionsAttempted.toString(),
                  style: AppConstants.subHeading
                      .copyWith(color: AppConstants.appGreen),
                ),
              ],
            ),
            SizedBox(
              height: AppConstants.paddingSmall,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Questions Mark for Review"),
                Text(
                  markForReview.toString(),
                  style: AppConstants.subHeading
                      .copyWith(color: AppConstants.appSecondary),
                ),
              ],
            ),
            SizedBox(
              height: AppConstants.paddingSmall,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Not Attempted"),
                Text(
                  notAttempted.toString(),
                  style: AppConstants.subHeading
                      .copyWith(color: AppConstants.appRed),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
