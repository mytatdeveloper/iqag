import 'package:flutter/material.dart';
import 'package:mytat/common-components/CustomAnimatedIconWidget.dart';
import 'package:mytat/utilities/AppConstants.dart';

class CustomNoDataScreen extends StatelessWidget {
  final String? title;
  final Widget? childWidget;
  const CustomNoDataScreen({super.key, this.childWidget, this.title});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title ?? "No Records Found",
              style: AppConstants.titleBold,
            ),
            SizedBox(
              height: AppConstants.paddingLarge,
            ),
            childWidget ??
                CustomAnimatedIconWidget(
                    icon: const Icon(Icons.no_accounts),
                    animationType: AnimationType.Color,
                    iconSize: AppConstants.paddingExtraLarge),
          ],
        ),
      ),
    );
  }
}
