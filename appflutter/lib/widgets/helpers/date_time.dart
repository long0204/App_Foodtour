// // import 'package:intl/intl.dart';

// import 'package:intl/intl.dart';

// import '../../../config/l10n/export.dart';

// class DateTimeUtil {
//   static DateTimeUtil? _instance;

//   DateTimeUtil._();

//   static DateTimeUtil get instance => _instance ??= DateTimeUtil._();

//   static DateTime? fromMillisecondsSinceEpoch(String? d) {
//     if (d == null) return null;
//     final int epochTime = int.parse(d);

//     return DateTime.fromMillisecondsSinceEpoch(epochTime * 1000);
//   }

//   static String getDateNow(AppLocalizations l10n) {
//     final date = DateTime.now().toLocal();
//     final String formattedDate = DateFormat('EEEE').format(date);
//     final String d = DateFormat('dd/MM/yyyy').format(date);
//     return '$formattedDate,${l10n.day} $d';
//   }
// }

// final dateUtil = DateTimeUtil.instance;
