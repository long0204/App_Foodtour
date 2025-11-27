import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebViewWidget extends StatefulWidget {
  final String htmlContent;

  const MyWebViewWidget({Key? key, required this.htmlContent})
      : super(key: key);

  @override
  State<MyWebViewWidget> createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<MyWebViewWidget> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString('''
        <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
        </head>
        <body>
          ${widget.htmlContent}
        </body>
        </html>
      ''');
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _controller,
    );
  }
}
