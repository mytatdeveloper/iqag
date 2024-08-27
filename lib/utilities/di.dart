import 'package:get/get.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/AuthController.dart';
import 'package:mytat/controller/Candidate-Side-Controllers/CandidateOnboardingController.dart';
import 'package:mytat/controller/Online-Controller/OnlineAssessorDashboardController.dart';
import 'package:mytat/controller/QuestionAnswersController.dart';
import 'package:mytat/controller/SplashController.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
    Get.put<AuthController>(AuthController());
    Get.put<AssessorDashboardController>(AssessorDashboardController());
    Get.put<QuestionAnswersController>(QuestionAnswersController());
    Get.put<CandidateOnboardingController>(CandidateOnboardingController());
    Get.put<OnlineAssessorDashboardController>(
        OnlineAssessorDashboardController());
  }
}
