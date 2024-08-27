import 'package:flutter/material.dart';

class CustomImageWidget extends StatelessWidget {
  final String path;
  final double? height;
  final double? width;
  final double? borderRadius;
  const CustomImageWidget(
      {super.key,
      required this.path,
      this.borderRadius,
      this.height,
      this.width});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
        child: Image.asset(path, height: height, width: width));
  }
}
