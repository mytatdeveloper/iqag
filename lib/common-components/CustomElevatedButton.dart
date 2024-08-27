import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/utilities/AppConstants.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double? borderRadius;
  final double? width;
  final double? height;
  final Color? buttonColor;
  final bool ispaddingNeeded;
  final TextStyle? buttonStyle;

  const CustomElevatedButton(
      {super.key,
      this.borderRadius,
      this.height,
      required this.onTap,
      required this.text,
      this.width,
      this.buttonColor,
      this.ispaddingNeeded = true,
      this.buttonStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ispaddingNeeded
          ? EdgeInsets.symmetric(horizontal: AppConstants.paddingExtraLarge)
          : EdgeInsets.zero,
      width: width ?? Get.width * 1,
      height: height ?? 50,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    borderRadius ?? AppConstants.borderRadiusSmall),
              ),
              primary: buttonColor ?? AppConstants.appPrimary),
          onPressed: onTap,
          child: Text(
            text,
            style: buttonStyle ?? const TextStyle(),
          )),
    );
  }
}
