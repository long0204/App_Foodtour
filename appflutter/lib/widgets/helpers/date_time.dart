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
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

class DateRangePicker extends StatefulWidget {
  final List<DateTime?> initialDates;
  final void Function(List<DateTime?>) onDatesSelected;

  const DateRangePicker({
    super.key,
    required this.initialDates,
    required this.onDatesSelected,
  });

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  List<DateTime?> selectedDates = [null, null];

  @override
  void initState() {
    super.initState();
    selectedDates = widget.initialDates;
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final results = await showDialog<List<DateTime?>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn khoảng ngày'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView( // Thêm SingleChildScrollView để cho phép cuộn
            child: Column(
              children: [
                // Thêm các widget khác của bạn ở đây
                CalendarDatePicker2(
                  config: CalendarDatePicker2Config(
                    calendarType: CalendarDatePicker2Type.range,
                    selectedDayHighlightColor: Colors.red,
                  ),
                  value: selectedDates,
                  onValueChanged: (value) {
                    selectedDates = value;
                  },
                ),
                // Nếu Row đang gây lỗi, thử dùng Expanded hoặc Flexible cho các phần tử trong Row
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Action cho nút này
                        },
                        child: const Text('Hủy'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, selectedDates),
                      child: const Text('Xác nhận'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (results != null && results.length >= 2) {
      widget.onDatesSelected(results);
    }
  }

  @override
  Widget build(BuildContext context) {
    final from = selectedDates[0];
    final to = selectedDates.length > 1 ? selectedDates[1] : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Thời gian dự kiến'),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _pickDateRange(context),
          icon: const Icon(Icons.date_range),
          label: Text(
            from != null && to != null
                ? '${from.day}/${from.month}/${from.year} - ${to.day}/${to.month}/${to.year}'
                : 'Chọn khoảng ngày',
          ),
        ),
      ],
    );
  }
}