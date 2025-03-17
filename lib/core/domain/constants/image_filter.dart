import 'package:multi_dropdown/multi_dropdown.dart';

class ImageStatus {
  static const int notStarted = 1;
  static const int inProgress = 2;
  static const int reprocess = 3;
  static const int review = 4;
  static const int complete = 5;
  static const int unnamed = 6;
}

class ImageFilter {
  static const int deleteFilter = -1;
}

List<DropdownItem<String>> listImageClassDropdownItem = [
  DropdownItem(
    value: '1',
    label: 'Drilling',
  ),
  DropdownItem(
    value: '2',
    label: 'Map',
  ),
  DropdownItem(
    value: '3',
    label: 'General',
  ),
];

List<DropdownItem<String>> listImageCategoryDropdownItem = [
  DropdownItem(
    value: '1',
    label: 'Standard',
  ),
  DropdownItem(
    value: '2',
    label: 'Hyperspectral',
  ),
  DropdownItem(
    value: '3',
    label: 'Optical',
  ),
  DropdownItem(
    value: '4',
    label: 'Geology Data',
  ),
];

List<DropdownItem<String>> listImageStatusDropdownItem = [
  DropdownItem(
    value: '1',
    label: 'Not Started',
  ),
  DropdownItem(
    value: '2',
    label: 'In Progress',
  ),
  DropdownItem(
    value: '3',
    label: 'Reprocess',
  ),
  DropdownItem(
    value: '4',
    label: 'Review',
  ),
  DropdownItem(
    value: '5',
    label: 'Complete',
  ),
  DropdownItem(
    value: '6',
    label: 'Unnamed',
  ),
];

List<DropdownItem<String>> listWetDryDropdownItem = [
  DropdownItem(
    value: '1',
    label: 'Wet',
  ),
  DropdownItem(
    value: '2',
    label: 'Dry',
  ),
];
