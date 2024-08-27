import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mytat/utilities/AppConstants.dart';

class CustomStepper extends StatelessWidget {
  final int currentStep;
  final List<String> instructions;
  final Color stepColor;
  final Color textColor;

  const CustomStepper({
    super.key,
    required this.currentStep,
    required this.instructions,
    this.stepColor = Colors.blue,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: instructions.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final stepNumber = index + 1;

        return Row(
          children: [
            // Container(
            //   width: 30,
            //   height: 30,
            //   decoration: BoxDecoration(
            //     color: stepColor,
            //     shape: BoxShape.circle,
            //   ),
            //   alignment: Alignment.center,
            //   child: Text(
            //     stepNumber.toString(),
            //     style: TextStyle(
            //       color: textColor,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            // SizedBox(width: AppConstants.paddingLarge),
            // SizedBox(
            //   height: AppConstants.paddingExtraLarge,
            // ),
            Expanded(
              child: Container(
                margin:
                    EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
                padding: EdgeInsets.symmetric(
                  vertical: AppConstants.paddingSmall,
                  // horizontal: AppConstants.paddingSmall * 2
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffe6f3ff),
                  // AppConstants.appPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Html(
                  data: instructions[index],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
