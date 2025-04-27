import 'dart:async';

import 'package:babilon/core/application/models/request/auth/reset_password.dart';
import 'package:babilon/core/application/models/request/otp/verify.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_spacing.dart';
import 'package:babilon/core/domain/enum/otp_type.dart';
import 'package:babilon/core/domain/validators/validators.dart';
import 'package:babilon/presentation/pages/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:babilon/core/application/common/widgets/button/app_button.dart';
import 'package:babilon/core/application/common/widgets/app_page_widget.dart';
import 'package:babilon/core/application/common/widgets/app_snack_bar.dart';
import 'package:babilon/core/application/common/widgets/input/app_text_field.dart';
import 'package:babilon/core/domain/constants/app_text_styles.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babilon/core/domain/constants/app_padding.dart';

enum ResetPasswordStep { requestForm, verifyForm, resetForm }

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late AuthCubit _cubit;

  ResetPasswordStep currentStep = ResetPasswordStep.requestForm;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late String? _authToken;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  int time = 60;
  Timer? _timer;

  void startTimer() {
    _timer?.cancel();
    setState(() => time = 5);

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

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<AuthCubit>(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> handleRequestResetPassword() async {
    if (_formKey.currentState!.validate()) {
      await _cubit.requestResetPassword(_emailController.text);
    }
  }

  Future<void> verifyOtp(String otpCode) async {
    _authToken = await _cubit.verifyOtp(
      VerifyOtp(
        email: _emailController.text,
        type: OtpType.PASSWORD_RESET,
        otpCode: otpCode,
      ),
    );
  }

  Future<void> handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      await _cubit.resetPassword(
        ResetPassword(
          newPassword: _passwordController.text,
          token: _authToken ?? '',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.requestResetPasswordStatus !=
              current.requestResetPasswordStatus,
          listener: (context, state) {
            if (state.requestResetPasswordStatus == LoadStatus.SUCCESS) {
              setState(() {
                currentStep = ResetPasswordStep.verifyForm;
                startTimer();
              });
            }
            if (state.requestResetPasswordStatus == LoadStatus.FAILURE) {
              AppSnackBar.showError(state.errResetPassword ?? '');
            }
          },
        ),
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.resetPasswordVerifyOtpStatus !=
              current.resetPasswordVerifyOtpStatus,
          listener: (context, state) {
            if (state.resetPasswordVerifyOtpStatus == LoadStatus.SUCCESS) {
              setState(() {
                currentStep = ResetPasswordStep.resetForm;
              });
            }
            if (state.resetPasswordVerifyOtpStatus == LoadStatus.FAILURE) {
              AppSnackBar.showError(state.errResetPassword ?? '');
            }
          },
        ),
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.resetPasswordStatus != current.resetPasswordStatus,
          listener: (context, state) {
            if (state.resetPasswordStatus == LoadStatus.SUCCESS) {
              Navigator.of(context).pop();
              AppSnackBar.showSuccess('Đặt lại mật khẩu thành công');
            }
            if (state.resetPasswordStatus == LoadStatus.FAILURE) {
              AppSnackBar.showError(state.errResetPassword ?? '');
            }
          },
        ),
      ],
      child: BlocBuilder<AuthCubit, AuthState>(
        bloc: _cubit,
        buildWhen: (previous, current) =>
            previous.requestResetPasswordStatus !=
                current.requestResetPasswordStatus ||
            previous.resetPasswordVerifyOtpStatus !=
                current.resetPasswordVerifyOtpStatus ||
            previous.resetPasswordStatus != current.resetPasswordStatus,
        builder: (context, state) => AppPageWidget(
          appbar: currentStep == ResetPasswordStep.requestForm
              ? AppBar(
                  backgroundColor: AppColors.white,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  title: const Text('Quên mật khẩu'),
                )
              : null,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
              child: Form(
                key: _formKey,
                child: currentStep == ResetPasswordStep.requestForm
                    ? _buildRequestResetPasswordForm()
                    : currentStep == ResetPasswordStep.verifyForm
                        ? _buildVerifyOtpForm()
                        : _buildResetPasswordForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _buildResetPasswordForm() {
    return Column(
      children: <Widget>[
        SizedBox(height: 20.h),
        AppTextField(
          label: 'Mật khẩu mới',
          hintText: 'Nhập mật khẩu mới',
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
          validateFunction: (password) {
            if (password != _passwordController.text) {
              return 'Mật khẩu không khớp';
            }
            return null;
          },
          keyboardType: TextInputType.visiblePassword,
          obscureText: _obscureConfirmPassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
              color: AppColors.gray,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
        ),
        SizedBox(height: 20.h),
        BlocBuilder<AuthCubit, AuthState>(
          builder: (_, state) {
            return SizedBox(
              height: AppSpacing.buttonHeight,
              child: AppButton(
                text: 'Đặt lại mật khẩu',
                disable: state.loginStatus == LoadStatus.LOADING,
                onPressed: handleResetPassword,
                textStyle: AppStyle.semiBold18white,
              ),
            );
          },
        ),
      ],
    );
  }

  Column _buildVerifyOtpForm() {
    return Column(
      children: <Widget>[
        SizedBox(height: 20.h),
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
          onSubmit: (String verificationCode) async {
            await verifyOtp(verificationCode);
          },
        ),
        SizedBox(height: AppPadding.input),
        GestureDetector(
          onTap: time == 0 ? handleRequestResetPassword : null,
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
            setState(() {
              currentStep = ResetPasswordStep.requestForm;
            });
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
    );
  }

  Column _buildRequestResetPasswordForm() {
    return Column(
      children: <Widget>[
        SizedBox(height: 20.h),
        AppTextField(
          label: 'Địa chỉ email',
          hintText: 'Nhập địa chỉ email',
          isRequired: true,
          validateFunction: (email) {
            if (!Validator.validateEmail(email)) {
              return 'Địa chỉ email không hợp lệ';
            }
            return null;
          },
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 20.h),
        BlocBuilder<AuthCubit, AuthState>(
          builder: (_, state) {
            return SizedBox(
              height: AppSpacing.buttonHeight,
              child: AppButton(
                text: 'Lấy mã xác thực',
                disable: state.loginStatus == LoadStatus.LOADING,
                onPressed: handleRequestResetPassword,
                textStyle: AppStyle.semiBold18white,
              ),
            );
          },
        ),
      ],
    );
  }
}
