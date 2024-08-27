import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/utilities/AppConstants.dart';

class CustomWarningDialog extends StatelessWidget {
  final String title;
  final VoidCallback? onPress;
  final bool showCancel;
  final double? bottomSpacing;

  const CustomWarningDialog(
      {super.key,
      required this.title,
      this.onPress,
      this.showCancel = true,
      this.bottomSpacing});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge)),
      title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Warning",
              style: AppConstants.titleBold
                  .copyWith(fontSize: AppConstants.fontExtraLarge * 1.5),
            ),
            SizedBox(
              height: AppConstants.paddingExtraLarge,
            ),
            Text(
              title,
              style: AppConstants.subHeading,
              textAlign: TextAlign.start,
            ),
          ]),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showCancel == true)
              CustomElevatedButton(
                  width: 140,
                  height: AppConstants.mediumButtonSized,
                  onTap: () {
                    Get.back();
                  },
                  text: "Cancel",
                  buttonStyle: AppConstants.commonButtonStyle,
                  buttonColor: AppConstants.appRed),
            SizedBox(
              height: AppConstants.paddingExtraLarge,
            ),
            CustomElevatedButton(
              width: 140,
              height: AppConstants.mediumButtonSized,
              onTap: onPress ?? () {},
              text: "OK",
              buttonColor: AppConstants.successGreen.withOpacity(0.8),
              buttonStyle: AppConstants.commonButtonStyle,
            ),
          ],
        ),
        SizedBox(
          height: bottomSpacing ?? 0,
        )
      ],
    );
  }
}

class CustomSuccessDialog extends StatelessWidget {
  final Widget? logo;
  final String title;
  final bool canPop;

  const CustomSuccessDialog(
      {super.key, required this.title, this.logo, this.canPop = true});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return canPop;
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppConstants.borderRadiusLarge)),
        title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: AppConstants.subHeadingBold,
              ),
              SizedBox(
                height: AppConstants.paddingExtraLarge,
              ),
              logo ?? const SizedBox.shrink()
            ]),
      ),
    );
  }
}
