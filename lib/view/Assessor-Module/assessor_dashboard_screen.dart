import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomAppBar.dart';
import 'package:mytat/common-components/CustomManagementSection.dart';
import 'package:mytat/utilities/AppConstants.dart';
import '../../common-components/CustomFloatingActionButton.dart';
import '../../controller/AssessorDashboardController.dart';

class AssessorDashboardScreen extends StatelessWidget {
  const AssessorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => AppConstants.onWillPop(context),
      child: GetBuilder<AssessorDashboardController>(
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
                  CustomManagementSection(
                      customList:
                          assessorDashboardController.documentManagement,
                      title: "Documents Management",
                      crossAxisCount: 2),
                  if (assessorDashboardController
                          .tempVQuestionsList.isNotEmpty ||
                      assessorDashboardController.tempPQuestionsList.isNotEmpty)
                    CustomManagementSection(
                        customList: assessorDashboardController.vivaManagement,
                        title: "Practical/Viva Management"),
                  if (assessorDashboardController.tempMQuestionsList.isNotEmpty)
                    CustomManagementSection(
                        customList: assessorDashboardController.studentTheory,
                        title: "Student Theory",
                        isStudenttheory: true,
                        crossAxisCount: 2),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
