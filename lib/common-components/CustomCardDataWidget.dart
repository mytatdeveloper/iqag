import 'package:flutter/material.dart';
import 'package:mytat/utilities/AppConstants.dart';

class CustomDataCardWidget extends StatelessWidget {
  final String count;
  final String title;

  const CustomDataCardWidget({
    super.key,
    required this.count,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppConstants.subHeadingItalic,
          ),
        ),
        Text(
          count,
          style: AppConstants.subHeadingBold,
        ),
      ],
    );
  }
}
