import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'CustomGridCardView.dart';

class CustomCenterTileWidget extends StatelessWidget {
  final String title;
  final String icon;
  VoidCallback? onTap;

  CustomCenterTileWidget(
      {super.key, required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Text(title, style: AppConstants.titleBold),
          SizedBox(
            height: AppConstants.paddingSmall / 2,
          ),
          Container(
            width: Get.width * 0.2,
            height: 2,
            color: AppConstants.appPrimary,
          ),
          SizedBox(
            height: AppConstants.paddingExtraLarge,
          ),
          CustomGridCardView(
              icon: icon,
              title: "Documents",
              padding: AppConstants.paddingExtraLarge),
        ],
      ),
    );
  }
}
