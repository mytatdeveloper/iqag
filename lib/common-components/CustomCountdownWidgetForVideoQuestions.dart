import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/controller/QuestionAnswersController.dart';

class CustomCountdownWidgetForVideoQuestions extends StatefulWidget {
  const CustomCountdownWidgetForVideoQuestions({
    super.key,
  });

  @override
  _CustomCountdownWidgetForVideoQuestionsState createState() =>
      _CustomCountdownWidgetForVideoQuestionsState();
}

class _CustomCountdownWidgetForVideoQuestionsState
    extends State<CustomCountdownWidgetForVideoQuestions> {
  @override
  void initState() {
    super.initState();
  }

  String _formatTime(Duration duration) {
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    Get.find<QuestionAnswersController>().cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionAnswersController>(
        builder: (questionAnswersController) {
      return Text(
        _formatTime(questionAnswersController.currentTime),
        style: const TextStyle(fontSize: 24),
      );
    });
  }
}
