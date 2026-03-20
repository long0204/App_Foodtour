import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryDropdown extends StatefulWidget {
  const CategoryDropdown({super.key});

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  String? selectedValue;
  final List<String> categories = ["Ăn sáng", "Cà phê", "Lẩu", "Ăn vặt", "Cơm", "Hải sản"];

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
      },
      validator: (value) => value == null ? "Vui lòng chọn loại hình" : null,
    );
  }
}