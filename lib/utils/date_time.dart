// import 'package:intl/intl.dart';

import 'package:intl/intl.dart';



class DateTimeUtil {
  static DateTimeUtil? _instance;

  DateTimeUtil._();

  static DateTimeUtil get instance => _instance ??= DateTimeUtil._();

  static DateTime? fromMillisecondsSinceEpoch(String? d) {
    if (d == null) return null;
    final int epochTime = int.parse(d);

    return DateTime.fromMillisecondsSinceEpoch(epochTime * 1000);
  }


  static String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final isToday = now.year == timestamp.year &&
        now.month == timestamp.month &&
        now.day == timestamp.day;

    if (isToday) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      final weekdayMap = {
        DateTime.monday: 'Thứ 2',
        DateTime.tuesday: 'Thứ 3',
        DateTime.wednesday: 'Thứ 4',
        DateTime.thursday: 'Thứ 5',
        DateTime.friday: 'Thứ 6',
        DateTime.saturday: 'Thứ 7',
        DateTime.sunday: 'Chủ nhật',
      };

      final weekday = weekdayMap[timestamp.weekday] ?? '';
      final formattedDate =
          '${timestamp.day.toString().padLeft(2, '0')}/${timestamp.month.toString().padLeft(2, '0')}/${timestamp.year}';
      final formattedTime =
          '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
      return '$weekday, $formattedDate $formattedTime';
    }
  }

}

final dateUtil = DateTimeUtil.instance;
