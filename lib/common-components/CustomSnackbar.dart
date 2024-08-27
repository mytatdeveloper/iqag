import 'package:get/get.dart';
import 'package:mytat/utilities/AppConstants.dart';

class CustomSnackBar {
  static SnackbarController customSnackBar(bool isSuccess, String text,
          {bool isLong = false}) =>
      Get.snackbar(isSuccess ? "Success" : "Failure", text,
          backgroundColor: isSuccess
              ? AppConstants.appGreen.withOpacity(0.2)
              : AppConstants.appSecondary.withOpacity(0.2),
          colorText: AppConstants.appBlack,
          duration: Duration(seconds: isLong ? 6 : 3));
}
