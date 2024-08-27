import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomElevatedButton.dart';
import 'package:mytat/common-components/CustomImageWidget.dart';
import 'package:mytat/common-components/CustomLoadingIndicator.dart';
import 'package:mytat/common-components/CustomSnackbar.dart';
import 'package:mytat/common-components/CustomTextField.dart';
import 'package:mytat/controller/AuthController.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:mytat/view/user_mode_screen.dart';
import '../../utilities/ImageUrls.dart';

class ServerLoginScreen extends StatelessWidget {
  const ServerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _usernameController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Material(
      child: GetBuilder<AuthController>(builder: (authController) {
        return Container(
          padding: EdgeInsets.all(AppConstants.paddingExtraLarge),
          height: Get.height,
          width: Get.width,
          color: AppConstants.appBackground,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: Get.height * 0.2,
              ),
              CustomImageWidget(path: ImageUrls.companyLogo),
              SizedBox(
                height: Get.height * 0.05,
              ),
              CustomTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required";
                  }
                  return null; // Return null if validation passes
                },
                lable: "Enter your Username",
                textController: _usernameController,
                keyboardType: TextInputType.text,
                suffixIcon: const Icon(Icons.domain),
              ),
              SizedBox(
                height: AppConstants.paddingLarge * 2,
              ),
              CustomPasswordTextField(
                lable: "Enter your Password",
                passwordController: _passwordController,
              ),
              SizedBox(
                height: AppConstants.paddingLarge * 2,
              ),
              authController.isLodaingResponse == false
                  ? CustomElevatedButton(
                      onTap: () async {
                        if (await authController.getServerBaseformation(
                            _usernameController.text,
                            _passwordController.text)) {
                          Get.offAll(const UserModeScreen());
                          _passwordController.text = "";
                          _usernameController.text = "";
                        } else {
                          CustomSnackBar.customSnackBar(false,
                              "Invalid Email or Password. Please try again.",
                              isLong: true);
                        }
                      },
                      text: "Submit")
                  : const CustomLoadingIndicator()
            ],
          ),
        );
      }),
    );
  }
}
