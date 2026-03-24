import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryDropdown extends StatefulWidget {
  final Function(String) onCategorySelected;

  const CategoryDropdown({super.key, required this.onCategorySelected});

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  String? selectedValue;
  final List<String> categories = [
    "Bánh",
    "Coffee",
    "Lẩu",
    "Bún",
    "Chay",
    "Chè",
    "Gà",
    "Nem",
    "Nướng",
    "Ốc",
    "Trà sữa",
    "Vịt",
    "Cơm"
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Loại hình quán",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.category_outlined),
      ),
      value: selectedValue,
      items: categories.map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedValue = value;
        });
        if (value != null) {
          widget.onCategorySelected(value); // Gọi callback truyền data ra ngoài
        }
      },
      validator: (value) => value == null ? "Vui lòng chọn loại hình" : null,
    );
  }
}
