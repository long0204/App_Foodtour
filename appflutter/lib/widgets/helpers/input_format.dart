import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,###');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(',', '');
    if (text.isEmpty) return newValue;

    final newText = _formatter.format(int.tryParse(text) ?? 0);
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class DateTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      // Chèn dấu `/` sau ngày (xx) và tháng (xx)
      if ((i == 1 || i == 3) && i != text.length - 1) {
        buffer.write('/');
      }
    }

    final formattedText = buffer.toString();

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final cleanedText = newValue.text
        .replaceAll(RegExp(r'[^0-9]'), ''); // Xóa các ký tự không phải số

    String formattedText = '';
    int cursorPosition = 0;

    for (int i = 0; i < cleanedText.length; i++) {
      // Thêm dấu '/' vào đúng vị trí (sau ngày và tháng)
      if (i == 2 || i == 4) {
        formattedText += '/';
        if (i < newValue.selection.baseOffset) {
          cursorPosition++; // Cập nhật vị trí con trỏ khi thêm dấu '/'
        }
      }
      formattedText += cleanedText[i];
      if (i < newValue.selection.baseOffset) {
        cursorPosition++; // Cập nhật vị trí con trỏ theo số đã nhập
      }
    }

    // Giới hạn độ dài tối đa là 10 ký tự (dd/MM/yyyy)
    if (formattedText.length > 10) {
      return oldValue;
    }

    // Đảm bảo ngày hợp lệ (01-31)
    if (formattedText.length >= 2) {
      final day = int.tryParse(formattedText.substring(0, 2)) ?? 0;
      if (day < 1 || day > 31) {
        return oldValue;
      }
    }

    // Đảm bảo tháng hợp lệ (01-12)
    if (formattedText.length >= 5) {
      final month = int.tryParse(formattedText.substring(3, 5)) ?? 0;
      if (month < 1 || month > 12) {
        return oldValue;
      }
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

class ObscureTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String hiddenText = '•' * newValue.text.length;
    return newValue.copyWith(text: hiddenText, selection: newValue.selection);
  }
}

// class DateInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     final cleanedText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

//     String formattedText = '';
//     int cursorPosition = newValue.selection.baseOffset;

//     for (int i = 0; i < cleanedText.length; i++) {
//       if (i == 2 || i == 4) {
//         formattedText += '/';
//         if (i == cursorPosition - 1) {
//           cursorPosition++;
//         }
//       }
//       formattedText += cleanedText[i];
//     }

//     // **Logic giới hạn ngày**
//     if (formattedText.length >= 1) {
//       final firstDigitDay = int.tryParse(formattedText[0]) ?? 0;
//       // Số đầu tiên của ngày không được >= 4
//       if (firstDigitDay >= 4) {
//         return oldValue;
//       }
//     }

//     if (formattedText.length >= 2) {
//       final day = int.tryParse(formattedText.substring(0, 2)) ?? 0;
//       if (day < 1 || day > 31) {
//         return oldValue;
//       }
//     }

//     // **Logic giới hạn tháng**
//     if (formattedText.length >= 4) {
//       final firstDigitMonth = int.tryParse(formattedText[3]) ?? 0;
//       // Số đầu tiên của tháng không được >= 2
//       if (firstDigitMonth >= 2) {
//         return oldValue;
//       }
//     }

//     if (formattedText.length >= 5) {
//       final month = int.tryParse(formattedText.substring(3, 5)) ?? 0;
//       if (month < 1 || month > 12) {
//         return oldValue;
//       }
//     }

//     // Giới hạn độ dài tối đa là 10 ký tự (dd/MM/yyyy)
//     if (formattedText.length > 10) {
//       return oldValue;
//     }

//     return TextEditingValue(
//       text: formattedText,
//       selection: TextSelection.collapsed(offset: cursorPosition),
//     );
//   }
// }
