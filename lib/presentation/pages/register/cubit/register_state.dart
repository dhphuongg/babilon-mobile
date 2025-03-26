part of 'register_cubit.dart';

enum RegisterStep { form, otp }

class RegisterState extends Equatable {
  final String? error;
  final RegisterStep currentStep;
  final LoadStatus? requestRegisterStatus;
  final LoadStatus? registerStatus;

  const RegisterState({
    this.error,
    this.currentStep = RegisterStep.form,
    this.requestRegisterStatus,
    this.registerStatus,
  });

  RegisterState copyWith({
    bool? isLoading,
    String? error,
    RegisterStep? currentStep,
    bool? isEnable,
    LoadStatus? requestRegisterStatus,
    LoadStatus? registerStatus,
  }) {
    return RegisterState(
      error: error,
      currentStep: currentStep ?? this.currentStep,
      requestRegisterStatus:
          requestRegisterStatus ?? this.requestRegisterStatus,
      registerStatus: registerStatus ?? this.registerStatus,
    );
  }

  @override
  List<Object?> get props => [
        error,
        currentStep,
        requestRegisterStatus,
        registerStatus,
      ];
}
