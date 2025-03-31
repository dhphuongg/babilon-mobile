import 'package:babilon/core/application/models/request/auth/login_request.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_spacing.dart';
import 'package:babilon/core/domain/constants/images.dart';
import 'package:babilon/core/domain/utils/share_preferences.dart';
import 'package:babilon/presentation/pages/auth/cubit/auth_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:babilon/core/application/common/widgets/button/app_button.dart';
import 'package:babilon/core/application/common/widgets/app_page_widget.dart';
import 'package:babilon/core/application/common/widgets/app_snack_bar.dart';
import 'package:babilon/core/application/common/widgets/input/app_text_field.dart';
import 'package:babilon/core/domain/constants/app_text_styles.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babilon/core/domain/constants/app_padding.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthCubit _cubit;
  CancelToken? _cancelToken;
  final _formKey = GlobalKey<FormState>();
  final _emailOrUsernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool showPass = false;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<AuthCubit>(context);
    _cancelToken = CancelToken();
  }

  @override
  void dispose() {
    super.dispose();
    _cubit.close();
    _emailOrUsernameController.dispose();
    _passwordController.dispose();
    _cancelToken?.cancel();
    _cancelToken = null;
  }

  void _onToggleShowPass() {
    setState(() {
      showPass = !showPass;
    });
  }

  Future<void> handleLogin() async {
    if (_formKey.currentState!.validate()) {
      String deviceToken = await SharedPreferencesHelper.getStringValue(
        SharedPreferencesHelper.DEVICE_TOKEN,
      );
      await _cubit.login(
        LoginRequest(
          emailOrUsername: _emailOrUsernameController.text,
          password: _passwordController.text,
          deviceToken: deviceToken,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.loginStatus != current.loginStatus,
      listenWhen: (previous, current) =>
          previous.loginStatus != current.loginStatus,
      listener: (context, state) {
        if (state.loginStatus == LoadStatus.SUCCESS) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteName.app,
            (Route<dynamic> route) => false,
          );
          AppSnackBar.showSuccess('Đăng nhập thành công');
        }
        if (state.loginStatus == LoadStatus.FAILURE) {
          AppSnackBar.showError(
              state.errLogin ?? 'Thông tin đăng nhập không chính xác');
        }
      },
      builder: (context, state) {
        return AppPageWidget(
            body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Image.asset(Images.logoImage, fit: BoxFit.fill),
                  SizedBox(height: 16.h),
                  Text(
                    'Đăng nhập',
                    style: AppStyle.medium24black,
                  ),
                  SizedBox(height: 40.h),
                  AppTextField(
                    label: 'Tên người dùng hoặc email',
                    hintText: 'Nhập tên người dùng hoặc email',
                    isRequired: true,
                    controller: _emailOrUsernameController,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: AppPadding.input),
                  AppTextField(
                    label: "Mật khẩu",
                    hintText: "Nhập mật khẩu",
                    isRequired: true,
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordController,
                    suffixIcon: IconButton(
                      onPressed: _onToggleShowPass,
                      icon: Icon(
                        !showPass ? Icons.visibility : Icons.visibility_off,
                        color: AppColors.gray,
                      ),
                    ),
                    obscureText: !showPass,
                  ),
                  SizedBox(height: AppPadding.input),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: Text(
                          'Quên mật khẩu?',
                          style: AppStyle.regular14black.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.main,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(RouteName.resetPassword);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (_, state) {
                      return SizedBox(
                        height: AppSpacing.buttonHeight,
                        child: AppButton(
                          text: 'Đăng nhập',
                          disable: state.loginStatus == LoadStatus.LOADING,
                          onPressed: handleLogin,
                          textStyle: AppStyle.semiBold18white,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  RichText(
                    text: TextSpan(
                      text: "Bạn chưa có tài khoản? ",
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
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  RouteName.register, (route) => false);
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
      },
    );
  }
}
