import 'package:babilon/core/application/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository authRepository;

  RegisterCubit({required this.authRepository}) : super(const RegisterState());

  void onChangeEmailOrUsername(String emailOrUsername) {
    emit(state.copyWith());
  }

  void onChangePassword(String password) {
    emit(state.copyWith());
  }

  Future<void> register() async {}
}
