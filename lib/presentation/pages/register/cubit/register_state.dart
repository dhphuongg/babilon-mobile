part of 'register_cubit.dart';

enum RegisterStep { form, otp }

class RegisterState extends Equatable {
  final bool isLoading;
  final String? error;
  final RegisterStep currentStep;
  final LoadStatus? registerStatus;
  final LoadStatus? finalRegisterStatus;

  const RegisterState({
    this.isLoading = false,
    this.error,
    this.currentStep = RegisterStep.form,
    this.registerStatus,
    this.finalRegisterStatus,
  });

  RegisterState copyWith({
    bool? isLoading,
    String? error,
    RegisterStep? currentStep,
    bool? isEnable,
    LoadStatus? registerStatus,
    LoadStatus? finalRegisterStatus,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentStep: currentStep ?? this.currentStep,
      registerStatus: registerStatus ?? this.registerStatus,
      finalRegisterStatus: finalRegisterStatus ?? this.finalRegisterStatus,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        currentStep,
        registerStatus,
        finalRegisterStatus,
      ];
}
