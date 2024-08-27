import 'package:flutter/material.dart';
import 'package:mytat/common-components/CustomAnimatedIconWidget.dart';
import 'package:mytat/utilities/AppConstants.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAnimatedIconWidget(
        icon: Icon(
          Icons.sync,
          color: AppConstants.appPrimary,
          size: AppConstants.paddingExtraLarge * 2,
        ),
        animationType: AnimationType.Rotate,
        iconSize: AppConstants.paddingExtraLarge);
  }
}
