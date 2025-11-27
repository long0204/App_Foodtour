// import 'package:intl/intl.dart';

// import '../../../config/export.dart';
// import '../../../data/models/notify/notify.dart';
// import '../extensions/string_extension.dart';

// class ConvertNoti {
//   static ConvertNoti? _instance;

//   ConvertNoti._();

//   static ConvertNoti get instance => _instance ??= ConvertNoti._();

//   final Map<String, String> vi = {
//     'active': 'Đang hoạt động',
//     'inactive': 'Ngừng hoạt động',
//     'pending': 'Đang xử lý',
//     'approved': 'Được duyệt',
//     'pre_approved': 'Tạm duyệt',
//     'rejected': 'Bị từ chối',
//     'trash': 'Không hợp lệ'
//   };

//   final Map<String, String> en = {
//     'active': 'Active',
//     'inactive': 'Inactive',
//     'pending': 'Pending',
//     'approved': 'Approved',
//     'pre_approved': 'Pre Approved',
//     'rejected': 'Rejected',
//     'trash': 'Trash'
//   };

//   String title(NoticeModel noti) {
//     switch (noti.controllerId) {
//       case 'offers':
//       case 'offer':
//         return _campaignTitle(noti);
//       case 'conversion':
//         return _transactionTitle(noti);
//       default:
//         return '';
//     }
//   }

//   String _campaignTitle(NoticeModel noti) {
//     final isVN = Intl.defaultLocale == Strings.kVnLocale;
//     final Map<String, String> data = isVN ? transNotiVN : transNotiEn;

//     final str1 = data[noti.controllerId];
//     final str2 = noti.objectId ?? '';
//     final str3 = noti.titleOffer ?? '';
//     final str4 = data[noti.actionId];
//     final hasBeen = isVN ? 'vừa được' : 'has been';
//     return '$str1 #$str2 $str3 $hasBeen $str4';
//   }

//   String _transactionTitle(NoticeModel noti) {
//     final isVN = Intl.defaultLocale == Strings.kVnLocale;
//     final Map<String, dynamic> data = isVN ? transNotiVN : transNotiEn;

//     final str1 = (data[noti.controllerId] as String?).rmSpaceWhenEmpty();
//     final str2 = noti.objectId.rmSpaceWhenEmpty();
//     final str3 = noti.titleOffer.rmSpaceWhenEmpty();
//     final str4 = (data[noti.actionId] as String?).rmSpaceWhenEmpty();
//     final hasBeen = isVN ? 'vừa được' : 'has been';

//     return '$str1#$str2$str3$hasBeen $str4';
//   }

//   (String status, NotifyColorStatus colorStatus) getOfferStatus(
//       NoticeModel noti) {
//     String status = '';
//     NotifyColorStatus colorStatus = NotifyColorStatus.blue;

//     try {
//       final isVN = Intl.defaultLocale == Strings.kVnLocale;
//       final Map<String, dynamic> data = isVN ? transNotiVN : transNotiEn;
//       final offerStatus =
//           noti.newAttributes!.firstWhere((e) => e.key == 'status');
//       status = data[offerStatus.value] ?? '';
//       colorStatus = offerStatus.value == 'active'
//           ? NotifyColorStatus.green
//           : NotifyColorStatus.red;
//     } catch (e) {
//       // e.logE('status $e');
//     }
//     return (status, colorStatus);
//   }

//   (String status, NotifyColorStatus colorStatus) getTransStatus(
//       NoticeModel noti) {
//     String status = '';
//     NotifyColorStatus colorStatus = NotifyColorStatus.grey;
//     try {
//       final isVN = Intl.defaultLocale == Strings.kVnLocale;
//       final Map<String, dynamic> data = isVN ? transNotiVN : transNotiEn;
//       final conversionStatus =
//           noti.newAttributes!.firstWhere((e) => e.key == 'conversion_status');
//       status = data[conversionStatus.value] ?? '';
//       switch (conversionStatus.value.toLowerCase()) {
//         case 'pending':
//           colorStatus = NotifyColorStatus.yellow;
//           break;
//         case 'approved':
//           colorStatus = NotifyColorStatus.green;
//           break;
//         case 'pre_approved':
//         case 'preapproved':
//           colorStatus = NotifyColorStatus.blue;
//           break;
//         case 'rejected':
//           colorStatus = NotifyColorStatus.red;
//           break;
//         case 'trash':
//           colorStatus = NotifyColorStatus.grey;
//           break;
//         default:
//       }
//     } catch (e) {
//       // e.logE('status $e');
//     }
//     return (status, colorStatus);
//   }
// }

// final convertNoti = ConvertNoti.instance;

// enum NotifyColorStatus { yellow, green, blue, red, grey }
