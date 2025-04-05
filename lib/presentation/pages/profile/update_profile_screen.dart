import 'package:babilon/core/application/common/widgets/app_page_widget.dart';
import 'package:babilon/core/application/common/widgets/app_snack_bar.dart';
import 'package:babilon/core/application/common/widgets/input/app_text_field.dart';
import 'package:babilon/core/application/models/entities/user.entity.dart';
import 'package:babilon/core/application/models/request/user/update_profile.request.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_padding.dart';
import 'package:babilon/core/domain/constants/app_text_styles.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/presentation/pages/profile/cubit/user_cubit.dart';
import 'package:babilon/presentation/pages/profile/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileScreen extends StatefulWidget {
  final UserEntity user;

  const UpdateProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late UserCubit _cubit;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _signatureController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<UserCubit>(context);

    _usernameController.text = widget.user.username;
    _fullNameController.text = widget.user.fullName;
    _signatureController.text = widget.user.signature ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState?.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    _signatureController.dispose();
    _cubit.close();
  }

  Future<void> _updateAvatar() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (!mounted) return;
      await _cubit.updateProfile(
        UpdateProfileRequest(avatar: image.path),
      );
    }
  }

  Future<void> handleUpdateProfile() async {
    if (_formKey.currentState!.validate()) {
      await _cubit.updateProfile(
        UpdateProfileRequest(
          username: _usernameController.text,
          fullName: _fullNameController.text,
          signature: _signatureController.text,
        ),
      );
    }
  }

  bool hasUnsavedChanges() {
    return _usernameController.text != widget.user.username ||
        _fullNameController.text != widget.user.fullName ||
        _signatureController.text != (widget.user.signature ?? '');
  }

  Future<bool> _onWillPop() async {
    if (hasUnsavedChanges()) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.white,
          title: const Text('Hủy thay đổi?'),
          content: const Text('Bạn có chắc chắn muốn hủy các thay đổi?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Không'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Có'),
            ),
          ],
        ),
      );
      return result ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: BlocConsumer<UserCubit, UserState>(
        listenWhen: (previous, current) =>
            previous.updateStatus != current.updateStatus,
        buildWhen: (previous, current) =>
            previous.updateStatus != current.updateStatus,
        listener: (context, state) {
          if (state.updateStatus == LoadStatus.FAILURE) {
            AppSnackBar.showError(state.error!);
          } else if (state.updateStatus == LoadStatus.SUCCESS) {
            Navigator.pop(context, true);
            AppSnackBar.showSuccess('Cập nhật thành công');
          }
        },
        builder: (context, state) => GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: AppPageWidget(
            isLoading: _cubit.state.updateStatus == LoadStatus.LOADING,
            appbar: AppBar(
              title: Text('Sửa hồ sơ', style: AppStyle.bold18black),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actionsPadding: EdgeInsets.symmetric(
                horizontal: AppPadding.horizontal,
              ),
              actions: [
                GestureDetector(
                  onTap: handleUpdateProfile,
                  child: Text('Lưu', style: AppStyle.bold17black),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _updateAvatar,
                      child: ProfileAvatar(avatar: widget.user.avatar),
                    ),
                    SizedBox(height: 40.h),
                    // username
                    AppTextField(
                      label: 'ID',
                      controller: _usernameController,
                      validateFunction: (username) {
                        if (username == null || username.isEmpty) {
                          return 'ID không được để trống';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30.h),
                    // full name
                    AppTextField(
                      label: 'Họ và tên',
                      hintText: 'Nhập họ và tên',
                      controller: _fullNameController,
                      validateFunction: (fullName) {
                        if (fullName == null || fullName.isEmpty) {
                          return 'Họ và tên không được để trống';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30.h),
                    // signature
                    AppTextField(
                      label: 'Giới thiệu',
                      hintText: 'Nhập giới thiệu',
                      controller: _signatureController,
                      keyboardType: TextInputType.multiline,
                      maxLength: 100,
                      maxLine: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
