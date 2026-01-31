
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class DateConverterHelper {
  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime);
  }

  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static DateTime convertStringToDatetime(String dateTime) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(dateTime);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime, true).toLocal();
  }

  static String isoStringToLocalTimeOnly(String dateTime) {
    return DateFormat('hh:mm aa').format(isoStringToLocalDate(dateTime));
  }
  static String isoStringToLocalAMPM(String dateTime) {
    return DateFormat('a').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime.toUtc());
  }

  static String convertTimeToTime(String time) {
    return DateFormat('hh:mm a').format(DateFormat('hh:mm:ss').parse(time));
  }

  static String dateTimeStringToWeekDateMonthAndTime(String dateTime) {
    return DateFormat('EEEE, dd MMM yyyy HH:mm a').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToDateMonthYearWithLocal (String dateTime){
    return DateFormat('d MMM, yyyy, h:mm a').format(isoStringToLocalDate(dateTime));
  }

  static String dateStringMonthYear(DateTime ? dateTime) {
    return DateFormat('d MMM,y').format(dateTime!);
  }

  static String convertTimeOfDayToString(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }

  static String? convertAmPmTo24Hour(String? timeString) {
    if (timeString == null || timeString.trim().isEmpty) return null;
    try {
      final dateTime = DateFormat.jm().parse(timeString);
      return DateFormat.Hm().format(dateTime);
    } catch (_) {
      return null;
    }
  }

  static String? convert24HourToAmPm(String? timeString) {
    if (timeString == null || timeString.trim().isEmpty) return null;
    try {
      final dateTime = DateFormat.Hm().parse(timeString); // parses "21:05"
      return DateFormat.jm().format(dateTime); // returns "9:05 PM"
    } catch (_) {
      return null;
    }
  }




}
