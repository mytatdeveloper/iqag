import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/common-components/CustomCountdownWidgetForVideoQuestions.dart';
import 'package:mytat/common-components/CustomVideoTimerWidget.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:mytat/view/Authorization/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final Widget? icon;
  final String title;
  final VoidCallback? onpressed;
  final bool showTimer;
  final bool showLogout;
  final Duration? duration;
  final bool showRecordingTime;

  CustomAppBar({
    required this.title,
    this.icon,
    this.onpressed,
    this.showTimer = false,
    this.showLogout = false,
    this.duration,
    this.showRecordingTime = false,
    Key? key,
  })  : preferredSize = const Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(title, style: const TextStyle()),
      backgroundColor: AppConstants.appPrimary,
      automaticallyImplyLeading: false,
      leadingWidth: icon != null ? AppConstants.paddingExtraLarge * 2 : 0,
      leading: Padding(
        padding: EdgeInsets.only(left: AppConstants.paddingSmall),
        child: icon != null
            ? InkWell(
                onTap: onpressed,
                child: icon,
              )
            : const SizedBox.shrink(),
      ),
      actions: [
        Visibility(
            visible: showRecordingTime == true,
            child: Padding(
              padding: EdgeInsets.only(
                  top: AppConstants.fontSmall, right: AppConstants.fontSmall),
              child: const CustomVideoTimerWidget(),
            )),
        Visibility(
            visible: showLogout && AppConstants.isOnlineMode != true,
            child: IconButton(
                onPressed: () async {
                  SharedPreferences _prefs =
                      await SharedPreferences.getInstance();
                  _prefs.setBool("tempLogout", true);
                  Get.offAll(const LoginScreen(
                      userType: "candidate", isOnline: false));
                },
                icon: const Icon(Icons.logout))),
        Visibility(
            visible: showTimer,
            child: Padding(
              padding: EdgeInsets.only(
                  top: AppConstants.fontSmall, right: AppConstants.fontSmall),
              child: const CustomCountdownWidgetForVideoQuestions(),
            ))
      ],
    );
  }
}
