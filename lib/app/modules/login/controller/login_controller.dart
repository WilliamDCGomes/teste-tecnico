import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teste_tecnico/app/modules/mainMenu/page/main_menu_page.dart';
import 'package:teste_tecnico/base/services/login_service.dart';
import '../../../../base/services/interface/ilogin_service.dart';
import '../../../utils/sharedWidgets/loading_with_success_or_error_widget.dart';
import '../../../utils/sharedWidgets/popups/information_popup.dart';

class LoginController extends GetxController {
  late RxBool cpfInputHasError;
  late RxBool passwordInputHasError;
  late RxBool isPasswordField;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late TextEditingController userInputController;
  late TextEditingController passwordInputController;
  late FocusNode passwordInputFocusNode;
  late final GlobalKey<FormState> formKey;
  late SharedPreferences sharedPreferences;
  late ILoginService _loginService;

  LoginController() {
    _initializeVariables();
  }

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    super.onInit();
  }

  _initializeVariables() {
    cpfInputHasError = false.obs;
    passwordInputHasError = false.obs;
    isPasswordField = true.obs;
    formKey = GlobalKey<FormState>();
    userInputController = TextEditingController();
    passwordInputController = TextEditingController();
    passwordInputFocusNode = FocusNode();
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    _loginService = LoginService();
  }

  loginPressed() async {
    try {
      if (formKey.currentState!.validate()) {
        await loadingWithSuccessOrErrorWidget.startAnimation();

        var authenticateResponse = await _loginService.authenticate(
          userInputController.text.trim(),
          passwordInputController.text.trim(),
        );

        if (authenticateResponse != null && authenticateResponse.token != null) {
          await sharedPreferences.setString("login", userInputController.text.trim());
          await sharedPreferences.setString("password", passwordInputController.text.trim());
          await sharedPreferences.setString("token", authenticateResponse.token!);

          if (loadingWithSuccessOrErrorWidget.animationController.isAnimating) await loadingWithSuccessOrErrorWidget.stopAnimation();

          Get.offAll(() => MainMenuPage());
        }
        else {
          if (loadingWithSuccessOrErrorWidget.animationController.isAnimating) await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
          await showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const InformationPopup(
                warningMessage: "Usuário ou a Senha estão incorreto.",
              );
            },
          );
        }
      }
    } catch (_) {
      if (loadingWithSuccessOrErrorWidget.animationController.isAnimating) await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const InformationPopup(
            warningMessage: "Erro ao fazer Login!\nTente novamente mais tarde.",
          );
        },
      );
    }
  }
}
