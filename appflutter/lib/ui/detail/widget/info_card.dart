import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const InfoCard({super.key, required this.item});

  void _copyToClipboard(BuildContext context, String textToCopy) {
    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green[400],
        content: const Text('Đã sao chép địa chỉ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openGoogleMaps(BuildContext context, String address) async {
    final Uri googleMapsUri = Uri.parse("https://www.google.com/maps/search/?q=$address");
    if (await canLaunch(googleMapsUri.toString())) {
      await launch(googleMapsUri.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể mở Google Maps', style: TextStyle(fontWeight: FontWeight.bold)),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          _buildRow('STT:', item['STT']?.toString() ?? 'Không xác định'),
          _buildRow('Loại:', item['Loại'] ?? 'Không có', color: Colors.green, isBold: true, fontSize: 20),
          _buildCopyRow(context, 'Tên quán:', item['Tên quán'] ?? 'Chưa có tên'),
          _buildCopyRow(
            context,
            'Địa chỉ:',
            item['Địa chỉ'] ?? 'Chưa có địa chỉ',
            copyValue: (item['Tên quán'] ?? '') + (item['Địa chỉ'] ?? ''),
            color: Colors.red,
          ),
          _buildRow('Giá:', item['Giá']?.toString() ?? '0.0', color: Colors.blue),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? color, bool isBold = false, double fontSize = 16}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: fontSize,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyRow(BuildContext context, String label, String value, {String? copyValue, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: color ?? Colors.orange, fontWeight: FontWeight.bold, fontSize: 17),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.location_on, color: Colors.red),
          onPressed: () {
            _openGoogleMaps(context, value);
            _copyToClipboard(context, copyValue ?? value);
          },
        ),
      ]),
    );
  }
}
