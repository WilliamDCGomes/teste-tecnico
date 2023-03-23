import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../stylePages/app_colors.dart';
import '../button_widget.dart';
import '../text_widget.dart';

class InformationPopup extends StatefulWidget {
  final String warningMessage;
  final Widget? title;
  final double? fontSize;
  final Color? popupColor;

  const InformationPopup({
    Key? key,
    required this.warningMessage,
    this.title,
    this.fontSize,
    this.popupColor,
  }) : super(key: key);

  @override
  State<InformationPopup> createState() => _InformationPopupState();
}

class _InformationPopupState extends State<InformationPopup> {
  late bool showPopup;

  @override
  void initState() {
    showPopup = false;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 150));
      setState(() {
        showPopup = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Visibility(
        visible: showPopup,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1.h),
          ),
          child: Container(
            width: 75.w,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(1.h),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 90.w,
                  padding: EdgeInsets.all(1.h),
                  decoration: BoxDecoration(
                    color: widget.popupColor ?? AppColors.defaultColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(1.h),
                      topLeft: Radius.circular(1.h),
                    ),
                  ),
                  child: widget.title ?? TextWidget(
                    "AVISO",
                    textColor: AppColors.whiteColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(2.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextWidget(
                        widget.warningMessage,
                        textColor: AppColors.blackColor,
                        fontSize: widget.fontSize ?? 16.sp,
                        fontWeight: FontWeight.bold,
                        maxLines: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Center(
                          child: ButtonWidget(
                            hintText: "OK",
                            heightButton: 5.h,
                            widthButton: 32.w,
                            fontWeight: FontWeight.bold,
                            backgroundColor: widget.popupColor,
                            borderColor:  widget.popupColor,
                            onPressed: () => Get.back(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}