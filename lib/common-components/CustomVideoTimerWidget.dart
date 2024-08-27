import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/controller/QuestionAnswersController.dart';

class CustomVideoTimerWidget extends StatefulWidget {
  const CustomVideoTimerWidget({super.key});

  @override
  _CustomVideoTimerWidgetState createState() => _CustomVideoTimerWidgetState();
}

class _CustomVideoTimerWidgetState extends State<CustomVideoTimerWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionAnswersController>(
        builder: (questionAnswersController) {
      return Text(
        questionAnswersController.getFormattedTime(),
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      );
    });
  }
}
