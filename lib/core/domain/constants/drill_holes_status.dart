import 'package:multi_dropdown/multi_dropdown.dart';

class DrillHoleStatus {
  static const int notStarted = 1;
  static const int inProgress = 2;
  static const int reprocess = 3;
  static const int review = 4;
  static const int complete = 5;
  static const int exported = 6;
  static const int unnamed = 7;
}

List<DropdownItem<String>> listDrillHoleStatusDropdownItem = [
  DropdownItem(
    value: DrillHoleStatus.notStarted.toString(),
    label: 'Not Started',
  ),
  DropdownItem(
    value: DrillHoleStatus.inProgress.toString(),
    label: 'In Progress',
  ),
  DropdownItem(
    value: DrillHoleStatus.reprocess.toString(),
    label: 'Reprocess',
  ),
  DropdownItem(
    value: DrillHoleStatus.review.toString(),
    label: 'Review',
  ),
  DropdownItem(
    value: DrillHoleStatus.complete.toString(),
    label: 'Complete',
  ),
  DropdownItem(
    value: DrillHoleStatus.exported.toString(),
    label: 'Exported',
  ),
  DropdownItem(
    value: DrillHoleStatus.unnamed.toString(),
    label: 'Unnamed',
  ),
];
