import 'dart:io';

import 'package:babilon/core/application/common/widgets/app_page_widget.dart';
import 'package:babilon/core/application/common/widgets/app_snack_bar.dart';
import 'package:babilon/core/application/common/widgets/input/app_text_field.dart';
import 'package:babilon/core/application/models/entities/user.entity.dart';
import 'package:babilon/core/application/models/request/user/update_profile.request.dart';
import 'package:babilon/core/domain/constants/app_colors.dart';
import 'package:babilon/core/domain/constants/app_padding.dart';
import 'package:babilon/core/domain/constants/app_text_styles.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/core/domain/utils/permission.dart';
import 'package:babilon/core/domain/utils/string.dart';
import 'package:babilon/presentation/pages/profile/cubit/user_cubit.dart';
import 'package:babilon/presentation/pages/profile/widgets/profile_avatar.dart';
import 'package:flutter/cupertino.dart';
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
  XFile? _avatarSelected;

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

  void _viewAvatar() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: InteractiveViewer(
                    child: Image.network(
                      StringUtils.getImgUrl(widget.user.avatar!),
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.person,
                        size: 150,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleUploadAvatar() async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              // Check camera permission
              await PermissionUtil.checkCameraPermission(() async {
                final ImagePicker picker = ImagePicker();
                _avatarSelected = await picker.pickImage(
                  source: ImageSource.camera,
                );
                setState(() {});
              });
            },
            child: const Text('Chụp ảnh'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              final ImagePicker picker = ImagePicker();
              _avatarSelected = await picker.pickImage(
                source: ImageSource.gallery,
              );
              setState(() {});
            },
            child: const Text('Chọn từ thư viện'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _viewAvatar();
            },
            child: const Text('Xem ảnh'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Hủy'),
        ),
      ),
    );
  }

  Future<void> _handleUpdateProfile() async {
    if (_formKey.currentState!.validate()) {
      await _cubit.updateProfile(
        UpdateProfileRequest(
          username: _usernameController.text,
          fullName: _fullNameController.text,
          signature: _signatureController.text,
          avatar: _avatarSelected != null ? File(_avatarSelected!.path) : null,
        ),
      );
    }
  }

  bool _hasUnsavedChanges() {
    if (_avatarSelected != null) {
      return true;
    }
    return _usernameController.text != widget.user.username ||
        _fullNameController.text != widget.user.fullName ||
        _signatureController.text != (widget.user.signature ?? '');
  }

  Future<bool> _onWillPop() async {
    if (_hasUnsavedChanges()) {
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
                  onTap: _handleUpdateProfile,
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
                      onTap: _handleUploadAvatar,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _avatarSelected != null
                              ? CircleAvatar(
                                  backgroundColor: AppColors.grayF5,
                                  radius: 50.w,
                                  backgroundImage: FileImage(
                                    File(_avatarSelected!.path),
                                  ),
                                )
                              : ProfileAvatar(avatar: widget.user.avatar),
                          Container(
                            width: 100.w,
                            height: 100.w,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.25),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
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
