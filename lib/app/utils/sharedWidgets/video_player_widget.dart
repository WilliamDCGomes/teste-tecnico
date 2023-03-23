import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';
import '../helpers/format_numbers.dart';
import '../sharedWidgets/text_widget.dart';
import '../stylePages/app_colors.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoLink;

  const VideoPlayerWidget({
    Key? key,
    required this.videoLink,
  }) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late RxBool isInFullScreen;
  late RxBool showVideoControl;
  late VideoPlayerController controller;

  @override
  void initState() {
    isInFullScreen = false.obs;
    showVideoControl = false.obs;
    showVideoControl.listen((value) async {
      if(value){
        await Future.delayed(const Duration(seconds: 5));
        showVideoControl.value = false;
      }
    });
    showVideoControl.value = true;
    loadVideoPlayer();
    super.initState();
  }

  loadVideoPlayer(){
    controller = VideoPlayerController.contentUri(Uri.parse(widget.videoLink));
    controller.addListener(() {
      setState(() {});
    });
    controller.initialize().then((value){
      setState(() {});
    });
    controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await controller.seekTo(const Duration(seconds: 0));
        setState(() {});
        await controller.dispose();
        return true;
      },
      child: Obx(
        () => Scaffold(
          backgroundColor: AppColors.blackColor,
          body: Stack(
            children:[
              InkWell(
                onTap: (){
                  showVideoControl.value = !showVideoControl.value;
                },
                splashColor: AppColors.transparentColor,
                highlightColor: AppColors.transparentColor,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  ),
                ),
              ),
              Visibility(
                visible: showVideoControl.value,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
                    padding: EdgeInsets.all(1.h),
                    decoration: BoxDecoration(
                      color: AppColors.blackTransparentColor,
                      borderRadius: BorderRadius.circular(1.h),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextWidget(
                            "${FormatNumbers.formatVideoTime(
                              controller.value.position.inSeconds,
                            )} / ${FormatNumbers.formatVideoTime(
                              controller.value.duration.inSeconds,
                            )}",
                          ),
                        ),
                        Container(
                          height: 10,
                          margin: EdgeInsets.symmetric(vertical: 1.h),
                          child: VideoProgressIndicator(
                            controller,
                            allowScrubbing: true,
                            colors: const VideoProgressColors(
                              backgroundColor: AppColors.backgroundPlayColor,
                              playedColor: AppColors.defaultColor,
                              bufferedColor: AppColors.bufferedColor,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: (){
                                if(controller.value.isPlaying){
                                  controller.pause();
                                }
                                else{
                                  controller.play();
                                }
                                setState(() {});
                              },
                              icon: Icon(
                                controller.value.isPlaying? Icons.pause: Icons.play_arrow,
                                color: AppColors.whiteColor,
                              ),
                            ),
                            IconButton(
                              onPressed: (){
                                controller.seekTo(const Duration(seconds: 0));
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.stop,
                                color: AppColors.whiteColor,
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  onPressed: () async {
                                    isInFullScreen.value = !isInFullScreen.value;
                                    if(isInFullScreen.value){
                                      await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
                                    }
                                    else{
                                      await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                                    }
                                  },
                                  icon: Icon(
                                    isInFullScreen.value ? Icons.fullscreen_exit : Icons.fullscreen,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}