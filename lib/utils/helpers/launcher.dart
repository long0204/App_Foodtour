import 'package:url_launcher/url_launcher.dart';

import '../../../config/constants/strings.dart';

class LaunchUtil {
  LaunchUtil._internal();
  static LaunchUtil? _i;
  static LaunchUtil get instance => _i ?? LaunchUtil._internal();

  Future<bool> launch(String? url) async {
    if (url == null) return false;
    Uri uri = Uri.parse(url);
    if (!(await canLaunchUrl(uri))) return false;

    final String domain = url.split('/')[2];
    final bool containsAny =
        Strings.listAppLink.any((substring) => domain.contains(substring));

    if (domain.contains('youtube')) {
      uri = Uri.parse(url.replaceAll('www', 'm'));
    }
    final mode = containsAny
        ? LaunchMode.externalApplication
        : LaunchMode.platformDefault;

    await launchUrl(uri, mode: mode);
    return true;
  }
}

final LaunchUtil launcher = LaunchUtil.instance;
