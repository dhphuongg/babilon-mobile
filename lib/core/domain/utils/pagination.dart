import 'package:babilon/core/domain/constants/pagination.dart';

bool hasNextPage({int? total, required int currentPage}) {
  if ((total ?? 0) > currentPage * Pagination.itemsPerPage) {
    return true;
  }
  return false;
}

int currentPage({int? currentPage, bool? hasNextPage}) {
  if (hasNextPage == true) {
    return (currentPage ?? 0) + 1;
  }
  return currentPage ?? 0;
}

int lastPage({int? total}) {
  return ((total ?? 0) + Pagination.itemsPerPage - 1) ~/
      Pagination.itemsPerPage;
}
