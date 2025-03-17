part of 'app_cubit.dart';

class AppState extends Equatable {
  final UserProfile? userProfile;
  // get projects
  final int? selectedProjectId;
  final List<DropdownItem<String>>? listProject;
  final LoadStatus? getListProjectStatus;
  final ErrorResponse? getListProjectError;
  // get prospect
  final int? selectedProspectId;
  final List<DropdownItem<String>>? listProspect;
  final LoadStatus? getListProspectStatus;
  final ErrorResponse? getListProspectError;

  const AppState({
    this.userProfile,
    // get projects
    this.selectedProjectId,
    this.listProject,
    this.getListProjectStatus,
    this.getListProjectError,
    // get prospect
    this.selectedProspectId,
    this.listProspect,
    this.getListProspectStatus,
    this.getListProspectError,
  });

  AppState copyWith({
    UserProfile? userProfile,
    // get projects
    int? selectedProjectId,
    List<DropdownItem<String>>? listProject,
    LoadStatus? getListProjectStatus,
    ErrorResponse? getListProjectError,
    // get prospect
    int? selectedProspectId,
    List<DropdownItem<String>>? listProspect,
    LoadStatus? getListProspectStatus,
    ErrorResponse? getListProspectError,
  }) {
    return AppState(
      userProfile: userProfile ?? this.userProfile,
      // get projects
      selectedProjectId: selectedProjectId ?? this.selectedProjectId,
      listProject: listProject ?? this.listProject,
      getListProjectStatus: getListProjectStatus ?? this.getListProjectStatus,
      getListProjectError: getListProjectError ?? this.getListProjectError,
      // get prospect
      selectedProspectId: selectedProspectId ?? this.selectedProspectId,
      listProspect: listProspect ?? this.listProspect,
      getListProspectStatus: getListProspectStatus ?? this.getListProspectStatus,
      getListProspectError: getListProspectError ?? this.getListProspectError,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        userProfile,
        // get projects
        selectedProjectId,
        listProject,
        getListProjectStatus,
        getListProjectError,
        // get prospect
        selectedProspectId,
        listProspect,
        getListProspectStatus,
        getListProspectError,
      ];
}
