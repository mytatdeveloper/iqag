import 'package:flutter/material.dart';
import 'package:mytat/utilities/AppConstants.dart';

class CustomIndicatorWidget extends StatelessWidget {
  final bool isDrawer;
  const CustomIndicatorWidget({super.key, this.isDrawer = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: AppConstants.paddingSmall,
              horizontal: AppConstants.paddingSmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIndicatorTile(
                circleColor: AppConstants.appSecondary,
                title: "Mark for\nReviews",
              ),
              CustomIndicatorTile(
                circleColor: AppConstants.appGreen,
                title: "Submitted\nSuccessfully",
              ),
              CustomIndicatorTile(
                circleColor:
                    isDrawer ? AppConstants.appGrey : AppConstants.appRed,
                title: isDrawer ? "Not\nAttempted" : "Not\nAnswered",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomIndicatorTile extends StatelessWidget {
  final Color circleColor;
  final String title;

  const CustomIndicatorTile(
      {super.key, required this.circleColor, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          backgroundColor: circleColor,
          radius: AppConstants.paddingExtraLarge / 2,
        ),
        SizedBox(
          height: AppConstants.paddingSmall,
        ),
        Text(
          title,
          style: const TextStyle(),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
