// ignore_for_file: constant_identifier_names

import 'package:intl/intl.dart';

const String DAY_MONTH_YEAR = 'dd/MM/yyyy hh:mm:ss';
const String YEAR_MONTH_DAY = 'yyyy-MM-dd hh:mm:ss';
const String DAY_MONTH_YEAR_HOURS_MIN = 'dd/MM/yyyy HH:mm';
const String DAY_MONTH_YEAR_HOURS_MIN_COLON = 'dd/MM/yyyy - HH:mm';
const String DATE_FORMAT_TRANSACTION = 'dd/MM/yyyy - HH:mm:ss';
const String DAY_MONTH_YEAR_ONLY = 'dd/MM/yyyy';
const String DATE_FORMAT_STATUS = 'HH:mm, EEEE dd/MM/yyyy';
const String DATE_FORMAT_DETAIL = 'hh:mm a';
const String HOUR_FORMAT = 'HH:mm';
const String DAY_MONTH_YEAR_24H = 'dd/MM/yyyy HH:mm:ss';
const String DAY_MONTH_YEAR_NEW = 'dd/MM/yy - HH:mm';

String formatTimestampDayMonth({int? time}) {
  final parsedDate = DateTime.fromMillisecondsSinceEpoch(time ?? 1);
  final formatter = DateFormat(DAY_MONTH_YEAR);
  final String formatted = formatter.format(parsedDate);
  return formatted;
}

String formatTimestampDayMonthOnly(DateTime? dateTime,
    {DateFormat? dateFormat}) {
  if (dateTime == null) return '';
  final formatter = dateFormat ?? DateFormat(DAY_MONTH_YEAR_ONLY);
  final String formatted = formatter.format(dateTime);
  return formatted;
}

/// getDateRangeStr
/// @startTime
/// @endTime
String getDateRangeStr(DateTime? startTime, DateTime? endTime,
    {DateFormat? dateFormat}) {
  return '${formatTimestampDayMonthOnly(startTime, dateFormat: dateFormat)} - ${formatTimestampDayMonthOnly(endTime, dateFormat: dateFormat)}';
}

String formatTimeFromString(String dateTime) {
  return DateFormat(DAY_MONTH_YEAR_HOURS_MIN_COLON)
      .format(DateTime.parse(dateTime));
}

String formatTimeFromDateTime(DateTime? dateTime) {
  if (dateTime == null) return '';
  final formatter = DateFormat(DAY_MONTH_YEAR_HOURS_MIN_COLON);
  final String formatted = formatter.format(dateTime);
  return formatted;
}

String formatTimeFromStringWithFormat(String dateTime, String format) {
  return DateFormat(format).format(DateTime.parse(dateTime));
}

String convertTime(String dateTime, String beginFormat, String toFormat) {
  final date = DateFormat(beginFormat).parse(dateTime);
  return DateFormat(toFormat).format(date);
}

String formatTime(DateTime? datetime) =>
    datetime != null ? DateFormat(HOUR_FORMAT).format(datetime) : '';

String getTimeAgo(DateTime datetime) {
  final now = DateTime.now();
  final difference = now.difference(datetime);
  final minutes = difference.inMinutes;
  final hours = difference.inHours;

  if (minutes < 1) {
    return 'vài giây trước';
  } else if (minutes < 60) {
    return '$minutes phút trước';
  }
  if (hours < 1) {
    return 'vài phút trước';
  } else if (hours == 1) {
    return '1 giờ trước';
  } else if (hours < 24) {
    return '$hours giờ trước';
  } else {
    final days = (hours / 24).floor();
    return '$days ngày trước';
  }
}

String formatDuration(int seconds) {
  final minutes = seconds ~/ 60;
  final remainingSeconds = seconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
}
