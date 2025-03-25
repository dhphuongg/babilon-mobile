import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_spacing.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:babilon/core/application/common/widgets/button/app_button.dart';
import 'package:babilon/core/application/common/widgets/app_page_widget.dart';
import 'package:babilon/core/application/common/widgets/app_snack_bar.dart';
import 'package:babilon/core/application/common/widgets/input/app_text_field.dart';
import 'package:babilon/core/domain/constants/app_text_styles.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/presentation/pages/login/cubit/login_cubit.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:babilon/core/domain/constants/app_padding.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginCubit _cubit;
  CancelToken? _cancelToken;
  final GlobalKey _passwordKey = GlobalKey();
  late TextEditingController taxEmailController;
  late TextEditingController passwordController;
  bool password = false;
  bool showPass = false;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<LoginCubit>(context);
    _cancelToken = CancelToken();
    taxEmailController = TextEditingController(text: '');
    passwordController = TextEditingController(text: '');
    // _cubit.onChangeEmail(taxEmailController.text);
    // _cubit.onChangePassword(passwordController.text);
  }

  @override
  void dispose() {
    super.dispose();
    _cubit.close();
    taxEmailController.dispose();
    passwordController.dispose();
    _cancelToken?.cancel();
    _cancelToken = null;
  }

  void _onToggleShowPass() {
    setState(() {
      showPass = !showPass;
    });
  }

  void _onCheckPassword() {
    String text = passwordController.text;
    if (!password && text.isNotEmpty) {
      setState(() {
        password = true;
      });
    } else if (password && text.isEmpty) {
      setState(() {
        password = false;
      });
    }
  }

  Widget _buildEyeIcon() {
    return (SvgPicture.asset(
      "assets/images/icon_eye.svg",
      width: 25.w,
    ));
  }

  Widget _buildEyeCloseIcon() {
    return (SvgPicture.asset(
      "assets/images/icon_eye_close.svg",
      width: 25.w,
    ));
  }

  void handleLogin(bool? disable) {
    if (disable ?? true) return;
    _cubit.login();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.loginStatus != current.loginStatus,
      listenWhen: (previous, current) =>
          previous.loginStatus != current.loginStatus,
      listener: (context, state) {
        if (state.loginStatus == LoadStatus.SUCCESS) {
          Navigator.pushNamedAndRemoveUntil(
              context, RouteName.app, (Route<dynamic> route) => false);
        }
        if (state.loginStatus == LoadStatus.FAILURE) {
          AppSnackBar.showError(state.errLogin ?? '');
        }
      },
      builder: (context, state) {
        return AppPageWidget(
            body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    // Image.asset(Images.logo, fit: BoxFit.fill),
                    SizedBox(height: 16.h),
                    Text('Welcome back! Please enter your details',
                        style: AppStyle.medium16black),
                    SizedBox(height: 40.h),
                    BlocBuilder<LoginCubit, LoginState>(
                      buildWhen: (previous, current) =>
                          previous.emailValidate != current.emailValidate,
                      builder: (_, state) => AppTextField(
                        label: 'Tên người dùng hoặc email',
                        hintText: 'Nhập tên người dùng hoặc email',
                        // isRequired: true,
                        validator: state.emailValidate,
                        controller: taxEmailController,
                        onChanged: (value) {
                          _cubit.onChangeEmailOrUsername(value);
                        },
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    SizedBox(height: AppPadding.input),
                    BlocBuilder<LoginCubit, LoginState>(
                      buildWhen: (previous, current) =>
                          previous.passwordValidate != current.passwordValidate,
                      builder: (_, state) => AppTextField(
                        key: _passwordKey,
                        label: "Mật khẩu",
                        hintText: "Nhập mật khẩu",
                        // isRequired: true,
                        validator: state.passwordValidate,
                        controller: passwordController,
                        onChanged: (value) {
                          _onCheckPassword();
                          _cubit.onChangePassword(value);
                        },
                        suffixIcon: password
                            ? GestureDetector(
                                onTap: _onToggleShowPass,
                                child: showPass
                                    ? _buildEyeCloseIcon()
                                    : _buildEyeIcon(),
                              )
                            : const SizedBox(),
                        obscureText: !showPass,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.h),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (_, state) {
                    return SizedBox(
                      height: AppSpacing.buttonHeight,
                      child: AppButton(
                        text: 'Đăng nhập',
                        disable: !state.isEnable ||
                            state.loginStatus == LoadStatus.LOADING,
                        onPressed: () => handleLogin(!state.isEnable),
                        textStyle: AppStyle.semiBold18white,
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.h),
                RichText(
                  text: TextSpan(
                    text: "Chưa có tài khoản? ",
                    style: AppStyle.regular14black,
                    children: [
                      TextSpan(
                        text: 'Đăng ký',
                        style: AppStyle.regular14black.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.main,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pushNamed(RouteName.register);
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
      },
    );
  }
}
