import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../config/themes/color.dart';
import '../../utils/logger.dart';

class CustomWebview extends StatefulWidget {
  const CustomWebview({super.key, this.url = 'https://dinos.vn'});
  final String url;
  static const String kRouteName = '/web_view';
  @override
  State<CustomWebview> createState() => _CustomWebviewState();
}

class _CustomWebviewState extends State<CustomWebview> {
  late final WebViewController _controller;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #end docregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            logger.d('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            logger.d('Page started loading: $url');
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            logger.d('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            logger.e('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          // onNavigationRequest: (NavigationRequest request) {
          //   if (request.url.startsWith('https://www.youtube.com/')) {
          //     debugPrint('blocking navigation to ${request.url}');
          //     return NavigationDecision.prevent;
          //   }
          //   debugPrint('allowing navigation to ${request.url}');
          //   return NavigationDecision.navigate;
          // },
          // onUrlChange: (UrlChange change) {
          //   debugPrint('url change to ${change.url}');
          // },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(widget.url));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #end docregion platform_features

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            WebViewWidget(
              controller: _controller,
            ),
            _loading()
          ],
        ));
  }



  Widget _loading() {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: Center(
          child: LoadingAnimationWidget.waveDots(
            color: primary,
            size: 40,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
