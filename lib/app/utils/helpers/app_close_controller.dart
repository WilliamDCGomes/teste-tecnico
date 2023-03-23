import '../sharedWidgets/snackbar_widget.dart';
import '../stylePages/app_colors.dart';

class AppCloseController {
  static DateTime? backPushed;
  static bool verifyCloseScreen() {
    DateTime now = DateTime.now();
    if (backPushed == null || (backPushed != null && now.difference(backPushed!) > const Duration(seconds: 2))) {
      backPushed = now;
      SnackbarWidget(
        warningText: "Aviso",
        informationText: "Pressione novamente para sair",
        backgrondColor: AppColors.defaultColor,
      );
      return false;
    }
    return true;
  }
}