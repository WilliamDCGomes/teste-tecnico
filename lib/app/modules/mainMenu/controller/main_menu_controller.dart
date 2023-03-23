import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:teste_tecnico/base/services/video_service.dart';
import '../../../../base/services/interface/ivideo_service.dart';
import '../../../utils/sharedWidgets/loading_with_success_or_error_widget.dart';
import '../../../utils/sharedWidgets/popups/information_popup.dart';
import '../../../utils/sharedWidgets/video_player_widget.dart';

class MainMenuController extends GetxController {
  late Rx<String?> videoLink;
  late IVideoService _videoService;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;

  MainMenuController() {
    _initializeVariables();
  }

  _initializeVariables() {
    videoLink = "".obs;
    _videoService = VideoService();
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
  }

  Future<void> openVideo() async {
    await loadingWithSuccessOrErrorWidget.startAnimation();
    videoLink.value = await _getVideoFile();
    if (loadingWithSuccessOrErrorWidget.animationController.isAnimating) await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);

    if (videoLink.value != null) {
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [],
      );
      await Get.to(() => VideoPlayerWidget(
        videoLink: videoLink.value!,
      ));
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  Future<String?> _getVideoFile() async {
    try {
      return await _videoService.getVideo();
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
