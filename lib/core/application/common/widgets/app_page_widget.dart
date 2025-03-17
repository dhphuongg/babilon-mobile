import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../domain/constants/app_colors.dart';

class AppPageWidget extends StatelessWidget {
  final bool isLoading;
  final Widget body;
  final VoidCallback? onRefresh;
  final PreferredSizeWidget? appbar;
  final VoidCallback? onGoBack;
  final bool? extendBodyBehindAppBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool showFullLoading;

  const AppPageWidget({
    Key? key,
    this.isLoading = false,
    required this.body,
    this.onRefresh,
    this.appbar,
    this.onGoBack,
    this.extendBodyBehindAppBar = false,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.showFullLoading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: AppColors.white,
        extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
        appBar: appbar,
        resizeToAvoidBottomInset: true,
        body: WillPopScope(
          onWillPop: () {
            if (isLoading) {
              return Future.value(false);
            }

            if (onGoBack != null) {
              onGoBack!.call();
            }
            return Future.value(true);
          },
          child: body,
        ),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      ),
      isLoading ? _buildFullLoading(context) : const SizedBox(),
    ]);
  }

  Widget _buildFullLoading(context) {
    if (!showFullLoading) {
      return Container(
        width: 1.sw,
        height: 1.sh,
        color: Colors.transparent,
      );
    }

    return Positioned(
      width: 1.sw,
      height: 1.sh,
      child: Container(
        color: Colors.black54,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.main),
        ),
      ),
    );
  }
}
