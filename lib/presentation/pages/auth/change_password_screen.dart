import 'package:babilon/core/application/common/widgets/app_page_widget.dart';
import 'package:babilon/core/application/common/widgets/app_snack_bar.dart';
import 'package:babilon/core/application/common/widgets/button/app_button.dart';
import 'package:babilon/core/application/common/widgets/input/app_text_field.dart';
import 'package:babilon/core/application/models/request/auth/change_password.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_padding.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/presentation/pages/auth/cubit/auth_cubit.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late AuthCubit _cubit;
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showCurrentPass = false;
  bool _showNewPass = false;
  bool _showConfirmPass = false;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<AuthCubit>(context);
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onToggleCurrentPass() {
    setState(() {
      _showCurrentPass = !_showCurrentPass;
    });
  }

  void _onToggleNewPass() {
    setState(() {
      _showNewPass = !_showNewPass;
    });
  }

  void _onToggleConfirmPass() {
    setState(() {
      _showConfirmPass = !_showConfirmPass;
    });
  }

  Future<void> _handleChangePassword() async {
    if (_formKey.currentState!.validate()) {
      await _cubit.changePassword(
        ChangePassword(
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.changePasswordStatus != current.changePasswordStatus,
      listenWhen: (previous, current) =>
          previous.changePasswordStatus != current.changePasswordStatus,
      listener: (context, state) async {
        if (state.changePasswordStatus == LoadStatus.SUCCESS) {
          await _cubit.logout();
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteName.login,
              (route) => false,
            );
          }
          AppSnackBar.showSuccess(
            'Đổi mật khẩu thành công. Vui lòng đăng nhập lại',
          );
        } else if (state.changePasswordStatus == LoadStatus.FAILURE) {
          AppSnackBar.showError(state.errChangePassword ?? 'Có lỗi xảy ra');
        }
      },
      builder: (context, state) {
        return AppPageWidget(
          appbar: AppBar(
            title: const Text(
              'Đổi mật khẩu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      AppTextField(
                        label: 'Mật khẩu hiện tại',
                        hintText: 'Nhập mật khẩu hiện tại',
                        isRequired: true,
                        controller: _currentPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        suffixIcon: IconButton(
                          onPressed: _onToggleCurrentPass,
                          icon: Icon(
                            !_showCurrentPass
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.gray,
                          ),
                        ),
                        obscureText: !_showCurrentPass,
                      ),
                      SizedBox(height: AppPadding.input),
                      AppTextField(
                        label: 'Mật khẩu mới',
                        hintText: 'Nhập mật khẩu mới',
                        isRequired: true,
                        controller: _newPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        suffixIcon: IconButton(
                          onPressed: _onToggleNewPass,
                          icon: Icon(
                            !_showNewPass
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.gray,
                          ),
                        ),
                        obscureText: !_showNewPass,
                        validateFunction: (String? value) {
                          if (value == _currentPasswordController.text) {
                            return 'Mật khẩu mới không được trùng với mật khẩu hiện tại';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppPadding.input),
                      AppTextField(
                        label: 'Xác nhận mật khẩu mới',
                        hintText: 'Nhập lại mật khẩu mới',
                        isRequired: true,
                        controller: _confirmPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        suffixIcon: IconButton(
                          onPressed: _onToggleConfirmPass,
                          icon: Icon(
                            !_showConfirmPass
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.gray,
                          ),
                        ),
                        obscureText: !_showConfirmPass,
                        validateFunction: (String? value) {
                          if (value != _newPasswordController.text) {
                            return 'Mật khẩu không khớp';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          disable:
                              state.changePasswordStatus == LoadStatus.LOADING,
                          text: 'Đổi mật khẩu',
                          onPressed: _handleChangePassword,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
