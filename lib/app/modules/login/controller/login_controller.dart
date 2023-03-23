import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teste_tecnico/base/services/login_service.dart';
import 'package:teste_tecnico/base/services/video_service.dart';
import '../../../../base/services/interface/ilogin_service.dart';
import '../../../../base/services/interface/ivideo_service.dart';
import '../../../utils/sharedWidgets/loading_with_success_or_error_widget.dart';
import '../../../utils/sharedWidgets/popups/information_popup.dart';
import '../../../utils/sharedWidgets/video_player_widget.dart';

class LoginPageController extends GetxController {
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
  late IVideoService _videoService;

  LoginPageController() {
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
    if(kDebugMode){
      userInputController.text = "candidato-seventh";
      passwordInputController.text = "8n5zSrYq";
    }
    passwordInputFocusNode = FocusNode();
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    _loginService = LoginService();
    _videoService = VideoService();
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

          await loadingWithSuccessOrErrorWidget.stopAnimation();

          await showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const InformationPopup(
                warningMessage: "Sucesso",
              );
            },
          );

          await _openVideo();
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

  Future<void> _openVideo() async {
    File? file = await _getVideoFile();

    if (file != null) {
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [],
      );
      await Get.to(() => VideoPlayerWidget(
        videoFile: file,
      ));
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }
  }

  Future<File?> _getVideoFile() async {
    try {
      await _videoService.getVideo();
      return null;
    } catch (_) {
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const InformationPopup(
            warningMessage: "Erro ao abrir o vídeo.",
          );
        },
      );
      return null;
    }
  }
}
