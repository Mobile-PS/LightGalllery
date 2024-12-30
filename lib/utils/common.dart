

import 'package:get/get.dart';

showSnackbar(String message, [int timeInSec = 3]) {
  Get.showSnackbar(GetSnackBar(
    message: message,
    duration: Duration(seconds: timeInSec),
    snackStyle: SnackStyle.FLOATING,
  ));
}
