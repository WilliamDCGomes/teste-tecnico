import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../utils/helpers/app_close_controller.dart';
import '../../../utils/helpers/text_field_validators.dart';
import '../../../utils/sharedWidgets/button_widget.dart';
import '../../../utils/sharedWidgets/text_field_widget.dart';
import '../../../utils/sharedWidgets/text_widget.dart';
import '../../../utils/stylePages/app_colors.dart';
import '../controller/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key,}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginPageController controller;

  @override
  void initState() {
    controller = Get.put(LoginPageController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return AppCloseController.verifyCloseScreen();
      },
      child: SafeArea(
        child: Material(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: AppColors.backgroundFirstScreenColor,
                ),
              ),
              child: Stack(
                children: [
                  Scaffold(
                    backgroundColor: AppColors.transparentColor,
                    body: Column(
                      children: [
                        Container(
                          height: 30.h,
                          width: 100.w,
                          margin: EdgeInsets.only(bottom: 6.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.h)),
                            color: AppColors.defaultColor,
                          ),
                          child: Center(
                            child: TextWidget(
                              "TESTE TÉCNICO",
                              textColor: AppColors.backgroundColor,
                              fontSize: 26.sp,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.bold,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Form(
                            key: controller.formKey,
                            child: ListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              children: [
                                TextWidget(
                                  "FAÇA LOGIN",
                                  textColor: AppColors.defaultColor,
                                  fontSize: 26.sp,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.bold,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5.h),
                                  child: Obx(
                                    () => TextFieldWidget(
                                      controller: controller.userInputController,
                                      hintText: "Usuário",
                                      height: 9.h,
                                      width: double.infinity,
                                      hasError: controller.cpfInputHasError.value,
                                      enableSuggestions: true,
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.next,
                                      validator: (String? value) {
                                        String? validation = TextFieldValidators.loginValidation(value);
                                        if(validation != null && validation != ""){
                                          controller.cpfInputHasError.value = true;
                                        }
                                        else{
                                          controller.cpfInputHasError.value = false;
                                        }
                                        return validation;
                                      },
                                      onEditingComplete: () {
                                        controller.passwordInputFocusNode.requestFocus();
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 1.5.h),
                                  child: Obx(
                                    () => TextFieldWidget(
                                      controller: controller.passwordInputController,
                                      focusNode: controller.passwordInputFocusNode,
                                      hintText: "Senha",
                                      height: 9.h,
                                      width: double.infinity,
                                      isPassword: controller.isPasswordField.value,
                                      hasError: controller.passwordInputHasError.value,
                                      validator: (String? value) {
                                        String? validation = TextFieldValidators.passwordValidation(value);
                                        if(validation != null && validation != ""){
                                          controller.passwordInputHasError.value = true;
                                        }
                                        else{
                                          controller.passwordInputHasError.value = false;
                                        }
                                        return validation;
                                      },
                                      iconTextField: GestureDetector(
                                        onTap: () {
                                          controller.isPasswordField.value =
                                          !controller.isPasswordField.value;
                                        },
                                        child: Icon(
                                          controller.isPasswordField.value
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: AppColors.defaultColor,
                                          size: 2.5.h,
                                        ),
                                      ),
                                      keyboardType: TextInputType.visiblePassword,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 3.h),
                                  child: ButtonWidget(
                                    hintText: "LOGAR",
                                    fontWeight: FontWeight.bold,
                                    widthButton: 75.w,
                                    onPressed: () => controller.loginPressed(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  controller.loadingWithSuccessOrErrorWidget,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}