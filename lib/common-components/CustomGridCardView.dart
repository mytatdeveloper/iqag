import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/utilities/AppConstants.dart';

class CustomGridCardView extends StatelessWidget {
  final String icon;
  final String title;
  double? padding;
  double? height;
  bool? isSpacingNeeded;

  final VoidCallback? onTilePressed;
  CustomGridCardView(
      {super.key,
      required this.icon,
      required this.title,
      this.onTilePressed,
      this.padding,
      this.height,
      this.isSpacingNeeded = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTilePressed,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding ?? 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                icon,
                height: height ??
                    (AppConstants.isOnlineMode == true
                        ? Get.height * 0.12
                        : 60),
                width: AppConstants.isOnlineMode == true ? Get.width * 0.5 : 60,
              ),
              isSpacingNeeded == true
                  ? const SizedBox(
                      height: 12,
                    )
                  : const SizedBox.shrink(),
              Text(title,
                  style: AppConstants.bodyItalic.copyWith(
                      fontSize: Get.width < 400
                          ? AppConstants.fontLarge
                          : AppConstants.fontExtraLarge)),
            ],
          ),
        ),
      ),
    );
  }
}
