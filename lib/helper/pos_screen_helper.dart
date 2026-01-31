import 'package:intl/intl.dart';

class PosScreenHelper{

  static bool isProductUnAvailable(String? startTime, String? endTime){
    DateTime now = DateTime.now();
    DateTime? _startTime = startTime != null ? parseTimeWithSeconds(startTime) : null;
    DateTime? _endTime = endTime != null ? parseTimeWithSeconds(endTime) : null;


    if (_startTime != null && _endTime != null) {
      return !(now.isAfter(_startTime) && now.isBefore(_endTime));
    }else{
      return false;
    }
  }

  static DateTime parseTimeWithSeconds(String timeStr) {
    final now = DateTime.now();
    final format = DateFormat("HH:mm:ss");
    final time = format.parse(timeStr);
    return DateTime(now.year, now.month, now.day, time.hour, time.minute, time.second);
  }
}