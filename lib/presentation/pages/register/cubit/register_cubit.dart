import 'package:babilon/core/application/repositories/auth_repository.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/core/domain/utils/navigation_services.dart';
import 'package:babilon/presentation/routes/route_name.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository authRepository;

  RegisterCubit({required this.authRepository}) : super(const RegisterState());

  void changeStep(RegisterStep step) {
    emit(state.copyWith(currentStep: step));
  }

  Future<void> register() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      emit(state.copyWith(
        isLoading: false,
        currentStep: RegisterStep.otp,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> verifyOtp() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      Navigator.pushNamedAndRemoveUntil(
        NavigationService.navigatorKey.currentContext!,
        RouteName.home,
        (route) => false,
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
