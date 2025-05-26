import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:Foodtour/extensions/obj.dart';
import 'package:html/dom.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:upgrader/upgrader.dart';

import '../config/constants/strings.dart';
import '../config/l10n/l10n.dart';
import '../utils/util.dart';
import '../widgets/helpers/showmanager.dart';
import 'fire_store.dart';

class MyAppVersion {
  final String _softDocId = "soft";
  final String _forceDocId = "force";
  PackageInfo? _packageInfo;

  Future<PackageInfo> _getPackageInfo() async {
    _packageInfo ??= await PackageInfo.fromPlatform();
    return _packageInfo!;
  }

  Future<String> _getUrl() async {
    final PackageInfo packageInfo = await _getPackageInfo();

    final appId =
    Platform.isAndroid ? packageInfo.packageName : Strings.kAppStoreId;

    return Platform.isAndroid
        ? 'market://details?id=$appId'
        : 'https://apps.apple.com/app/id$appId';
  }

  Future<String?> getStoreVersion() async {
    String? storeVersion;

    final String bundleId =
    Platform.isAndroid ? Strings.kAndroidBundleId : Strings.kIOSBundleId;

    if (Platform.isAndroid) {
      final PlayStoreSearchAPI playStoreSearchAPI = PlayStoreSearchAPI();

      final Document? result =
      await playStoreSearchAPI.lookupById(bundleId, country: 'US');

      if (result != null) storeVersion = playStoreSearchAPI.version(result);
    } else if (Platform.isIOS) {
      final ITunesSearchAPI iTunesSearchAPI = ITunesSearchAPI();

      final Map<dynamic, dynamic>? result =
      await iTunesSearchAPI.lookupByBundleId(bundleId, country: 'US');

      if (result != null) storeVersion = iTunesSearchAPI.version(result);
    } else {
      storeVersion = null;
    }
    return storeVersion;
  }

  Future<void> checkStoreVersion() async {
    if (!Platform.isAndroid && !Platform.isIOS) return;
    try {
      final String? storeVersion = await getStoreVersion();
      if (storeVersion == null) return;
      final PackageInfo packageInfo = await _getPackageInfo();

      final url = await _getUrl();
      if (storeVersion != packageInfo.version) {
        showManager.showSnackBar(
          'Đã có phiên bản mới',
          onPressed: () => launcher.launch(url),
          label: 'Cập nhật',
        );
      }
    } catch (e) {
      e.logE('check Version');
    }
  }

  Future<void> checkForceUpdate() async {
    try {
      final PackageInfo packageInfo = await _getPackageInfo();
      final String packageVersion = packageInfo.version;
      final url = await _getUrl();

      final softIds = await firestore.getIds(_softDocId);
      final forceIds = await firestore.getIds(_forceDocId);

      if (forceIds.contains(packageVersion)) {
        showManager.showForceUpdateDialog(
          onPressed: () => launcher.launch(url),
        );
      } else if (softIds.contains(packageVersion)) {
        showManager.showAlertDialog(
          title: 'Đã có phiên bản mới',
          content: 'Cập nhật ngay để có trải nghiệm tốt hơn',
          rTxt: 'Cập nhật',
          onPressedR: () => launcher.launch(url),
          barrierDismissible: false,
        );
      }
      // ignore: empty_catches
    } catch (e) {}
  }
}

final appVersion = MyAppVersion();
