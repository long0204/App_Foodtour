import 'package:intl/intl.dart';


String toUIDate(String? backendDate) {
  if (backendDate == null) return '';
  try {
    final date = DateFormat('yyyy-MM-dd').parse(backendDate);
    return DateFormat('dd/MM/yyyy').format(date);
  } catch (e) {
    return ''; // Trả về chuỗi rỗng nếu không hợp lệ
  }
}

// Chuyển từ định dạng UI (dd/MM/yyyy) sang BE (yyyy-MM-dd)
String toBEDate(String? uiDate) {
  if (uiDate == null) return '';

  try {
    final date = DateFormat('dd/MM/yyyy').parse(uiDate);
    return DateFormat('yyyy-MM-dd').format(date);
  } catch (e) {
    return ''; // Trả về chuỗi rỗng nếu không hợp lệ
  }
}

String formatDateBEUpdate(DateTime dateTime) {
  String year = dateTime.year.toString();
  String month =
      dateTime.month < 10 ? '0${dateTime.month}' : '${dateTime.month}';
  String day = dateTime.day < 10 ? '0${dateTime.day}' : '${dateTime.day}';
  return '$year-$month-$day';
}

String formatDate2(DateTime dateTime) {
  String year = dateTime.year.toString();
  String month =
      dateTime.month < 10 ? '0${dateTime.month}' : '${dateTime.month}';
  String day = dateTime.day < 10 ? '0${dateTime.day}' : '${dateTime.day}';
  return '$day/$month/$year';
}
