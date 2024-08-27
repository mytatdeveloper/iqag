import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomAppBar.dart';
import 'package:mytat/common-components/Online-Module/OnlineCustomManagementSection.dart';
import 'package:mytat/controller/Online-Controller/OnlineAssessorDashboardController.dart';
import 'package:mytat/utilities/AppConstants.dart';
import '../../common-components/CustomFloatingActionButton.dart';

class OnlineAssessorDashboardScreen extends StatelessWidget {
  const OnlineAssessorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => AppConstants.onWillPop(context),
      child: GetBuilder<OnlineAssessorDashboardController>(
          builder: (assessorDashboardController) {
        return Scaffold(
          backgroundColor: AppConstants.appBackground,
          appBar: CustomAppBar(
              title: "Viva & Theory Management",
              showLogout:
                  assessorDashboardController.tempMQuestionsList.isNotEmpty),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: const CustomFloatingActionButton(),
          body: Padding(
            padding: EdgeInsets.all(AppConstants.paddingExtraLarge),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: OnlineCustomManagementSection(
                      height: 50,
                      customList:
                          assessorDashboardController.documentManagement,
                      title: "Documents Management",
                    ),
                  ),
                  if (assessorDashboardController
                          .tempPQuestionsList.isNotEmpty ||
                      assessorDashboardController.tempVQuestionsList.isNotEmpty)
                    Center(
                      child: OnlineCustomManagementSection(
                          height: 50,
                          customList:
                              assessorDashboardController.vivaManagement,
                          title: "Practical/Viva Management"),
                    ),
                  Center(
                    child: OnlineCustomManagementSection(
                        height: 50,
                        customList: assessorDashboardController.studentTheory,
                        title: "Student Theory",
                        isStudenttheory: true),
                  ),
                  SizedBox(
                    height: AppConstants.paddingExtraLarge * 2.5,
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
