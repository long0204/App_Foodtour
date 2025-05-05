// import 'dart:io' show Platform;
// import '../../data/models/offer/offer.dart';
// import '../../data/models/point/mission.dart';
// import '../../service/remote_config.dart';
// import 'extensions/string_extension.dart';

// class SubmitUtil {
//   static SubmitUtil? _instance;

//   SubmitUtil._();

//   static SubmitUtil get instance => _instance ??= SubmitUtil._();

//   Future<List<OfferModel>> hideOffer(List<OfferModel> data) async {
//     if (Platform.isAndroid) return data;
//     // if (_isNotTargetDate()) return data;
//     final hide = await remoteConfig.getHideForAppReview();
//     if (!hide) return data;
//     data.removeWhere((e) {
//       final keywords = ['vay', 'bảo hiểm', 'android'];
//       final t = (e.title ?? '').toLowerCase();
//       return keywords.any(t.contains);
//     });
//     data.removeWhere((e) => e.thumb.emptyOrNull());
//     return data;
//   }

//   Future<List<MissionModel>> hideMission(List<MissionModel> data) async {
//     if (Platform.isAndroid) return data;
//     // if (_isNotTargetDate()) return data;
//     final hide = await remoteConfig.getHideForAppReview();
//     if (!hide) return data;

//     data.removeWhere((e) {
//       final keywords = ['chiến dịch app'];
//       final t = (e.descrision?.vn ?? '').toLowerCase();
//       return keywords.any(t.contains);
//     });

//     return data;
//   }

// bool _isNotTargetDate() {
//   final date = DateTime.now().toLocal();
//   final targetDays = {28, 29, 30, 31};
//   return !(targetDays.contains(date.day) && date.month == 8);
// }
// }

// final submitUtil = SubmitUtil.instance;

final targetDays = {20, 21};

// String reNameSubmit(String t) {
//   final date = DateTime.now().toLocal();
//   if (!(targetDays.contains(date.day) && date.month == 2)) return t;
//   final t1 = t.replaceAll('Dinos', 'TingX');
//   return t1.replaceAll('dinos', 'TingX');
// }

bool hide() {
  final date = DateTime.now().toLocal();
  return (targetDays.contains(date.day) && date.month == 2);
}
