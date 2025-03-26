import 'package:babilon/core/application/models/request/auth/register.dart';
import 'package:babilon/core/application/models/request/otp/request.dart';
import 'package:babilon/core/application/repositories/auth_repository.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:babilon/core/domain/enum/otp_type.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository authRepository;

  RegisterCubit({required this.authRepository}) : super(const RegisterState());

  void changeStep(RegisterStep step) {
    emit(state.copyWith(currentStep: step));
  }

  Future<void> requestRegister(String email) async {
    try {
      emit(state.copyWith(
        error: null,
        requestRegisterStatus: LoadStatus.LOADING,
      ));

      final response = await authRepository
          .requestOtp(RequestOtpDto(email: email, type: OtpType.REGISTER));

      if (response.success) {
        emit(state.copyWith(
          requestRegisterStatus: LoadStatus.SUCCESS,
          currentStep: RegisterStep.otp,
        ));
      } else {
        emit(state.copyWith(
          requestRegisterStatus: LoadStatus.FAILURE,
          error: response.error,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        requestRegisterStatus: LoadStatus.FAILURE,
        error: e.toString(),
      ));
    }
  }

  Future<void> register(RegisterRequest body) async {
    try {
      emit(state.copyWith(
        error: null,
        registerStatus: LoadStatus.LOADING,
      ));
      final response = await authRepository.register(body);

      if (response.success) {
        emit(state.copyWith(
          registerStatus: LoadStatus.SUCCESS,
        ));
      } else {
        emit(state.copyWith(
          registerStatus: LoadStatus.FAILURE,
          error: response.error,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
      ));
    }
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
