// camera_widget.dart

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:mytat/utilities/AppConstants.dart';

class CameraWidget extends StatelessWidget {
  final CameraController cameraController;
  final double? height;
  final double? width;

  const CameraWidget({
    super.key,
    required this.cameraController,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    if (!cameraController.value.isInitialized) {
      return Container();
    }

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge)),
      child: SizedBox(
        width: width ?? MediaQuery.of(context).size.width * 1,
        height: height ?? MediaQuery.of(context).size.height * 0.3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          child: CameraPreview(
            cameraController,
          ),
        ),
      ),
    );
  }
}
