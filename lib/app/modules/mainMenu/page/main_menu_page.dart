import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:teste_tecnico/app/utils/sharedWidgets/button_widget.dart';
import 'package:teste_tecnico/app/utils/sharedWidgets/text_widget.dart';
import '../../../utils/helpers/app_close_controller.dart';
import '../../../utils/stylePages/app_colors.dart';
import '../controller/main_menu_controller.dart';

class MainMenuPage extends StatefulWidget {

  const MainMenuPage({Key? key}) : super(key: key);

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  final MainMenuController controller = Get.put(MainMenuController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return AppCloseController.verifyCloseScreen();
      },
      child: SafeArea(
        child: Material(
          child: Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: const TextWidget(
                    "Teste Técnico",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Obx(
                    () => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if(controller.videoLink.value != null && controller.videoLink.value != "")
                          Padding(
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: TextWidget(
                              "URL: ${controller.videoLink.value}",
                              textColor: AppColors.blackColor,
                              fontWeight: FontWeight.w600,
                              maxLines: 5,
                            ),
                          ),
                        ButtonWidget(
                          hintText: "Clique aqui para começar o vídeo!",
                          fontWeight: FontWeight.bold,
                          widthButton: 75.w,
                          onPressed: () async {
                            await controller.openVideo();
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              controller.loadingWithSuccessOrErrorWidget,
            ],
          ),
        ),
      ),
    );
  }
}