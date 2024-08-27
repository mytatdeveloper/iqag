import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/common-components/CustomSnackbar.dart';
import 'package:mytat/common-components/CustomTextField.dart';
import 'package:mytat/controller/AuthController.dart';
import 'package:mytat/controller/Candidate-Side-Controllers/CandidateOnboardingController.dart';
import 'package:mytat/controller/QuestionAnswersController.dart';
import 'package:mytat/controller/SplashController.dart';
import 'package:mytat/model/StudentsBatchModel.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:mytat/utilities/ImageUrls.dart';
import 'package:mytat/view/Assessor-Module/assessor_dashboard_screen.dart';
import 'package:mytat/view/Authorization/assessor_import_assesment_screen.dart';
import 'package:mytat/view/Candidate-Module/candidate_document_verification_screen.dart';
import 'package:mytat/view/Online-Mode/online_assessor_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common-components/CustomLoadingIndicator.dart';

class LoginScreen extends StatelessWidget {
  final String userType;
  final bool isOnline;
  final bool isFromStudentLogout;

  const LoginScreen(
      {super.key,
      required this.userType,
      required this.isOnline,
      this.isFromStudentLogout = false});

  @override
  Widget build(BuildContext context) {
    TextEditingController _idController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _enrollmentNumberController = TextEditingController();
    TextEditingController _assessmentIdController = TextEditingController();

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Material(
      color: AppConstants.appBackground,
      child: GetBuilder<AuthController>(builder: (authController) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: userType == "candidate"
                    ? Get.height * 0.77
                    : Get.height * 0.70,
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
                        userType == "assessor"
                            ? "ASSESSOR LOGIN"
                            : userType == "candidate"
                                ? "CANDIDATE LOGIN"
                                : "IMPORT ASSESSMENT",
                        style: AppConstants.titleBold,
                      ),
                      Visibility(
                        visible: userType != "candidate",
                        child: SizedBox(
                          height: AppConstants.paddingExtraLarge,
                        ),
                      ),
                      Visibility(
                        visible: userType != "candidate",
                        child: CustomTextField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This field is required";
                              }
                              return null; // Return null if validation passes
                            },
                            lable: userType == "assessor"
                                ? "Assessor ID"
                                // : userType == "candidate"
                                //     ? "Institution id"
                                : userType == "import"
                                    ? "Assesment id"
                                    : "User ID",
                            textController: _idController,
                            suffixIcon: const Icon(Icons.abc),
                            keyboardType: null),
                      ),
                      SizedBox(
                        height: AppConstants.paddingExtraLarge,
                      ),
                      Visibility(
                        visible: userType == "candidate",
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              CustomTextField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This field is required";
                                  }
                                  return null; // Return null if validation passes
                                },
                                textController: _enrollmentNumberController,
                                lable: "Enrollment Number",
                                keyboardType: TextInputType.text,
                                suffixIcon: const Icon(
                                    Icons.format_list_numbered_rounded),
                              ),
                              SizedBox(
                                height: AppConstants.paddingExtraLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: userType != "import",
                        child: CustomPasswordTextField(
                          passwordController: _passwordController,
                          lable: "Password",
                        ),
                      ),
                      SizedBox(
                        height: AppConstants.paddingExtraLarge,
                      ),
                      Visibility(
                        visible: AppConstants.isOnlineMode == true &&
                            userType == "candidate",
                        child: CustomTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            }
                            return null; // Return null if validation passes
                          },
                          textController: _assessmentIdController,
                          lable: "Assessment Id",
                          keyboardType: TextInputType.text,
                          suffixIcon:
                              const Icon(Icons.format_list_numbered_rounded),
                        ),
                      ),
                      Visibility(
                        visible: AppConstants.isOnlineMode == true &&
                            userType == "candidate",
                        child: SizedBox(
                          height: AppConstants.paddingExtraLarge,
                        ),
                      ),
                      authController.isLodaingResponse
                          ? const CustomLoadingIndicator()
                          : CustomElevatedButton(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  Get.find<SplashController>().getLocation();
                                  Get.find<QuestionAnswersController>()
                                      .clearAnnexureList();
                                  // resetting camera
                                  Get.find<QuestionAnswersController>()
                                      .clearFile();
                                  // resetting camera
                                  if (userType == "assessor") {
                                    if (AppConstants.isTempOut == true) {
                                      SharedPreferences _prefs =
                                          await SharedPreferences.getInstance();
                                      if (_prefs.getString("assessorEmail") ==
                                              _idController.text &&
                                          _prefs.getString("assesorPassword") ==
                                              _passwordController.text) {
                                        CustomSnackBar.customSnackBar(
                                            true, "Login Success!");
                                        Get.offAll(AppConstants.isOnlineMode ==
                                                true
                                            ? const OnlineAssessorDashboardScreen()
                                            : const AssessorDashboardScreen());
                                        _prefs.setBool("tempLogout", false);
                                      } else {
                                        CustomSnackBar.customSnackBar(
                                            false, "Invalid Credentials!");
                                      }
                                    } else {
                                      if (isFromStudentLogout) {
                                        SharedPreferences _prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        if (_prefs.getString("assessorEmail") ==
                                                _idController.text &&
                                            _prefs.getString(
                                                    "assesorPassword") ==
                                                _passwordController.text) {
                                          CustomSnackBar.customSnackBar(
                                              true, "Login Success!");
                                          Get.offAll(
                                              const AssessorDashboardScreen());
                                        } else {
                                          CustomSnackBar.customSnackBar(
                                              false, "Invalid Credentials!");
                                        }
                                      } else {
                                        bool? loginSuccess =
                                            await authController.loginAssessor(
                                                _idController.text,
                                                _passwordController.text,
                                                true);
                                        if (loginSuccess == true) {
                                          CustomSnackBar.customSnackBar(
                                              true, "Successfully Logged In!");
                                          Get.to(const ImportAssesmentScreen());
                                        } else if (loginSuccess == false) {
                                          CustomSnackBar.customSnackBar(false,
                                              "Email or Password is invalid! Please try again",
                                              isLong: true);
                                        } else {
                                          CustomSnackBar.customSnackBar(false,
                                              "Something Went Wrong! Please check your connection.",
                                              isLong: true);
                                        }
                                      }
                                    }
                                  }
                                  if (userType == "candidate") {
                                    bool? isCandidateAllowed;
                                    if (AppConstants.isOnlineMode == true) {
                                      isCandidateAllowed = await Get.find<
                                              CandidateOnboardingController>()
                                          .loginCandidateOnline(
                                              _assessmentIdController.text,
                                              _enrollmentNumberController.text,
                                              _passwordController.text);
                                    }

                                    if (isCandidateAllowed == false &&
                                        AppConstants.isOnlineMode == true) {
                                      CustomSnackBar.customSnackBar(false,
                                          "Candidate record already submitted",
                                          isLong: true);
                                    } else if (isCandidateAllowed == null &&
                                        AppConstants.isOnlineMode == true) {
                                    } else {
                                      bool? isCandidateFound = await Get.find<
                                              CandidateOnboardingController>()
                                          .loginCandidateoffline(
                                              AppConstants.companyId,
                                              _enrollmentNumberController.text,
                                              _passwordController.text);
                                      if (isCandidateFound == true) {
                                        // Checking if Candidate already Given the Exams

                                        // CustomSnackBar.customSnackBar(
                                        //     true, "User Found");
                                        Get.offAll(
                                            CandidateDocumentVerificationScreen(
                                          enrollmentNumber:
                                              _enrollmentNumberController.text,
                                          candidate: Get.find<
                                                      CandidateOnboardingController>()
                                                  .presentCandidate ??
                                              Batches(),
                                        ));
                                      } else if (isCandidateFound == false) {
                                        CustomSnackBar.customSnackBar(false,
                                            "No record found. Please check your credentials!",
                                            isLong: true);
                                      } else {
                                        CustomSnackBar.customSnackBar(false,
                                            "Candidate record already submitted",
                                            isLong: true);
                                      }
                                    }
                                  }
                                }
                              },
                              text: "Login",
                              buttonStyle: AppConstants.commonButtonStyle,
                              buttonColor: AppConstants.appSecondary,
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
