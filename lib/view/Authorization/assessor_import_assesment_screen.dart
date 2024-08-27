import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomCardDataWidget.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/common-components/CustomSnackbar.dart';
import 'package:mytat/common-components/CustomTextField.dart';
import 'package:mytat/controller/AssessorDashboardController.dart';
import 'package:mytat/controller/AuthController.dart';
import 'package:mytat/controller/Online-Controller/OnlineAssessorDashboardController.dart';
import 'package:mytat/services/db_helper.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:mytat/utilities/ImageUrls.dart';
import 'package:mytat/view/Online-Mode/online_assessor_dashboard.dart';
import 'package:mytat/view/user_mode_screen.dart';
import '../../common-components/CustomLoadingIndicator.dart';
import '../Assessor-Module/assessor_dashboard_screen.dart';

class ImportAssesmentScreen extends StatelessWidget {
  const ImportAssesmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _assesmentIdController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Material(
      color: AppConstants.appBackground,
      child: GetBuilder<AssessorDashboardController>(
          builder: (assessorDashboardController) {
        return Form(
          key: _formKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: Get.height * 0.70,
                child: Padding(
                  padding: EdgeInsets.all(
                      AppConstants.paddingLarge + AppConstants.paddingMedium),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        ImageUrls.companyLogo,
                        height: AppConstants.borderRadiusCircular * 1.5,
                      ),
                      SizedBox(
                        height: Get.height * 0.05,
                      ),
                      Text(
                        AppConstants.isOnlineMode == true
                            ? "ENTER ASSESSMENT ID"
                            : "IMPORT ASSESSMENT",
                        style: AppConstants.titleBold,
                      ),
                      SizedBox(
                        height: AppConstants.paddingExtraLarge,
                      ),
                      CustomTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            }
                            return null; // Return null if validation passes
                          },
                          lable: "Assesment id",
                          textController: _assesmentIdController,
                          suffixIcon: const Icon(Icons.onetwothree),
                          keyboardType: TextInputType.number),
                      SizedBox(
                        height: AppConstants.paddingExtraLarge,
                      ),
                      SizedBox(
                        height: AppConstants.paddingExtraLarge,
                      ),
                      assessorDashboardController.isLodaingResponse
                          ? const CustomLoadingIndicator()
                          : CustomElevatedButton(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  var dbHelper = DatabaseHelper();
                                  await dbHelper.clearDatabase();
                                  if (await assessorDashboardController
                                      .importAssesmentQuestions(
                                          _assesmentIdController.text
                                              .toString())) {
                                    Get.dialog(
                                      barrierDismissible: false,
                                      Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                AppConstants
                                                    .borderRadiusLarge)),
                                        backgroundColor:
                                            AppConstants.appSecondary,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: AppConstants.appBackground,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppConstants
                                                          .borderRadiusLarge)),
                                          padding: EdgeInsets.all(
                                              AppConstants.paddingDefault * 2),
                                          height: Get.height * 0.4,
                                          width: Get.width * 0.95,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                AppConstants.isOnlineMode ==
                                                        true
                                                    ? "Assessment Details"
                                                    : "Import Results:",
                                                style: AppConstants.titleBold
                                                    .copyWith(
                                                        fontSize: AppConstants
                                                                .fontExtraLarge +
                                                            4),
                                              ),
                                              SizedBox(
                                                height:
                                                    AppConstants.paddingDefault,
                                              ),
                                              CustomDataCardWidget(
                                                count:
                                                    assessorDashboardController
                                                        .pQuestions.length
                                                        .toString(),
                                                title: "Practical Questions:",
                                              ),
                                              CustomDataCardWidget(
                                                count:
                                                    assessorDashboardController
                                                        .mQuestions.length
                                                        .toString(),
                                                title: "MCQ's Questions:",
                                              ),
                                              CustomDataCardWidget(
                                                count:
                                                    assessorDashboardController
                                                        .vQuestions.length
                                                        .toString(),
                                                title: "Viva Questions:",
                                              ),
                                              CustomDataCardWidget(
                                                count:
                                                    assessorDashboardController
                                                        .studentsBatch.length
                                                        .toString(),
                                                title: "Students:",
                                              ),
                                              CustomDataCardWidget(
                                                count:
                                                    assessorDashboardController
                                                        .assessorDocumentsList
                                                        .length
                                                        .toString(),
                                                title: "Annexure Documents:",
                                              ),
                                              SizedBox(
                                                height:
                                                    AppConstants.paddingDefault,
                                              ),
                                              CustomElevatedButton(
                                                width: Get.width * 0.5,
                                                height: AppConstants
                                                        .mediumButtonSized +
                                                    10,
                                                onTap: () {
                                                  if (AppConstants
                                                          .isOnlineMode ==
                                                      true) {
                                                    Get.find<
                                                            OnlineAssessorDashboardController>()
                                                        .getAllTemporaryQuestionsList();
                                                  } else {
                                                    Get.find<
                                                            AssessorDashboardController>()
                                                        .getAllTemporaryQuestionsList();
                                                  }

                                                  Get.to(AppConstants
                                                              .isOnlineMode ==
                                                          true
                                                      ? const OnlineAssessorDashboardScreen()
                                                      : const AssessorDashboardScreen());
                                                },
                                                text: "Proceed",
                                                buttonStyle: AppConstants
                                                    .commonButtonStyle,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    CustomSnackBar.customSnackBar(false,
                                        "Please Check whether this assessment Id is valid or not assigned to you.");
                                  }
                                }
                              },
                              text: AppConstants.isOnlineMode == true
                                  ? "Submit"
                                  : "Import Assessment",
                              buttonColor: AppConstants.appGreen,
                              buttonStyle: AppConstants.commonButtonStyle),
                      SizedBox(
                        height: AppConstants.paddingExtraLarge,
                      ),
                      assessorDashboardController.isLodaingResponse
                          ? const SizedBox.shrink()
                          : CustomElevatedButton(
                              onTap: () async {
                                // Clear the database entries
                                AppConstants.isTempOut = false;
                                var dbHelper = DatabaseHelper();
                                await dbHelper.clearDatabase();

                                // logout the user
                                await Get.find<AuthController>().logOutUser();
                                Get.offAll(const UserModeScreen());
                              },
                              buttonStyle: AppConstants.commonButtonStyle,
                              text: "Logout Assessor"),
                      SizedBox(
                        height: AppConstants.paddingExtraLarge,
                        // Get.height * 0.1,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Image.asset(
                  Get.width < 400
                      ? ImageUrls.assessorLoginMedium
                      : ImageUrls.assessorLogin,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
