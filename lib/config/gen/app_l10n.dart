import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_l10n_en.dart';
import 'app_l10n_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @skip.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get skip;

  /// No description provided for @start.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get start;

  /// No description provided for @next.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp theo'**
  String get next;

  /// No description provided for @homePage.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get homePage;

  /// No description provided for @news.
  ///
  /// In vi, this message translates to:
  /// **'Bản tin'**
  String get news;

  /// No description provided for @report.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo'**
  String get report;

  /// No description provided for @pay.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán'**
  String get pay;

  /// No description provided for @onboardPayContent.
  ///
  /// In vi, this message translates to:
  /// **'TingX hỗ trợ thanh toán 24/7 cho bạn. Hãy nhanh chọn cho mình một chiến dịch phù hợp để tạo ra thật nhiều hoa hồng cùng TingX nhé.'**
  String get onboardPayContent;

  /// No description provided for @closeAppAlert.
  ///
  /// In vi, this message translates to:
  /// **'Vuốt 2 lần để thoát ứng dụng'**
  String get closeAppAlert;

  /// No description provided for @loginTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xin chào,'**
  String get loginTitle;

  /// No description provided for @registerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng bạn,'**
  String get registerTitle;

  /// No description provided for @loginWith.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập với'**
  String get loginWith;

  /// No description provided for @registerWith.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký với'**
  String get registerWith;

  /// No description provided for @tryAgain.
  ///
  /// In vi, this message translates to:
  /// **'Quá nhiều lần thử, vui lòng thử lại sau'**
  String get tryAgain;

  /// No description provided for @emailHintField.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ email'**
  String get emailHintField;

  /// No description provided for @login.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get login;

  /// No description provided for @register.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get register;

  /// No description provided for @hasAccount.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã có tài khoản?  '**
  String get hasAccount;

  /// No description provided for @noAccount.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa có tài khoản?  '**
  String get noAccount;

  /// No description provided for @loginNow.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập ngay'**
  String get loginNow;

  /// No description provided for @registerNow.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký ngay'**
  String get registerNow;

  /// No description provided for @accountUnavailable.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản không khả dụng'**
  String get accountUnavailable;

  /// No description provided for @pleaseContactAdmin.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng liên hệ Admin để biết thêm chi tiết.'**
  String get pleaseContactAdmin;

  /// No description provided for @weHaveSentOTP.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi đã gửi mã đến địa chỉ email'**
  String get weHaveSentOTP;

  /// No description provided for @resendFollow.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại mã sau: '**
  String get resendFollow;

  /// No description provided for @noOTP.
  ///
  /// In vi, this message translates to:
  /// **'Không nhận được mã? '**
  String get noOTP;

  /// No description provided for @resend.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại'**
  String get resend;

  /// No description provided for @updateInfo.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật thông tin'**
  String get updateInfo;

  /// No description provided for @updateInfoFail.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật thông tin thất bại'**
  String get updateInfoFail;

  /// No description provided for @expAff.
  ///
  /// In vi, this message translates to:
  /// **'Kinh nghiệm chạy affiliate *'**
  String get expAff;

  /// No description provided for @isKOL.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có phải là KOL, KOC không?'**
  String get isKOL;

  /// No description provided for @campaignUsed.
  ///
  /// In vi, this message translates to:
  /// **'Campaign từng chạy *'**
  String get campaignUsed;

  /// No description provided for @campaignRUsedName.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên campaign từng chạy affiliate'**
  String get campaignRUsedName;

  /// No description provided for @locationTitle.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ *'**
  String get locationTitle;

  /// No description provided for @location.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ'**
  String get location;

  /// No description provided for @city.
  ///
  /// In vi, this message translates to:
  /// **'Thành phố/tỉnh'**
  String get city;

  /// No description provided for @region.
  ///
  /// In vi, this message translates to:
  /// **'Quận/huyện'**
  String get region;

  /// No description provided for @ward.
  ///
  /// In vi, this message translates to:
  /// **'Phường/xã'**
  String get ward;

  /// No description provided for @address.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ cụ thể (Số nhà, đường phố)'**
  String get address;

  /// No description provided for @loginInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin đăng nhập('**
  String get loginInfo;

  /// No description provided for @phoneNumber.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại'**
  String get phoneNumber;

  /// No description provided for @addContact.
  ///
  /// In vi, this message translates to:
  /// **'Thêm liên lạc'**
  String get addContact;

  /// No description provided for @languageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get languageTitle;

  /// No description provided for @language.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng việt'**
  String get language;

  /// No description provided for @isPublisher.
  ///
  /// In vi, this message translates to:
  /// **'Bạn là publisher?'**
  String get isPublisher;

  /// No description provided for @networkUsedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã từng chạy network nào dưới đây?'**
  String get networkUsedTitle;

  /// No description provided for @exp.
  ///
  /// In vi, this message translates to:
  /// **'Số năm kinh nghiệm'**
  String get exp;

  /// No description provided for @networkUsed.
  ///
  /// In vi, this message translates to:
  /// **'Nhập network từng chạy'**
  String get networkUsed;

  /// No description provided for @basicInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cơ bản * '**
  String get basicInfo;

  /// No description provided for @fbLink.
  ///
  /// In vi, this message translates to:
  /// **'Nhập link facebook'**
  String get fbLink;

  /// No description provided for @selectCountry.
  ///
  /// In vi, this message translates to:
  /// **'Chọn quốc gia'**
  String get selectCountry;

  /// No description provided for @searchCountry.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm quốc gia'**
  String get searchCountry;

  /// No description provided for @selectExp.
  ///
  /// In vi, this message translates to:
  /// **'Chọn số năm'**
  String get selectExp;

  /// No description provided for @passW.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get passW;

  /// No description provided for @selectPlatform.
  ///
  /// In vi, this message translates to:
  /// **'Chọn platform'**
  String get selectPlatform;

  /// No description provided for @rePassW.
  ///
  /// In vi, this message translates to:
  /// **'Nhập lại Mật khẩu'**
  String get rePassW;

  /// No description provided for @selectTraffic.
  ///
  /// In vi, this message translates to:
  /// **'Chọn loại traffic'**
  String get selectTraffic;

  /// No description provided for @selectTrafficHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập loại traffic'**
  String get selectTrafficHint;

  /// No description provided for @selectTypeCampaign.
  ///
  /// In vi, this message translates to:
  /// **'Chọn thể loại'**
  String get selectTypeCampaign;

  /// No description provided for @selectTypeCampaignHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập thể loại'**
  String get selectTypeCampaignHint;

  /// No description provided for @addBank.
  ///
  /// In vi, this message translates to:
  /// **'Thêm tài khoản ngân hàng'**
  String get addBank;

  /// No description provided for @editMethod.
  ///
  /// In vi, this message translates to:
  /// **'Sửa phương thức thanh toán'**
  String get editMethod;

  /// No description provided for @bankName.
  ///
  /// In vi, this message translates to:
  /// **'Tên ngân hàng'**
  String get bankName;

  /// No description provided for @bankAcc.
  ///
  /// In vi, this message translates to:
  /// **'Chủ tài khoản'**
  String get bankAcc;

  /// No description provided for @stk.
  ///
  /// In vi, this message translates to:
  /// **'Số tài khoản'**
  String get stk;

  /// No description provided for @bankAccountName.
  ///
  /// In vi, this message translates to:
  /// **'Tên chủ tài khoản'**
  String get bankAccountName;

  /// No description provided for @bankAccountNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên chủ tài khoản'**
  String get bankAccountNameHint;

  /// No description provided for @branch.
  ///
  /// In vi, this message translates to:
  /// **'Chi nhánh'**
  String get branch;

  /// No description provided for @currency.
  ///
  /// In vi, this message translates to:
  /// **'Loại tiền tệ'**
  String get currency;

  /// No description provided for @selectCurrency.
  ///
  /// In vi, this message translates to:
  /// **'Chọn loại tiền tệ'**
  String get selectCurrency;

  /// No description provided for @confirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get confirm;

  /// No description provided for @addBankWarning.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng đảm bảo nhập đúng thông tin ngân hàng và số tài khoản đăng ký với ngân hàng.'**
  String get addBankWarning;

  /// No description provided for @addBankSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Thêm thành công'**
  String get addBankSuccess;

  /// No description provided for @error.
  ///
  /// In vi, this message translates to:
  /// **'Có lỗi xảy ra, vui lòng thử lại sau'**
  String get error;

  /// No description provided for @selectBank.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngân hàng'**
  String get selectBank;

  /// No description provided for @enterBankName.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên ngân hàng'**
  String get enterBankName;

  /// No description provided for @delAcc.
  ///
  /// In vi, this message translates to:
  /// **'Xoá tài khoản'**
  String get delAcc;

  /// No description provided for @delAccTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lưu ý, sau khi xoá tài khoản:'**
  String get delAccTitle;

  /// No description provided for @delWarning1.
  ///
  /// In vi, this message translates to:
  /// **'- Xoá các dữ liệu của bạn trên ứng dụng TingX.'**
  String get delWarning1;

  /// No description provided for @delWarning2.
  ///
  /// In vi, this message translates to:
  /// **'- Không thể truy cập tài khoản.'**
  String get delWarning2;

  /// No description provided for @delWarning3.
  ///
  /// In vi, this message translates to:
  /// **'- Thao tác này không thể hoàn tác.'**
  String get delWarning3;

  /// No description provided for @delWarning4.
  ///
  /// In vi, this message translates to:
  /// **'Việc xoá tài khoản có thể cần tới 30 ngày.'**
  String get delWarning4;

  /// No description provided for @editInfo.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa thông tin'**
  String get editInfo;

  /// No description provided for @updateInfoSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật thông tin thành công'**
  String get updateInfoSuccess;

  /// No description provided for @save.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Huỷ'**
  String get cancel;

  /// No description provided for @identAccount.
  ///
  /// In vi, this message translates to:
  /// **'Định danh tài khoản'**
  String get identAccount;

  /// No description provided for @household.
  ///
  /// In vi, this message translates to:
  /// **'Hộ khẩu thường trú'**
  String get household;

  /// No description provided for @frontCCCD.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh CCCD mặt trước'**
  String get frontCCCD;

  /// No description provided for @backCCCD.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh CCCD mặt sau'**
  String get backCCCD;

  /// No description provided for @cropImg.
  ///
  /// In vi, this message translates to:
  /// **'Cắt ảnh'**
  String get cropImg;

  /// No description provided for @done.
  ///
  /// In vi, this message translates to:
  /// **'Xong'**
  String get done;

  /// No description provided for @errorChangePass.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi, vui lòng thử lại'**
  String get errorChangePass;

  /// No description provided for @changePassSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mật khẩu thành công'**
  String get changePassSuccess;

  /// No description provided for @changePass.
  ///
  /// In vi, this message translates to:
  /// **'Thay đổi mật khẩu'**
  String get changePass;

  /// No description provided for @changePassBtn.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mật khẩu'**
  String get changePassBtn;

  /// No description provided for @newPass.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu mới '**
  String get newPass;

  /// No description provided for @enterNewPass.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mật khẩu mới'**
  String get enterNewPass;

  /// No description provided for @confirmPass.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu '**
  String get confirmPass;

  /// No description provided for @gmt.
  ///
  /// In vi, this message translates to:
  /// **'Múi giờ'**
  String get gmt;

  /// No description provided for @plsReload.
  ///
  /// In vi, this message translates to:
  /// **'Có lỗi xảy ra, vui lòng tải lại'**
  String get plsReload;

  /// No description provided for @reload.
  ///
  /// In vi, this message translates to:
  /// **'Tải lại'**
  String get reload;

  /// No description provided for @member.
  ///
  /// In vi, this message translates to:
  /// **'Hội viên'**
  String get member;

  /// No description provided for @member2.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên'**
  String get member2;

  /// No description provided for @benefit.
  ///
  /// In vi, this message translates to:
  /// **'Quyền lợi'**
  String get benefit;

  /// No description provided for @noEndow.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa có ưu đãi nào.'**
  String get noEndow;

  /// No description provided for @plsEndow.
  ///
  /// In vi, this message translates to:
  /// **'Hãy tích điểm để nâng hạng thành viên và nhận thêm nhiều ưu đãi bạn nhé!'**
  String get plsEndow;

  /// No description provided for @earnPoint.
  ///
  /// In vi, this message translates to:
  /// **'Kiếm thêm điểm'**
  String get earnPoint;

  /// No description provided for @point.
  ///
  /// In vi, this message translates to:
  /// **'điểm'**
  String get point;

  /// No description provided for @accumulateCoins.
  ///
  /// In vi, this message translates to:
  /// **'Tích xu'**
  String get accumulateCoins;

  /// No description provided for @claimPoint.
  ///
  /// In vi, this message translates to:
  /// **'Nhận điểm ngay'**
  String get claimPoint;

  /// No description provided for @day.
  ///
  /// In vi, this message translates to:
  /// **' Ngày'**
  String get day;

  /// No description provided for @month.
  ///
  /// In vi, this message translates to:
  /// **'Tháng'**
  String get month;

  /// No description provided for @info.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin'**
  String get info;

  /// No description provided for @historyP.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử điểm'**
  String get historyP;

  /// No description provided for @ruleP.
  ///
  /// In vi, this message translates to:
  /// **'Thể lệ'**
  String get ruleP;

  /// No description provided for @uMission.
  ///
  /// In vi, this message translates to:
  /// **'Nhiệm vụ của bạn'**
  String get uMission;

  /// No description provided for @inProgress.
  ///
  /// In vi, this message translates to:
  /// **'Đang thực hiện'**
  String get inProgress;

  /// No description provided for @complete.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get complete;

  /// No description provided for @accumulatedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Điểm tích luỹ'**
  String get accumulatedTitle;

  /// No description provided for @availabilityTitle.
  ///
  /// In vi, this message translates to:
  /// **'Điểm khả dụng'**
  String get availabilityTitle;

  /// No description provided for @accumulateTip.
  ///
  /// In vi, this message translates to:
  /// **'Tổng DP tích luỹ thực tế, là căn cứ xét hạng. Điểm không được cộng dồn qua các năm'**
  String get accumulateTip;

  /// No description provided for @avaTip.
  ///
  /// In vi, this message translates to:
  /// **'Tổng DP dùng để đổi quà'**
  String get avaTip;

  /// No description provided for @accumulateTitlePage.
  ///
  /// In vi, this message translates to:
  /// **'Tích luỹ'**
  String get accumulateTitlePage;

  /// No description provided for @avaTitlePage.
  ///
  /// In vi, this message translates to:
  /// **'Khả dụng'**
  String get avaTitlePage;

  /// No description provided for @bag.
  ///
  /// In vi, this message translates to:
  /// **'Túi đồ'**
  String get bag;

  /// No description provided for @surplus.
  ///
  /// In vi, this message translates to:
  /// **'Số dư'**
  String get surplus;

  /// No description provided for @version.
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản'**
  String get version;

  /// No description provided for @terms.
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản, điều kiện'**
  String get terms;

  /// No description provided for @sp.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ, hỗ trợ'**
  String get sp;

  /// No description provided for @rate.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá ứng dụng'**
  String get rate;

  /// No description provided for @other.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get other;

  /// No description provided for @beneficiaryAcc.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản thụ hưởng'**
  String get beneficiaryAcc;

  /// No description provided for @add.
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get add;

  /// No description provided for @noBeneficiaryAcc.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa cập nhật tài khoản thụ hưởng'**
  String get noBeneficiaryAcc;

  /// No description provided for @plsUpdateBeneficiary.
  ///
  /// In vi, this message translates to:
  /// **'Hãy cập nhật tài khoản thụ hưởng để rút tiền hoa hồng bạn nhé!'**
  String get plsUpdateBeneficiary;

  /// No description provided for @updateNow.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật ngay'**
  String get updateNow;

  /// No description provided for @logOutTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có muốn đăng xuất?'**
  String get logOutTitle;

  /// No description provided for @brownRank.
  ///
  /// In vi, this message translates to:
  /// **'hạng Đồng'**
  String get brownRank;

  /// No description provided for @silverRank.
  ///
  /// In vi, this message translates to:
  /// **'hạng Bạc'**
  String get silverRank;

  /// No description provided for @goldRank.
  ///
  /// In vi, this message translates to:
  /// **'hạng Vàng'**
  String get goldRank;

  /// No description provided for @diamondRank.
  ///
  /// In vi, this message translates to:
  /// **'Kim Cương'**
  String get diamondRank;

  /// No description provided for @nextRankContent.
  ///
  /// In vi, this message translates to:
  /// **' điểm nữa để lên'**
  String get nextRankContent;

  /// No description provided for @noIdent.
  ///
  /// In vi, this message translates to:
  /// **'Oh, bạn chưa định danh tài khoản!'**
  String get noIdent;

  /// No description provided for @plsIdent.
  ///
  /// In vi, this message translates to:
  /// **'Định danh tài khoản ngay để có thể bảo vệ tài khoản, rút tiền và mở các tính năng, nghiệp vụ bán hàng nâng cao.'**
  String get plsIdent;

  /// No description provided for @identNow.
  ///
  /// In vi, this message translates to:
  /// **'Định danh ngay'**
  String get identNow;

  /// No description provided for @logOut.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logOut;

  /// No description provided for @detailOffer.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết chiến dịch'**
  String get detailOffer;

  /// No description provided for @editLink.
  ///
  /// In vi, this message translates to:
  /// **'Sửa link chiến dịch'**
  String get editLink;

  /// No description provided for @offerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chiến dịch(*)'**
  String get offerTitle;

  /// No description provided for @ladiP.
  ///
  /// In vi, this message translates to:
  /// **'Landing page(*)'**
  String get ladiP;

  /// No description provided for @copy.
  ///
  /// In vi, this message translates to:
  /// **'Sao chép'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép'**
  String get copied;

  /// No description provided for @addACI.
  ///
  /// In vi, this message translates to:
  /// **'Thêm affiliate click id '**
  String get addACI;

  /// No description provided for @aic.
  ///
  /// In vi, this message translates to:
  /// **'Affiliate click id'**
  String get aic;

  /// No description provided for @addMobileParam.
  ///
  /// In vi, this message translates to:
  /// **'Thêm mobile parameters'**
  String get addMobileParam;

  /// No description provided for @iosIDFA.
  ///
  /// In vi, this message translates to:
  /// **'Apple ios idfa'**
  String get iosIDFA;

  /// No description provided for @ggGAID.
  ///
  /// In vi, this message translates to:
  /// **'Google android gaid'**
  String get ggGAID;

  /// No description provided for @addSubId.
  ///
  /// In vi, this message translates to:
  /// **'Thêm sub id '**
  String get addSubId;

  /// No description provided for @addSub.
  ///
  /// In vi, this message translates to:
  /// **'Thêm Sub'**
  String get addSub;

  /// No description provided for @unlockOffer.
  ///
  /// In vi, this message translates to:
  /// **'Mở khoá chiến dịch'**
  String get unlockOffer;

  /// No description provided for @infoBenefit.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin đãi ngộ'**
  String get infoBenefit;

  /// No description provided for @amountUnlock.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền mở khoá chiến dịch'**
  String get amountUnlock;

  /// No description provided for @back.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get back;

  /// No description provided for @continueTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get continueTitle;

  /// No description provided for @joinNow.
  ///
  /// In vi, this message translates to:
  /// **'Tham gia ngay'**
  String get joinNow;

  /// No description provided for @waitingForApproval.
  ///
  /// In vi, this message translates to:
  /// **'Đang đợi duyệt'**
  String get waitingForApproval;

  /// No description provided for @hh.
  ///
  /// In vi, this message translates to:
  /// **'Hoa hồng:  '**
  String get hh;

  /// No description provided for @waitingForApproval2.
  ///
  /// In vi, this message translates to:
  /// **'Đang chờ duyệt'**
  String get waitingForApproval2;

  /// No description provided for @rejected.
  ///
  /// In vi, this message translates to:
  /// **'Đã từ chối'**
  String get rejected;

  /// No description provided for @linkOffer.
  ///
  /// In vi, this message translates to:
  /// **'Link chiến dịch'**
  String get linkOffer;

  /// No description provided for @similarOffer.
  ///
  /// In vi, this message translates to:
  /// **'Chiến dịch tương tự'**
  String get similarOffer;

  /// No description provided for @hello.
  ///
  /// In vi, this message translates to:
  /// **'Xin chào'**
  String get hello;

  /// No description provided for @notAvailableYet.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng đang phát triển'**
  String get notAvailableYet;

  /// No description provided for @payIn.
  ///
  /// In vi, this message translates to:
  /// **'Nạp tiền'**
  String get payIn;

  /// No description provided for @payOut.
  ///
  /// In vi, this message translates to:
  /// **'Rút tiền'**
  String get payOut;

  /// No description provided for @inviteFriend.
  ///
  /// In vi, this message translates to:
  /// **'Mời bạn'**
  String get inviteFriend;

  /// No description provided for @filter.
  ///
  /// In vi, this message translates to:
  /// **'Bộ lọc'**
  String get filter;

  /// No description provided for @reset.
  ///
  /// In vi, this message translates to:
  /// **'Thiết lập lại'**
  String get reset;

  /// No description provided for @apply.
  ///
  /// In vi, this message translates to:
  /// **'Áp dụng'**
  String get apply;

  /// No description provided for @country.
  ///
  /// In vi, this message translates to:
  /// **'Quốc gia'**
  String get country;

  /// No description provided for @enterCountryName.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên quốc gia'**
  String get enterCountryName;

  /// No description provided for @goalType.
  ///
  /// In vi, this message translates to:
  /// **'Hình thức chạy'**
  String get goalType;

  /// No description provided for @listEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách trống'**
  String get listEmpty;

  /// No description provided for @hasEndList.
  ///
  /// In vi, this message translates to:
  /// **'Đã đến cuối danh sách'**
  String get hasEndList;

  /// No description provided for @listCategory.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách ngành hàng'**
  String get listCategory;

  /// No description provided for @search.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm'**
  String get search;

  /// No description provided for @suggestTitle.
  ///
  /// In vi, this message translates to:
  /// **'TingX đề xuất'**
  String get suggestTitle;

  /// No description provided for @guide.
  ///
  /// In vi, this message translates to:
  /// **'Hướng dẫn'**
  String get guide;

  /// No description provided for @comingSoon.
  ///
  /// In vi, this message translates to:
  /// **'Sắp diễn ra'**
  String get comingSoon;

  /// No description provided for @withU.
  ///
  /// In vi, this message translates to:
  /// **'Cùng'**
  String get withU;

  /// No description provided for @eventContent.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá các sự kiện và tin tức thú vị'**
  String get eventContent;

  /// No description provided for @newsPage.
  ///
  /// In vi, this message translates to:
  /// **'Tin tức'**
  String get newsPage;

  /// No description provided for @otherNew.
  ///
  /// In vi, this message translates to:
  /// **'Tin tức khác'**
  String get otherNew;

  /// No description provided for @whatNews.
  ///
  /// In vi, this message translates to:
  /// **'Có gì mới?'**
  String get whatNews;

  /// No description provided for @noti.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get noti;

  /// No description provided for @offer.
  ///
  /// In vi, this message translates to:
  /// **'Chiến dịch'**
  String get offer;

  /// No description provided for @transaction.
  ///
  /// In vi, this message translates to:
  /// **'Giao dịch'**
  String get transaction;

  /// No description provided for @emptyNoti.
  ///
  /// In vi, this message translates to:
  /// **'Không có thông báo nào'**
  String get emptyNoti;

  /// No description provided for @del.
  ///
  /// In vi, this message translates to:
  /// **'Xoá'**
  String get del;

  /// No description provided for @hourAgo.
  ///
  /// In vi, this message translates to:
  /// **'giờ trước'**
  String get hourAgo;

  /// No description provided for @today.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get today;

  /// No description provided for @old.
  ///
  /// In vi, this message translates to:
  /// **'Cũ hơn'**
  String get old;

  /// No description provided for @payInSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Nạp tiền thành công!'**
  String get payInSuccess;

  /// No description provided for @payInFail.
  ///
  /// In vi, this message translates to:
  /// **'Nạp tiền không thành công!'**
  String get payInFail;

  /// No description provided for @backToHome.
  ///
  /// In vi, this message translates to:
  /// **'Về trang chủ'**
  String get backToHome;

  /// No description provided for @retry.
  ///
  /// In vi, this message translates to:
  /// **' Thử lại'**
  String get retry;

  /// No description provided for @payOutFrom.
  ///
  /// In vi, this message translates to:
  /// **'Rút tiền từ'**
  String get payOutFrom;

  /// No description provided for @send.
  ///
  /// In vi, this message translates to:
  /// **'Gửi'**
  String get send;

  /// No description provided for @accountBalance.
  ///
  /// In vi, this message translates to:
  /// **'Số dư tài khoản'**
  String get accountBalance;

  /// No description provided for @notMetAmount.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa đủ số tiền thanh toán tối thiểu'**
  String get notMetAmount;

  /// No description provided for @payOutFail.
  ///
  /// In vi, this message translates to:
  /// **'Rút tiền không thành công!'**
  String get payOutFail;

  /// No description provided for @errPayOut.
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra lỗi trong quá trình rút tiền.'**
  String get errPayOut;

  /// No description provided for @notMetAmountErr.
  ///
  /// In vi, this message translates to:
  /// **'Số dư hiện tại không đủ'**
  String get notMetAmountErr;

  /// No description provided for @payOutSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Gửi yêu cầu thành công!'**
  String get payOutSuccess;

  /// No description provided for @payOutSuccessContent.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã gửi yêu cầu thanh toán thành công. Chúng tôi sẽ xử lí hoá đơn trong thời gian sớm nhất.'**
  String get payOutSuccessContent;

  /// No description provided for @paymentMethod.
  ///
  /// In vi, this message translates to:
  /// **'Phương thức thanh toán'**
  String get paymentMethod;

  /// No description provided for @bankTransfer.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển khoản ngân hàng'**
  String get bankTransfer;

  /// No description provided for @bank.
  ///
  /// In vi, this message translates to:
  /// **'Ngân hàng'**
  String get bank;

  /// No description provided for @needUpdateInfoBank.
  ///
  /// In vi, this message translates to:
  /// **'Bạn cần cập nhật thông tin tài khoản ngân hàng'**
  String get needUpdateInfoBank;

  /// No description provided for @needUpdateInfoBankContent.
  ///
  /// In vi, this message translates to:
  /// **'Hãy cập nhật thông tin tài khoản ngân hàng để rút những khoản tiền đầu tiên về ví mình nhé!'**
  String get needUpdateInfoBankContent;

  /// No description provided for @selectMethod.
  ///
  /// In vi, this message translates to:
  /// **'Chọn phương thức thanh toán'**
  String get selectMethod;

  /// No description provided for @notMethod.
  ///
  /// In vi, this message translates to:
  /// **'Chưa cập nhật phương thức'**
  String get notMethod;

  /// No description provided for @amountWithdraw.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền muốn rút'**
  String get amountWithdraw;

  /// No description provided for @minimum.
  ///
  /// In vi, this message translates to:
  /// **'Tối thiểu'**
  String get minimum;

  /// No description provided for @identDialogContent.
  ///
  /// In vi, this message translates to:
  /// **'Định danh tài khoản ngay để có thể bảo vệ tài khoản, rút tiền và mở các tính năng, nghiệp vụ bán hàng nâng cao.'**
  String get identDialogContent;

  /// No description provided for @close.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get close;

  /// No description provided for @listReferral.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách referral'**
  String get listReferral;

  /// No description provided for @referralEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách giới thiệu trống'**
  String get referralEmpty;

  /// No description provided for @referralContent.
  ///
  /// In vi, this message translates to:
  /// **'Hãy tích cực chia sẻ link giới thiệu nhiều bạn bè hơn nữa để nhận thật nhiều hoa hồng nha.'**
  String get referralContent;

  /// No description provided for @introduceNow.
  ///
  /// In vi, this message translates to:
  /// **'Giới thiệu ngay'**
  String get introduceNow;

  /// No description provided for @introduceNewFr.
  ///
  /// In vi, this message translates to:
  /// **'Giới thiệu bạn mới'**
  String get introduceNewFr;

  /// No description provided for @headRefTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhận thưởng không giới hạn'**
  String get headRefTitle;

  /// No description provided for @headRefContentReg.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký link và giới thiệu cho bạn bè để nhận hoa hồng bạn nhé!'**
  String get headRefContentReg;

  /// No description provided for @headRefContentShare.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ link giới thiệu cho bạn bè để nhận hoa hồng bạn nhé!'**
  String get headRefContentShare;

  /// No description provided for @refLinkOutDate.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết giới thiệu của bạn hết hạn'**
  String get refLinkOutDate;

  /// No description provided for @refLinkOutDateContent.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng liên hệ AM để tạo link liên kết và giới thiệu cho bạn bè để nhận hoa hồng bạn nhé!'**
  String get refLinkOutDateContent;

  /// No description provided for @unexpired.
  ///
  /// In vi, this message translates to:
  /// **'Còn hạn'**
  String get unexpired;

  /// No description provided for @expired.
  ///
  /// In vi, this message translates to:
  /// **'Hết hạn'**
  String get expired;

  /// No description provided for @totalBonus.
  ///
  /// In vi, this message translates to:
  /// **'Tổng số tiền bonus'**
  String get totalBonus;

  /// No description provided for @bonusPaid.
  ///
  /// In vi, this message translates to:
  /// **'Bonus đã thanh toán'**
  String get bonusPaid;

  /// No description provided for @amountMoney.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền'**
  String get amountMoney;

  /// No description provided for @notes.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú'**
  String get notes;

  /// No description provided for @noRecorded.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu nào\n được ghi nhận'**
  String get noRecorded;

  /// No description provided for @effectiveDate.
  ///
  /// In vi, this message translates to:
  /// **'Ngày hiệu lực'**
  String get effectiveDate;

  /// No description provided for @progress.
  ///
  /// In vi, this message translates to:
  /// **'Tiến trình'**
  String get progress;

  /// No description provided for @historyPay.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử thanh toán'**
  String get historyPay;

  /// No description provided for @time.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian'**
  String get time;

  /// No description provided for @convert.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển đổi'**
  String get convert;

  /// No description provided for @soDon.
  ///
  /// In vi, this message translates to:
  /// **'Số đơn'**
  String get soDon;

  /// No description provided for @unit.
  ///
  /// In vi, this message translates to:
  /// **'(Đơn vị : dvt)'**
  String get unit;

  /// No description provided for @now.
  ///
  /// In vi, this message translates to:
  /// **'Hiện tại'**
  String get now;

  /// No description provided for @previous.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ trước'**
  String get previous;

  /// No description provided for @currencyUnit.
  ///
  /// In vi, this message translates to:
  /// **'Đơn vị tiền tệ'**
  String get currencyUnit;

  /// No description provided for @approved.
  ///
  /// In vi, this message translates to:
  /// **'Được duyệt'**
  String get approved;

  /// No description provided for @pending.
  ///
  /// In vi, this message translates to:
  /// **'Đang xử lý'**
  String get pending;

  /// No description provided for @trash.
  ///
  /// In vi, this message translates to:
  /// **'Không hợp lệ'**
  String get trash;

  /// No description provided for @denied.
  ///
  /// In vi, this message translates to:
  /// **'Bị từ chối'**
  String get denied;

  /// No description provided for @preApproved.
  ///
  /// In vi, this message translates to:
  /// **'Tạm duyệt'**
  String get preApproved;

  /// No description provided for @selectTime.
  ///
  /// In vi, this message translates to:
  /// **'Chọn khoảng thời gian'**
  String get selectTime;

  /// No description provided for @enterOfferName.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên chiến dịch'**
  String get enterOfferName;

  /// No description provided for @selectOffer.
  ///
  /// In vi, this message translates to:
  /// **'Chọn chiến dịch'**
  String get selectOffer;

  /// No description provided for @noRecordOvView.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu nào được ghi nhận'**
  String get noRecordOvView;

  /// No description provided for @chart.
  ///
  /// In vi, this message translates to:
  /// **'Biểu đồ'**
  String get chart;

  /// No description provided for @revenue.
  ///
  /// In vi, this message translates to:
  /// **'Doanh thu'**
  String get revenue;

  /// No description provided for @averageIncome.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập TB/tháng'**
  String get averageIncome;

  /// No description provided for @approvalRate.
  ///
  /// In vi, this message translates to:
  /// **'Tỷ lệ phê duyệt (AR)'**
  String get approvalRate;

  /// No description provided for @conversionRate.
  ///
  /// In vi, this message translates to:
  /// **'Tỷ lệ chuyển đổi (CR)'**
  String get conversionRate;

  /// No description provided for @detailInvoice.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết lịch sử thanh toán'**
  String get detailInvoice;

  /// No description provided for @invoice.
  ///
  /// In vi, this message translates to:
  /// **'Hoá đơn'**
  String get invoice;

  /// No description provided for @startDate.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian tạo'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian hết hạn'**
  String get endDate;

  /// No description provided for @payInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin thanh toán'**
  String get payInfo;

  /// No description provided for @listOffer.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách chiến dịch'**
  String get listOffer;

  /// No description provided for @amountPaid.
  ///
  /// In vi, this message translates to:
  /// **'Đã thanh toán'**
  String get amountPaid;

  /// No description provided for @availability.
  ///
  /// In vi, this message translates to:
  /// **'Khả dụng'**
  String get availability;

  /// No description provided for @pendingPay.
  ///
  /// In vi, this message translates to:
  /// **'Chờ thanh toán'**
  String get pendingPay;

  /// No description provided for @incomeBill.
  ///
  /// In vi, this message translates to:
  /// **'Hoá đơn thu nhập'**
  String get incomeBill;

  /// No description provided for @payInFromBank.
  ///
  /// In vi, this message translates to:
  /// **'Từ ngân hàng vào TingX'**
  String get payInFromBank;

  /// No description provided for @payOutFromTingX.
  ///
  /// In vi, this message translates to:
  /// **'Từ TingX về ngân hàng'**
  String get payOutFromTingX;

  /// No description provided for @saleStatistics.
  ///
  /// In vi, this message translates to:
  /// **'Thống kê doanh số nhé!'**
  String get saleStatistics;

  /// No description provided for @overView.
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan'**
  String get overView;

  /// No description provided for @processing.
  ///
  /// In vi, this message translates to:
  /// **'Chờ xử lí'**
  String get processing;

  /// No description provided for @emptySearch.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy kết quả nào'**
  String get emptySearch;

  /// No description provided for @hintSearch.
  ///
  /// In vi, this message translates to:
  /// **'Hãy thử sử dụng các từ khoá chung chung hơn'**
  String get hintSearch;

  /// No description provided for @delHistorySearch.
  ///
  /// In vi, this message translates to:
  /// **'Xoá lịch sử tìm kiếm'**
  String get delHistorySearch;

  /// No description provided for @seeMore.
  ///
  /// In vi, this message translates to:
  /// **'Hiển thị nhiều hơn'**
  String get seeMore;

  /// No description provided for @setting.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get setting;

  /// No description provided for @onMic.
  ///
  /// In vi, this message translates to:
  /// **'Để tiếp tục sử dụng tính năng vui lòng bật micrô'**
  String get onMic;

  /// No description provided for @speechHint.
  ///
  /// In vi, this message translates to:
  /// **'Bạn cần tìm gì?'**
  String get speechHint;

  /// No description provided for @reMic.
  ///
  /// In vi, this message translates to:
  /// **'Hãy nhấn vào micrô để thử lại'**
  String get reMic;

  /// No description provided for @account.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản'**
  String get account;

  /// No description provided for @searchHintText.
  ///
  /// In vi, this message translates to:
  /// **'Nhập để tìm kiếm...'**
  String get searchHintText;

  /// No description provided for @emptySearchDropDown.
  ///
  /// In vi, this message translates to:
  /// **'Không có kết quả tìm kiếm'**
  String get emptySearchDropDown;

  /// No description provided for @select.
  ///
  /// In vi, this message translates to:
  /// **'Chọn'**
  String get select;

  /// No description provided for @all.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get all;

  /// No description provided for @mobileApp.
  ///
  /// In vi, this message translates to:
  /// **'Ứng dụng\ndi động'**
  String get mobileApp;

  /// No description provided for @eCommerce.
  ///
  /// In vi, this message translates to:
  /// **'Thương mại điện tử'**
  String get eCommerce;

  /// No description provided for @functionalFoods.
  ///
  /// In vi, this message translates to:
  /// **'Thực phẩm chức năng'**
  String get functionalFoods;

  /// No description provided for @finance.
  ///
  /// In vi, this message translates to:
  /// **'Tài chính'**
  String get finance;

  /// No description provided for @cosmetics.
  ///
  /// In vi, this message translates to:
  /// **'Mỹ phẩm'**
  String get cosmetics;

  /// No description provided for @tooManyTries.
  ///
  /// In vi, this message translates to:
  /// **'Quá nhiều lần thử'**
  String get tooManyTries;

  /// No description provided for @sendOTPFail.
  ///
  /// In vi, this message translates to:
  /// **'Gửi mã thất bại'**
  String get sendOTPFail;

  /// No description provided for @reSendOTPFail.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại mã thất bại'**
  String get reSendOTPFail;

  /// No description provided for @invalidOTP.
  ///
  /// In vi, this message translates to:
  /// **'Mã OTP không đúng định dạng'**
  String get invalidOTP;

  /// No description provided for @otpNotCorrect.
  ///
  /// In vi, this message translates to:
  /// **'Mã xác minh chưa chính xác'**
  String get otpNotCorrect;

  /// No description provided for @loginFail.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập thất bại'**
  String get loginFail;

  /// No description provided for @plsTryAgain.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng thử lại hoặc liên hệ tổng đài để được trợ giúp.'**
  String get plsTryAgain;

  /// No description provided for @invalidSelectBankName.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn tên ngân hàng'**
  String get invalidSelectBankName;

  /// No description provided for @invalidNameBank.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tên chủ tài khoản'**
  String get invalidNameBank;

  /// No description provided for @invalidNameBankContainVNChar.
  ///
  /// In vi, this message translates to:
  /// **'Tên CTK phải là không dấu'**
  String get invalidNameBankContainVNChar;

  /// No description provided for @accNumInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập số tài khoản'**
  String get accNumInvalid;

  /// No description provided for @onlyNumber.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ nhập số'**
  String get onlyNumber;

  /// No description provided for @currencyInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn loại tiền tệ'**
  String get currencyInvalid;

  /// No description provided for @passNotMatch.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu không trùng khớp'**
  String get passNotMatch;

  /// No description provided for @invalidFirstName.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập họ'**
  String get invalidFirstName;

  /// No description provided for @invalidLastName.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tên'**
  String get invalidLastName;

  /// No description provided for @option.
  ///
  /// In vi, this message translates to:
  /// **'Tuỳ chọn'**
  String get option;

  /// No description provided for @yesterday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm qua'**
  String get yesterday;

  /// No description provided for @thisWeek.
  ///
  /// In vi, this message translates to:
  /// **'Tuần này'**
  String get thisWeek;

  /// No description provided for @lastWeek.
  ///
  /// In vi, this message translates to:
  /// **'Tuần trước'**
  String get lastWeek;

  /// No description provided for @thisMonth.
  ///
  /// In vi, this message translates to:
  /// **'Tháng này'**
  String get thisMonth;

  /// No description provided for @last30Days.
  ///
  /// In vi, this message translates to:
  /// **'30 ngày gần nhất'**
  String get last30Days;

  /// No description provided for @emailEmptyInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập Email'**
  String get emailEmptyInvalid;

  /// No description provided for @emailInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Email không đúng định dạng'**
  String get emailInvalid;

  /// No description provided for @passLengthInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu có độ dài từ 6 ký tự'**
  String get passLengthInvalid;

  /// No description provided for @passInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu sai định dạng'**
  String get passInvalid;

  /// No description provided for @phoneEmptyInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập số điện thoại'**
  String get phoneEmptyInvalid;

  /// No description provided for @phoneLengthInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại có độ dài từ 9 -> 12'**
  String get phoneLengthInvalid;

  /// No description provided for @phoneInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại sai định dạng'**
  String get phoneInvalid;

  /// No description provided for @plsGrantPermission.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng cấp phép trong cài đặt điện thoại'**
  String get plsGrantPermission;

  /// No description provided for @lib.
  ///
  /// In vi, this message translates to:
  /// **'Thư viện'**
  String get lib;

  /// No description provided for @pickImgFrom.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ảnh từ'**
  String get pickImgFrom;

  /// No description provided for @monday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Hai'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Ba'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Tư'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Năm'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Sáu'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Bảy'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In vi, this message translates to:
  /// **'Chủ Nhật'**
  String get sunday;

  /// No description provided for @unknown.
  ///
  /// In vi, this message translates to:
  /// **'Không xác định'**
  String get unknown;

  /// No description provided for @brownRank2.
  ///
  /// In vi, this message translates to:
  /// **'Hạng Đồng'**
  String get brownRank2;

  /// No description provided for @silverRank2.
  ///
  /// In vi, this message translates to:
  /// **'Hạng Bạc'**
  String get silverRank2;

  /// No description provided for @goldRank2.
  ///
  /// In vi, this message translates to:
  /// **'Hạng Vàng'**
  String get goldRank2;

  /// No description provided for @selectLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ'**
  String get selectLanguage;

  /// No description provided for @createdAt.
  ///
  /// In vi, this message translates to:
  /// **'Ngày tạo'**
  String get createdAt;

  /// No description provided for @conversionDetail.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết chuyển đổi'**
  String get conversionDetail;

  /// No description provided for @date.
  ///
  /// In vi, this message translates to:
  /// **'Ngày'**
  String get date;

  /// No description provided for @updatedAt.
  ///
  /// In vi, this message translates to:
  /// **'Ngày thay đổi'**
  String get updatedAt;

  /// No description provided for @conversionStatus.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái'**
  String get conversionStatus;

  /// No description provided for @tax.
  ///
  /// In vi, this message translates to:
  /// **'Thuế'**
  String get tax;

  /// No description provided for @paymentStatus.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán'**
  String get paymentStatus;

  /// No description provided for @unPaid.
  ///
  /// In vi, this message translates to:
  /// **'Chưa thánh toán'**
  String get unPaid;

  /// No description provided for @advertiserOffer.
  ///
  /// In vi, this message translates to:
  /// **'Nhà cung cấp và chiến dịch'**
  String get advertiserOffer;

  /// No description provided for @goal.
  ///
  /// In vi, this message translates to:
  /// **'Hình thức chạy'**
  String get goal;

  /// No description provided for @contact.
  ///
  /// In vi, this message translates to:
  /// **'Liên lạc'**
  String get contact;

  /// No description provided for @fName.
  ///
  /// In vi, this message translates to:
  /// **'Họ'**
  String get fName;

  /// No description provided for @lName.
  ///
  /// In vi, this message translates to:
  /// **'Tên'**
  String get lName;

  /// No description provided for @custom.
  ///
  /// In vi, this message translates to:
  /// **'Tuỳ chỉnh'**
  String get custom;

  /// No description provided for @technical.
  ///
  /// In vi, this message translates to:
  /// **'Kỹ thuật'**
  String get technical;

  /// No description provided for @ip.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ IP'**
  String get ip;

  /// No description provided for @geo.
  ///
  /// In vi, this message translates to:
  /// **'Địa điểm'**
  String get geo;

  /// No description provided for @deviceType.
  ///
  /// In vi, this message translates to:
  /// **'Loại thiết bị'**
  String get deviceType;

  /// No description provided for @deviceBrand.
  ///
  /// In vi, this message translates to:
  /// **'Thương hiệu'**
  String get deviceBrand;

  /// No description provided for @deviceModel.
  ///
  /// In vi, this message translates to:
  /// **'Tên thiết bị'**
  String get deviceModel;

  /// No description provided for @os.
  ///
  /// In vi, this message translates to:
  /// **'Hệ điều hành'**
  String get os;

  /// No description provided for @browser.
  ///
  /// In vi, this message translates to:
  /// **'Trình duyệt'**
  String get browser;

  /// No description provided for @connectType.
  ///
  /// In vi, this message translates to:
  /// **'Phương thức'**
  String get connectType;

  /// No description provided for @mobileOperator.
  ///
  /// In vi, this message translates to:
  /// **'Nhà mạng'**
  String get mobileOperator;

  /// No description provided for @conversionStatus2.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái chuyển đổi'**
  String get conversionStatus2;

  /// No description provided for @data.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu'**
  String get data;

  /// No description provided for @tingxWallet.
  ///
  /// In vi, this message translates to:
  /// **'Ví TingX'**
  String get tingxWallet;

  /// No description provided for @passEmptyInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mật khẩu'**
  String get passEmptyInvalid;

  /// No description provided for @detailInvoiceCommission.
  ///
  /// In vi, this message translates to:
  /// **'Hoa hồng'**
  String get detailInvoiceCommission;

  /// No description provided for @detailInvoiceTotal.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền'**
  String get detailInvoiceTotal;

  /// No description provided for @quantity.
  ///
  /// In vi, this message translates to:
  /// **'Số lượng'**
  String get quantity;

  /// No description provided for @detailInvoiceSubTotal.
  ///
  /// In vi, this message translates to:
  /// **'Tổng hoa hồng'**
  String get detailInvoiceSubTotal;

  /// No description provided for @detailInvoiceCommissionReceived.
  ///
  /// In vi, this message translates to:
  /// **'Hoa hồng thực nhận'**
  String get detailInvoiceCommissionReceived;

  /// No description provided for @titleNewVersion.
  ///
  /// In vi, this message translates to:
  /// **'Đã có phiên bản mới'**
  String get titleNewVersion;

  /// No description provided for @contentNerVersion.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật ngay để có trải nghiệm tốt hơn'**
  String get contentNerVersion;

  /// No description provided for @update.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật'**
  String get update;

  /// No description provided for @exchangeGifts.
  ///
  /// In vi, this message translates to:
  /// **'Đổi quà'**
  String get exchangeGifts;

  /// No description provided for @exchange.
  ///
  /// In vi, this message translates to:
  /// **'Đổi ngay'**
  String get exchange;

  /// No description provided for @soldOut.
  ///
  /// In vi, this message translates to:
  /// **'Hết hàng'**
  String get soldOut;

  /// No description provided for @dp2.
  ///
  /// In vi, this message translates to:
  /// **'Điểm khả dụng'**
  String get dp2;

  /// No description provided for @shippingInformation.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin giao hàng'**
  String get shippingInformation;

  /// No description provided for @consignee.
  ///
  /// In vi, this message translates to:
  /// **'Người nhận hàng'**
  String get consignee;

  /// No description provided for @updateAddress.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật địa chỉ'**
  String get updateAddress;

  /// No description provided for @lastName.
  ///
  /// In vi, this message translates to:
  /// **'Họ'**
  String get lastName;

  /// No description provided for @firstName.
  ///
  /// In vi, this message translates to:
  /// **'Tên'**
  String get firstName;

  /// No description provided for @giftSelectCountry.
  ///
  /// In vi, this message translates to:
  /// **'Chọn quốc gia'**
  String get giftSelectCountry;

  /// No description provided for @specificAddress.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ cụ thể (Số nhà, Đường phố)'**
  String get specificAddress;

  /// No description provided for @exchangeSuccessfully.
  ///
  /// In vi, this message translates to:
  /// **'Đổi quà thành công!'**
  String get exchangeSuccessfully;

  /// No description provided for @exchangeContent.
  ///
  /// In vi, this message translates to:
  /// **'Phần quà của bạn đang được chuẩn bị và gửi đến bạn trong thời gian sớm nhất. Nếu có bất kì thắc mắc gì, vui lòng liên hệ với AM.'**
  String get exchangeContent;

  /// No description provided for @myMissions.
  ///
  /// In vi, this message translates to:
  /// **'Nhiệm vụ của bạn'**
  String get myMissions;

  /// No description provided for @goForIt.
  ///
  /// In vi, this message translates to:
  /// **'Làm ngay'**
  String get goForIt;

  /// No description provided for @giftProcessing.
  ///
  /// In vi, this message translates to:
  /// **'Đang thực hiện'**
  String get giftProcessing;

  /// No description provided for @completed.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get completed;

  /// No description provided for @missionInstructions.
  ///
  /// In vi, this message translates to:
  /// **'Hướng dẫn nhiệm vụ'**
  String get missionInstructions;

  /// No description provided for @confirmGift.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get confirmGift;

  /// No description provided for @notEnoughDp.
  ///
  /// In vi, this message translates to:
  /// **'Bạn không đủ điểm đổi quà'**
  String get notEnoughDp;

  /// No description provided for @editLocationShipping.
  ///
  /// In vi, this message translates to:
  /// **'Sửa lại'**
  String get editLocationShipping;

  /// No description provided for @emptyValid.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập'**
  String get emptyValid;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
