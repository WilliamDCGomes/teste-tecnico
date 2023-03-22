import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../helpers/app_paths.dart';
import '../stylePages/app_colors.dart';
import 'lottie_asset_widget.dart';

// ignore: must_be_immutable
class LoadingWithSuccessOrErrorWidget extends StatefulWidget {
  late final RxBool loadingAnimation;
  late final RxBool isLoading;
  late final RxBool success;
  late AnimationController animationController;

  LoadingWithSuccessOrErrorWidget({
    Key? key,
    RxBool? internalLoadingAnimation,
  }) : super(key: key) {
    isLoading = true.obs;
    success = false.obs;
    loadingAnimation = internalLoadingAnimation ?? false.obs;
  }

  @override
  State<LoadingWithSuccessOrErrorWidget> createState() => _LoadingWithSuccessOrErrorWidgetState();

  Future startAnimation({Widget? destinationPage, bool? backPage}) async {
    loadingAnimation.value = true;
    animationController.repeat();
  }

  Future stopAnimation({Widget? destinationPage, bool? backPage, bool? justLoading, bool? fail, int? duration}) async {
    loadingAnimation.value = true;
    if (justLoading != null && justLoading) {
      await Future.delayed(const Duration(seconds: 1));
      _resetStateWithoutSuccessOrFail();
      return;
    } else if (destinationPage != null) {
      isLoading.value = false;
      success.value = true;
      await Future.delayed(Duration(seconds: duration ?? 3));
      Get.offAll(() => destinationPage);
    } else if (backPage != null && backPage) {
      isLoading.value = false;
      success.value = true;
      await Future.delayed(Duration(seconds: duration ?? 3));
      Get.back();
    } else if (fail != null && fail) {
      isLoading.value = false;
      success.value = false;
      await Future.delayed(Duration(seconds: duration ?? 3));
    } else {
      isLoading.value = false;
      success.value = true;
      await Future.delayed(Duration(seconds: duration ?? 3));
    }
    _resetState();
  }

  _resetState() {
    isLoading.value = true;
    success.value = false;
    loadingAnimation.value = false;
    animationController.reset();
  }

  _resetStateWithoutSuccessOrFail() {
    loadingAnimation.value = false;
    isLoading.value = true;
    animationController.reset();
  }
}

class _LoadingWithSuccessOrErrorWidgetState extends State<LoadingWithSuccessOrErrorWidget> with TickerProviderStateMixin {
  @override
  void initState() {
    widget.animationController = AnimationController(vsync: this);
    widget.animationController.duration = const Duration(seconds: 3);
    super.initState();
  }

  @override
  void dispose() {
    widget.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !widget.loadingAnimation.value;
      },
      child: Obx(
        () => Visibility(
          visible: widget.loadingAnimation.value,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 100.h,
              width: 100.w,
              color: AppColors.blackTransparentColor,
              child: Center(
                child: Obx(
                  () => Visibility(
                    visible: widget.isLoading.value,
                    replacement: widget.success.value
                        ? const LottieAssetWidget(
                            animationPath: AppPaths.successAnimation,
                            repeat: false,
                          )
                        : const LottieAssetWidget(
                            animationPath: AppPaths.error,
                            repeat: false,
                          ),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 5.h),
                      child: LottieAssetWidget(
                        height: 40.h,
                        width: 40.h,
                        animationPath: AppPaths.loading,
                        animationController: widget.animationController,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
