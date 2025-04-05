import 'package:babilon/core/domain/constants/api.dart';

class StringUtils {
// format big number
  static String formatNumber(int number) {
    if (number < 1000) {
      return number.toString();
    } else if (number < 1000000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else if (number < 1000000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    }
  }

  static String getImgUrl(String imgUrl) {
    return '${Api.baseUrl}/$imgUrl';
  }
}
