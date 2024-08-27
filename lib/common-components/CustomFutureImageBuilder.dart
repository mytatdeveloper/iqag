import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/controller/Candidate-Side-Controllers/CandidateOnboardingController.dart';

class CustomFutureImageBuilder extends StatelessWidget {
  final String imageUrl;
  const CustomFutureImageBuilder({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Get.find<CandidateOnboardingController>().decodeImage(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          return Image.memory(
            snapshot.data as Uint8List,
            height: Get.height * 0.2,
            width: Get.width,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
