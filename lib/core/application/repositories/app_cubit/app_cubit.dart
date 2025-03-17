import 'package:babilon/core/application/api/error_response.dart';
import 'package:babilon/core/application/models/response/user/user_profile.dart';
import 'package:babilon/core/domain/enum/load_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState());

  Future<void> saveUserProfile(UserProfile userProfile) async {
    emit(state.copyWith(
      userProfile: userProfile,
      selectedProjectId: userProfile.projectId,
      selectedProspectId: userProfile.prospectId,
    ));
  }

  void onSelectProject(String? projectId) {
    if (projectId != null) {
      emit(state.copyWith(
          selectedProjectId: int.parse(projectId), selectedProspectId: -1));
    }
  }

  void onSelectProspect(String? prospectId) {
    if (prospectId != null) {
      emit(state.copyWith(selectedProspectId: int.parse(prospectId)));
    }
  }
}
