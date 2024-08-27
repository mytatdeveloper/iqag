import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:mytat/controller/SplashController.dart';

class ReusableProgressIndicator extends StatelessWidget {
  const ReusableProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (splashController) {
      return SizedBox(
        width: 150,
        child: LinearProgressIndicator(
          value: splashController.loadingIndicatorValue,
          minHeight: 10,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      );
    });
  }
}
