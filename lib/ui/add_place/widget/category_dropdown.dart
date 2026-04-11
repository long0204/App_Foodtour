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
  final List<String> categories = ["Bánh", "Coffee", "Lẩu", "Bún", "Chay", "Chè", "Gà", "Nem", "Nướng", "Ốc", "Trà sữa", "Vịt", "Cơm"];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      menuMaxHeight: 200.h,

      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      icon: Icon(Icons.keyboard_arrow_down_rounded, color: const Color(0xFFD17C7C), size: 24.sp),

      decoration: InputDecoration(
        labelText: "Loại hình quán",
        labelStyle: TextStyle(color: Colors.grey[700], fontSize: 14.sp),
        prefixIcon: const Icon(Icons.category_outlined, color: Color(0xFFD17C7C)),
        filled: true,
        fillColor: const Color(0xFFF5F1EA),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFE8C39F), width: 2),
        ),
      ),

      initialValue: selectedValue,
      items: categories.map((c) => DropdownMenuItem(
          value: c,
          child: Text(c, style: TextStyle(fontSize: 14.sp, color: Colors.black87))
      )).toList(),

      onChanged: (val) {
        setState(() => selectedValue = val);
        if (val != null) widget.onCategorySelected(val);
      },

      validator: (value) => value == null ? "Hãy chọn một danh mục" : null,
    );
  }
}