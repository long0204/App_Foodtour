import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddRestaurantDialog extends StatefulWidget {
  final void Function(String type, String name, String address, String price) onSubmit;

  const AddRestaurantDialog({super.key, required this.onSubmit});

  @override
  State<AddRestaurantDialog> createState() => _AddRestaurantDialogState();
}

class _AddRestaurantDialogState extends State<AddRestaurantDialog> {
  final _formKey = GlobalKey<FormState>();

  // Danh sách loại quán
  final List<String> _types = ['Bún', 'Phở', 'Lẩu', 'Nướng', 'Gà Rán/Đồ Hàn', 'Coffee', 'Cơm', 'Chè','Ăn Vặt','Vịt'];

  String? _selectedType;
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    widget.onSubmit(
      _selectedType!.trim(),
      _nameController.text.trim(),
      _addressController.text.trim(),
      _priceController.text.trim(),
    );
    Navigator.of(context).pop();
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.redAccent),
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: Colors.grey[100],
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Thêm địa chỉ mới',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            SizedBox(height: 16.h),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: _inputDecoration('Loại quán', Icons.category),
                    items: _types.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value;
                      });
                    },
                    validator: (value) => value == null || value.isEmpty ? 'Chọn loại quán' : null,
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration('Tên quán', Icons.store),
                    validator: (value) => value!.isEmpty ? 'Nhập tên quán' : null,
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: _addressController,
                    decoration: _inputDecoration('Địa chỉ', Icons.location_on),
                    validator: (value) => value!.isEmpty ? 'Nhập địa chỉ' : null,
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: _priceController,
                    decoration: _inputDecoration('Giá (nếu có)', Icons.attach_money),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Hủy'),
                ),
                ElevatedButton.icon(
                  onPressed: _handleSubmit,
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: const Text('Thêm', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
