// detail_screen.dart
import 'package:Foodtour/ui/detail/providers/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends ConsumerWidget {
  final Map<String, dynamic> selectedItem;

  const DetailScreen({super.key, required this.selectedItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.microtask(() {
      ref.read(detailNotifierProvider.notifier).setSelectedItem(selectedItem);
    });

    final item = ref.watch(detailNotifierProvider).selectedItem;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin quán', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent[100],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Lottie.asset('asset/nhieutim.json', fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _InfoCard(item: item),
                const SizedBox(height: 16),
                Lottie.asset('asset/Food.json', width: 200, height: 300),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

class _InfoCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const _InfoCard({required this.item});

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          _buildRow('STT:', item['STT'].toString()),
          _buildRow('Loại:', item['Loại'], color: Colors.green, isBold: true, fontSize: 20),
          _buildCopyRow(context, 'Tên quán:', item['Tên quán'] ?? ''),
          _buildCopyRow(context, 'Địa chỉ:', item['Địa chỉ'], copyValue: item['Tên quán'] + item['Địa chỉ'], color: Colors.red),
          _buildRow('Giá:', item['Giá'], color: Colors.blue),
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
              overflow: TextOverflow.visible,  // Ensure no truncation
              softWrap: true,  // Allow text to wrap
            ),
          ),
          Expanded(
            flex: 3,  // Adjust the flex factor if needed
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
          icon: const Icon(Icons.copy),
          onPressed: () => _openGoogleMaps(context, value),
              //_copyToClipboard(context, copyValue ?? value),
        ),
      ]),
    );
  }
}
