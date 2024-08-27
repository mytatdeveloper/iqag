import 'package:flutter/material.dart';
import 'package:mytat/utilities/AppConstants.dart';

class CustomStatusIndicator extends StatelessWidget {
  final Widget lable;
  final bool isCompleted;

  const CustomStatusIndicator(
      {super.key, required this.lable, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            left: AppConstants.paddingSmall, top: AppConstants.paddingSmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                lable,
                Icon(
                  isCompleted ? Icons.check : Icons.close,
                  color:
                      isCompleted ? AppConstants.appGreen : AppConstants.appRed,
                )
              ],
            ),
            const Icon(Icons.arrow_forward_ios_sharp)
          ],
        ));
  }
}
