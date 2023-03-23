import 'dart:io';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';
import '../helpers/format_numbers.dart';
import '../sharedWidgets/text_widget.dart';
import '../stylePages/app_colors.dart';

class VideoPlayerWidget extends StatefulWidget {
  final File videoFile;

  const VideoPlayerWidget({
    Key? key,
    required this.videoFile,
  }) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController controller;

  @override
  void initState() {
    loadVideoPlayer();
    super.initState();
  }

  loadVideoPlayer(){
    controller = VideoPlayerController.file(widget.videoFile);
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
      child: Scaffold(
        body: Stack(
          children:[
            Column(
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextWidget(
                      "${FormatNumbers.formatVideoTime(
                        controller.value.position.inMinutes,
                        controller.value.position.inSeconds,
                      )} / ${FormatNumbers.formatVideoTime(
                        controller.value.duration.inMinutes,
                        controller.value.duration.inSeconds,
                      )}",
                    ),
                  ),
                  VideoProgressIndicator(
                    controller,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      backgroundColor: AppColors.backgroundPlayColor,
                      playedColor: AppColors.defaultColor,
                      bufferedColor: AppColors.bufferedColor,
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
                        icon:Icon(
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
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}