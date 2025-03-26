import 'dart:async';

import 'package:babilon/core/application/common/widgets/app_page_widget.dart';
import 'package:babilon/core/application/common/widgets/app_snack_bar.dart';
import 'package:babilon/core/application/common/widgets/button/app_button.dart';
import 'package:babilon/core/application/common/widgets/input/app_text_field.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_padding.dart';
import 'package:babilon/core/domain/constants/app_spacing.dart';
import 'package:babilon/core/domain/constants/app_text_styles.dart';
import 'package:babilon/core/domain/constants/images.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/core/domain/validators/validators.dart';
import 'package:babilon/presentation/pages/register/cubit/register_cubit.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late RegisterCubit _cubit;
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  int time = 10;
  Timer? _timer;

  void startTimer() {
    _timer?.cancel();
    setState(() => time = 10);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (time > 0) {
        setState(() => time--);
      } else {
        timer.cancel();
      }
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> handleRegister() async {
    if (_formKey.currentState!.validate()) {
      _cubit.register();
    }
  }

  Future<void> resendOTP() async {
    await _cubit.verifyOtp();
    startTimer();
  }

  @override
  void initState() {
    _cubit = BlocProvider.of<RegisterCubit>(context);
    super.initState();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cubit.close();
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: AppPadding.input),
          AppTextField(
            label: 'Họ tên',
            hintText: 'Nhập họ tên',
            isRequired: true,
            controller: _fullNameController,
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: AppPadding.input),
          AppTextField(
            label: 'Email',
            hintText: 'Nhập email',
            isRequired: true,
            validateFunction: (value) {
              if (!Validator.validateEmail(value)) {
                return 'Email không hợp lệ';
              }
              return null;
            },
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: AppPadding.input),
          AppTextField(
            label: 'Mật khẩu',
            hintText: 'Nhập mật khẩu',
            isRequired: true,
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: AppColors.gray,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          SizedBox(height: AppPadding.input),
          AppTextField(
            label: 'Xác nhận mật khẩu',
            hintText: 'Nhập lại mật khẩu',
            isRequired: true,
            validateFunction: (confirmPassword) {
              if (confirmPassword != _passwordController.text) {
                return 'Mật khẩu không khớp';
              }
              return null;
            },
            controller: _confirmPasswordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: _obscureConfirmPassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: AppColors.gray,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),
          SizedBox(height: 40.h),
          BlocBuilder<RegisterCubit, RegisterState>(
            builder: (_, state) {
              return SizedBox(
                height: AppSpacing.buttonHeight,
                child: AppButton(
                  text: 'Đăng ký',
                  disable: state.registerStatus == LoadStatus.LOADING,
                  onPressed: handleRegister,
                  textStyle: AppStyle.semiBold18white,
                ),
              );
            },
          ),
          SizedBox(height: 20.h),
          RichText(
            text: TextSpan(
              text: "Bạn đã có tài khoản? ",
              style: AppStyle.regular14black,
              children: [
                TextSpan(
                  text: 'Đăng nhập',
                  style: AppStyle.regular14black.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.main,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          RouteName.login, (route) => false);
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpVerification() {
    return Form(
      child: Column(
        children: <Widget>[
          const Text(
            'Nhập mã OTP đã được gửi đến email của bạn',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppPadding.input),
          OtpTextField(
            numberOfFields: 6,
            showFieldAsBox: true,
            cursorColor: AppColors.main,
            focusedBorderColor: AppColors.main,
            onCodeChanged: (String code) {},
            onSubmit: (String verificationCode) {},
          ),
          SizedBox(height: AppPadding.input),
          GestureDetector(
            onTap: time == 0 ? resendOTP : null,
            child: Text(
              time > 0 ? 'Gửi lại OTP sau: ${formatTime(time)}' : 'Gửi lại OTP',
              style: TextStyle(
                color: time == 0 ? AppColors.main : AppColors.gray,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: AppPadding.input),
          GestureDetector(
            onTap: () {
              _cubit.changeStep(RegisterStep.form);
            },
            child: const Text(
              'Chỉnh sửa thông tin',
              style: TextStyle(
                color: AppColors.main,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.error != null) {
          AppSnackBar.showError(state.error!);
          _cubit.clearError();
        }
        if (state.currentStep == RegisterStep.otp) {
          startTimer();
        }
      },
      builder: (context, state) {
        return AppPageWidget(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
              child: Column(
                children: [
                  Image.asset(Images.logoImage, fit: BoxFit.fill),
                  SizedBox(height: 16.h),
                  Text(
                    state.currentStep == RegisterStep.form
                        ? 'Đăng ký tài khoản'
                        : 'Xác thực OTP',
                    style: AppStyle.medium24black,
                  ),
                  SizedBox(height: 40.h),
                  state.currentStep == RegisterStep.form
                      ? _buildRegisterForm()
                      : _buildOtpVerification(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
