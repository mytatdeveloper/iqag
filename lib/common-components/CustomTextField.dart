import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/controller/AuthController.dart';
import 'package:mytat/utilities/AppConstants.dart';

class CustomTextField extends StatelessWidget {
  final String lable;
  final TextEditingController textController;
  final Icon suffixIcon;
  final TextInputType? keyboardType;
  // adding validator
  final String? Function(String?)? validator;
  const CustomTextField(
      {super.key,
      required this.textController,
      required this.lable,
      required this.suffixIcon,
      this.keyboardType,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: keyboardType == TextInputType.visiblePassword ? true : false,
      decoration: InputDecoration(
        label: Text(lable, style: const TextStyle()),
        suffixIcon: suffixIcon,
        labelStyle: TextStyle(color: AppConstants.appPrimary),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: AppConstants.appGrey),
            borderRadius:
                BorderRadius.circular(AppConstants.borderRadiusSmall)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: AppConstants.appRed),
            borderRadius:
                BorderRadius.circular(AppConstants.borderRadiusSmall)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: AppConstants.appGrey),
            borderRadius:
                BorderRadius.circular(AppConstants.borderRadiusSmall)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
          borderSide: BorderSide(width: 2, color: AppConstants.appPrimary),
        ),
      ),
      validator: validator, // Use the validator here
    );
  }
}

class CustomPasswordTextField extends StatelessWidget {
  final String lable;
  final TextEditingController passwordController;
  const CustomPasswordTextField({
    super.key,
    required this.passwordController,
    required this.lable,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: Get.find<AuthController>().showPassword,
      decoration: InputDecoration(
        label: Text(lable, style: const TextStyle()),
        suffixIcon: GetBuilder<AuthController>(builder: (authController) {
          return IconButton(
              onPressed: () {
                authController.changePasswordVisibility();
              },
              icon: authController.showPassword
                  ? Icon(
                      Icons.visibility,
                      color: AppConstants.appPrimary,
                    )
                  : Icon(
                      Icons.visibility_off_rounded,
                      color: AppConstants.appPrimary,
                    ));
        }),
        labelStyle: TextStyle(color: AppConstants.appPrimary),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: AppConstants.appGrey),
            borderRadius:
                BorderRadius.circular(AppConstants.borderRadiusSmall)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: AppConstants.appRed),
            borderRadius:
                BorderRadius.circular(AppConstants.borderRadiusSmall)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: AppConstants.appGrey),
            borderRadius:
                BorderRadius.circular(AppConstants.borderRadiusSmall)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
          borderSide: BorderSide(width: 2, color: AppConstants.appPrimary),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter Password';
        }
        return null;
      },
    );
  }
}
