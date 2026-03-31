import 'package:flutter/material.dart';
import '../../../config/themes/text_style.dart';
import '../../../core/api/api_client.dart';

class HistoryScreen extends StatefulWidget {
  final String uid;
  const HistoryScreen({super.key, required this.uid});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> _historyList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    try {
      final data = await apiClient.get('/users/${widget.uid}/history');
      setState(() {
        _historyList = data as List;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quán ăn đã đánh giá", style: k2d600.s18)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _historyList.isEmpty
          ? const Center(child: Text("Bạn chưa đánh giá quán nào."))
          : ListView.builder(
        itemCount: _historyList.length,
        itemBuilder: (context, index) {
          final item = _historyList[index];
          final res = item['restaurants'];
          return ListTile(
            title: Text(res['name'] ?? 'Không rõ tên quán'),
            subtitle: Text(item['comment'] ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 16),
                Text(" ${item['rating']}"),
              ],
            ),
          );
        },
      ),
    );
  }
}