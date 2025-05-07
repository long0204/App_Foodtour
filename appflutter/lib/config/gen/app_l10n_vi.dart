// // ignore: unused_import
// import 'package:intl/intl.dart' as intl;
// import 'app_l10n.dart';
//
// // ignore_for_file: type=lint
//
// /// The translations for Vietnamese (`vi`).
// class AppLocalizationsVi extends AppLocalizations {
//   AppLocalizationsVi([String locale = 'vi']) : super(locale);
//
//   @override
//   String get skip => 'Bỏ qua';
//
//   @override
//   String get start => 'Bắt đầu';
//
//   @override
//   String get next => 'Tiếp theo';
//
//   @override
//   String get homePage => 'Trang chủ';
//
//   @override
//   String get news => 'Bản tin';
//
//   @override
//   String get report => 'Báo cáo';
//
//   @override
//   String get pay => 'Thanh toán';
//
//   @override
//   String get onboardPayContent => 'TingX hỗ trợ thanh toán 24/7 cho bạn. Hãy nhanh chọn cho mình một chiến dịch phù hợp để tạo ra thật nhiều hoa hồng cùng TingX nhé.';
//
//   @override
//   String get closeAppAlert => 'Vuốt 2 lần để thoát ứng dụng';
//
//   @override
//   String get loginTitle => 'Xin chào,';
//
//   @override
//   String get registerTitle => 'Chào mừng bạn,';
//
//   @override
//   String get loginWith => 'Đăng nhập với';
//
//   @override
//   String get registerWith => 'Đăng ký với';
//
//   @override
//   String get tryAgain => 'Quá nhiều lần thử, vui lòng thử lại sau';
//
//   @override
//   String get emailHintField => 'Địa chỉ email';
//
//   @override
//   String get login => 'Đăng nhập';
//
//   @override
//   String get register => 'Đăng ký';
//
//   @override
//   String get hasAccount => 'Bạn đã có tài khoản?  ';
//
//   @override
//   String get noAccount => 'Bạn chưa có tài khoản?  ';
//
//   @override
//   String get loginNow => 'Đăng nhập ngay';
//
//   @override
//   String get registerNow => 'Đăng ký ngay';
//
//   @override
//   String get accountUnavailable => 'Tài khoản không khả dụng';
//
//   @override
//   String get pleaseContactAdmin => 'Vui lòng liên hệ Admin để biết thêm chi tiết.';
//
//   @override
//   String get weHaveSentOTP => 'Chúng tôi đã gửi mã đến địa chỉ email';
//
//   @override
//   String get resendFollow => 'Gửi lại mã sau: ';
//
//   @override
//   String get noOTP => 'Không nhận được mã? ';
//
//   @override
//   String get resend => 'Gửi lại';
//
//   @override
//   String get updateInfo => 'Cập nhật thông tin';
//
//   @override
//   String get updateInfoFail => 'Cập nhật thông tin thất bại';
//
//   @override
//   String get expAff => 'Kinh nghiệm chạy affiliate *';
//
//   @override
//   String get isKOL => 'Bạn có phải là KOL, KOC không?';
//
//   @override
//   String get campaignUsed => 'Campaign từng chạy *';
//
//   @override
//   String get campaignRUsedName => 'Nhập tên campaign từng chạy affiliate';
//
//   @override
//   String get locationTitle => 'Địa chỉ *';
//
//   @override
//   String get location => 'Địa chỉ';
//
//   @override
//   String get city => 'Thành phố/tỉnh';
//
//   @override
//   String get region => 'Quận/huyện';
//
//   @override
//   String get ward => 'Phường/xã';
//
//   @override
//   String get address => 'Địa chỉ cụ thể (Số nhà, đường phố)';
//
//   @override
//   String get loginInfo => 'Thông tin đăng nhập(';
//
//   @override
//   String get phoneNumber => 'Số điện thoại';
//
//   @override
//   String get addContact => 'Thêm liên lạc';
//
//   @override
//   String get languageTitle => 'Ngôn ngữ';
//
//   @override
//   String get language => 'Tiếng việt';
//
//   @override
//   String get isPublisher => 'Bạn là publisher?';
//
//   @override
//   String get networkUsedTitle => 'Bạn đã từng chạy network nào dưới đây?';
//
//   @override
//   String get exp => 'Số năm kinh nghiệm';
//
//   @override
//   String get networkUsed => 'Nhập network từng chạy';
//
//   @override
//   String get basicInfo => 'Thông tin cơ bản * ';
//
//   @override
//   String get fbLink => 'Nhập link facebook';
//
//   @override
//   String get selectCountry => 'Chọn quốc gia';
//
//   @override
//   String get searchCountry => 'Tìm kiếm quốc gia';
//
//   @override
//   String get selectExp => 'Chọn số năm';
//
//   @override
//   String get passW => 'Mật khẩu';
//
//   @override
//   String get selectPlatform => 'Chọn platform';
//
//   @override
//   String get rePassW => 'Nhập lại Mật khẩu';
//
//   @override
//   String get selectTraffic => 'Chọn loại traffic';
//
//   @override
//   String get selectTrafficHint => 'Nhập loại traffic';
//
//   @override
//   String get selectTypeCampaign => 'Chọn thể loại';
//
//   @override
//   String get selectTypeCampaignHint => 'Nhập thể loại';
//
//   @override
//   String get addBank => 'Thêm tài khoản ngân hàng';
//
//   @override
//   String get editMethod => 'Sửa phương thức thanh toán';
//
//   @override
//   String get bankName => 'Tên ngân hàng';
//
//   @override
//   String get bankAcc => 'Chủ tài khoản';
//
//   @override
//   String get stk => 'Số tài khoản';
//
//   @override
//   String get bankAccountName => 'Tên chủ tài khoản';
//
//   @override
//   String get bankAccountNameHint => 'Nhập tên chủ tài khoản';
//
//   @override
//   String get branch => 'Chi nhánh';
//
//   @override
//   String get currency => 'Loại tiền tệ';
//
//   @override
//   String get selectCurrency => 'Chọn loại tiền tệ';
//
//   @override
//   String get confirm => 'Xác nhận';
//
//   @override
//   String get addBankWarning => 'Vui lòng đảm bảo nhập đúng thông tin ngân hàng và số tài khoản đăng ký với ngân hàng.';
//
//   @override
//   String get addBankSuccess => 'Thêm thành công';
//
//   @override
//   String get error => 'Có lỗi xảy ra, vui lòng thử lại sau';
//
//   @override
//   String get selectBank => 'Chọn ngân hàng';
//
//   @override
//   String get enterBankName => 'Nhập tên ngân hàng';
//
//   @override
//   String get delAcc => 'Xoá tài khoản';
//
//   @override
//   String get delAccTitle => 'Lưu ý, sau khi xoá tài khoản:';
//
//   @override
//   String get delWarning1 => '- Xoá các dữ liệu của bạn trên ứng dụng TingX.';
//
//   @override
//   String get delWarning2 => '- Không thể truy cập tài khoản.';
//
//   @override
//   String get delWarning3 => '- Thao tác này không thể hoàn tác.';
//
//   @override
//   String get delWarning4 => 'Việc xoá tài khoản có thể cần tới 30 ngày.';
//
//   @override
//   String get editInfo => 'Chỉnh sửa thông tin';
//
//   @override
//   String get updateInfoSuccess => 'Cập nhật thông tin thành công';
//
//   @override
//   String get save => 'Lưu';
//
//   @override
//   String get cancel => 'Huỷ';
//
//   @override
//   String get identAccount => 'Định danh tài khoản';
//
//   @override
//   String get household => 'Hộ khẩu thường trú';
//
//   @override
//   String get frontCCCD => 'Ảnh CCCD mặt trước';
//
//   @override
//   String get backCCCD => 'Ảnh CCCD mặt sau';
//
//   @override
//   String get cropImg => 'Cắt ảnh';
//
//   @override
//   String get done => 'Xong';
//
//   @override
//   String get errorChangePass => 'Lỗi, vui lòng thử lại';
//
//   @override
//   String get changePassSuccess => 'Đổi mật khẩu thành công';
//
//   @override
//   String get changePass => 'Thay đổi mật khẩu';
//
//   @override
//   String get changePassBtn => 'Đổi mật khẩu';
//
//   @override
//   String get newPass => 'Mật khẩu mới ';
//
//   @override
//   String get enterNewPass => 'Nhập mật khẩu mới';
//
//   @override
//   String get confirmPass => 'Xác nhận mật khẩu ';
//
//   @override
//   String get gmt => 'Múi giờ';
//
//   @override
//   String get plsReload => 'Có lỗi xảy ra, vui lòng tải lại';
//
//   @override
//   String get reload => 'Tải lại';
//
//   @override
//   String get member => 'Hội viên';
//
//   @override
//   String get member2 => 'Thành viên';
//
//   @override
//   String get benefit => 'Quyền lợi';
//
//   @override
//   String get noEndow => 'Bạn chưa có ưu đãi nào.';
//
//   @override
//   String get plsEndow => 'Hãy tích điểm để nâng hạng thành viên và nhận thêm nhiều ưu đãi bạn nhé!';
//
//   @override
//   String get earnPoint => 'Kiếm thêm điểm';
//
//   @override
//   String get point => 'điểm';
//
//   @override
//   String get accumulateCoins => 'Tích xu';
//
//   @override
//   String get claimPoint => 'Nhận điểm ngay';
//
//   @override
//   String get day => ' Ngày';
//
//   @override
//   String get month => 'Tháng';
//
//   @override
//   String get info => 'Thông tin';
//
//   @override
//   String get historyP => 'Lịch sử điểm';
//
//   @override
//   String get ruleP => 'Thể lệ';
//
//   @override
//   String get uMission => 'Nhiệm vụ của bạn';
//
//   @override
//   String get inProgress => 'Đang thực hiện';
//
//   @override
//   String get complete => 'Hoàn thành';
//
//   @override
//   String get accumulatedTitle => 'Điểm tích luỹ';
//
//   @override
//   String get availabilityTitle => 'Điểm khả dụng';
//
//   @override
//   String get accumulateTip => 'Tổng DP tích luỹ thực tế, là căn cứ xét hạng. Điểm không được cộng dồn qua các năm';
//
//   @override
//   String get avaTip => 'Tổng DP dùng để đổi quà';
//
//   @override
//   String get accumulateTitlePage => 'Tích luỹ';
//
//   @override
//   String get avaTitlePage => 'Khả dụng';
//
//   @override
//   String get bag => 'Túi đồ';
//
//   @override
//   String get surplus => 'Số dư';
//
//   @override
//   String get version => 'Phiên bản';
//
//   @override
//   String get terms => 'Điều khoản, điều kiện';
//
//   @override
//   String get sp => 'Liên hệ, hỗ trợ';
//
//   @override
//   String get rate => 'Đánh giá ứng dụng';
//
//   @override
//   String get other => 'Khác';
//
//   @override
//   String get beneficiaryAcc => 'Tài khoản thụ hưởng';
//
//   @override
//   String get add => 'Thêm';
//
//   @override
//   String get noBeneficiaryAcc => 'Bạn chưa cập nhật tài khoản thụ hưởng';
//
//   @override
//   String get plsUpdateBeneficiary => 'Hãy cập nhật tài khoản thụ hưởng để rút tiền hoa hồng bạn nhé!';
//
//   @override
//   String get updateNow => 'Cập nhật ngay';
//
//   @override
//   String get logOutTitle => 'Bạn có muốn đăng xuất?';
//
//   @override
//   String get brownRank => 'hạng Đồng';
//
//   @override
//   String get silverRank => 'hạng Bạc';
//
//   @override
//   String get goldRank => 'hạng Vàng';
//
//   @override
//   String get diamondRank => 'Kim Cương';
//
//   @override
//   String get nextRankContent => ' điểm nữa để lên';
//
//   @override
//   String get noIdent => 'Oh, bạn chưa định danh tài khoản!';
//
//   @override
//   String get plsIdent => 'Định danh tài khoản ngay để có thể bảo vệ tài khoản, rút tiền và mở các tính năng, nghiệp vụ bán hàng nâng cao.';
//
//   @override
//   String get identNow => 'Định danh ngay';
//
//   @override
//   String get logOut => 'Đăng xuất';
//
//   @override
//   String get detailOffer => 'Chi tiết chiến dịch';
//
//   @override
//   String get editLink => 'Sửa link chiến dịch';
//
//   @override
//   String get offerTitle => 'Chiến dịch(*)';
//
//   @override
//   String get ladiP => 'Landing page(*)';
//
//   @override
//   String get copy => 'Sao chép';
//
//   @override
//   String get copied => 'Đã sao chép';
//
//   @override
//   String get addACI => 'Thêm affiliate click id ';
//
//   @override
//   String get aic => 'Affiliate click id';
//
//   @override
//   String get addMobileParam => 'Thêm mobile parameters';
//
//   @override
//   String get iosIDFA => 'Apple ios idfa';
//
//   @override
//   String get ggGAID => 'Google android gaid';
//
//   @override
//   String get addSubId => 'Thêm sub id ';
//
//   @override
//   String get addSub => 'Thêm Sub';
//
//   @override
//   String get unlockOffer => 'Mở khoá chiến dịch';
//
//   @override
//   String get infoBenefit => 'Thông tin đãi ngộ';
//
//   @override
//   String get amountUnlock => 'Số tiền mở khoá chiến dịch';
//
//   @override
//   String get back => 'Quay lại';
//
//   @override
//   String get continueTitle => 'Tiếp tục';
//
//   @override
//   String get joinNow => 'Tham gia ngay';
//
//   @override
//   String get waitingForApproval => 'Đang đợi duyệt';
//
//   @override
//   String get hh => 'Hoa hồng:  ';
//
//   @override
//   String get waitingForApproval2 => 'Đang chờ duyệt';
//
//   @override
//   String get rejected => 'Đã từ chối';
//
//   @override
//   String get linkOffer => 'Link chiến dịch';
//
//   @override
//   String get similarOffer => 'Chiến dịch tương tự';
//
//   @override
//   String get hello => 'Xin chào';
//
//   @override
//   String get notAvailableYet => 'Tính năng đang phát triển';
//
//   @override
//   String get payIn => 'Nạp tiền';
//
//   @override
//   String get payOut => 'Rút tiền';
//
//   @override
//   String get inviteFriend => 'Mời bạn';
//
//   @override
//   String get filter => 'Bộ lọc';
//
//   @override
//   String get reset => 'Thiết lập lại';
//
//   @override
//   String get apply => 'Áp dụng';
//
//   @override
//   String get country => 'Quốc gia';
//
//   @override
//   String get enterCountryName => 'Nhập tên quốc gia';
//
//   @override
//   String get goalType => 'Hình thức chạy';
//
//   @override
//   String get listEmpty => 'Danh sách trống';
//
//   @override
//   String get hasEndList => 'Đã đến cuối danh sách';
//
//   @override
//   String get listCategory => 'Danh sách ngành hàng';
//
//   @override
//   String get search => 'Tìm kiếm';
//
//   @override
//   String get suggestTitle => 'TingX đề xuất';
//
//   @override
//   String get guide => 'Hướng dẫn';
//
//   @override
//   String get comingSoon => 'Sắp diễn ra';
//
//   @override
//   String get withU => 'Cùng';
//
//   @override
//   String get eventContent => 'Khám phá các sự kiện và tin tức thú vị';
//
//   @override
//   String get newsPage => 'Tin tức';
//
//   @override
//   String get otherNew => 'Tin tức khác';
//
//   @override
//   String get whatNews => 'Có gì mới?';
//
//   @override
//   String get noti => 'Thông báo';
//
//   @override
//   String get offer => 'Chiến dịch';
//
//   @override
//   String get transaction => 'Giao dịch';
//
//   @override
//   String get emptyNoti => 'Không có thông báo nào';
//
//   @override
//   String get del => 'Xoá';
//
//   @override
//   String get hourAgo => 'giờ trước';
//
//   @override
//   String get today => 'Hôm nay';
//
//   @override
//   String get old => 'Cũ hơn';
//
//   @override
//   String get payInSuccess => 'Nạp tiền thành công!';
//
//   @override
//   String get payInFail => 'Nạp tiền không thành công!';
//
//   @override
//   String get backToHome => 'Về trang chủ';
//
//   @override
//   String get retry => ' Thử lại';
//
//   @override
//   String get payOutFrom => 'Rút tiền từ';
//
//   @override
//   String get send => 'Gửi';
//
//   @override
//   String get accountBalance => 'Số dư tài khoản';
//
//   @override
//   String get notMetAmount => 'Bạn chưa đủ số tiền thanh toán tối thiểu';
//
//   @override
//   String get payOutFail => 'Rút tiền không thành công!';
//
//   @override
//   String get errPayOut => 'Đã xảy ra lỗi trong quá trình rút tiền.';
//
//   @override
//   String get notMetAmountErr => 'Số dư hiện tại không đủ';
//
//   @override
//   String get payOutSuccess => 'Gửi yêu cầu thành công!';
//
//   @override
//   String get payOutSuccessContent => 'Bạn đã gửi yêu cầu thanh toán thành công. Chúng tôi sẽ xử lí hoá đơn trong thời gian sớm nhất.';
//
//   @override
//   String get paymentMethod => 'Phương thức thanh toán';
//
//   @override
//   String get bankTransfer => 'Chuyển khoản ngân hàng';
//
//   @override
//   String get bank => 'Ngân hàng';
//
//   @override
//   String get needUpdateInfoBank => 'Bạn cần cập nhật thông tin tài khoản ngân hàng';
//
//   @override
//   String get needUpdateInfoBankContent => 'Hãy cập nhật thông tin tài khoản ngân hàng để rút những khoản tiền đầu tiên về ví mình nhé!';
//
//   @override
//   String get selectMethod => 'Chọn phương thức thanh toán';
//
//   @override
//   String get notMethod => 'Chưa cập nhật phương thức';
//
//   @override
//   String get amountWithdraw => 'Số tiền muốn rút';
//
//   @override
//   String get minimum => 'Tối thiểu';
//
//   @override
//   String get identDialogContent => 'Định danh tài khoản ngay để có thể bảo vệ tài khoản, rút tiền và mở các tính năng, nghiệp vụ bán hàng nâng cao.';
//
//   @override
//   String get close => 'Đóng';
//
//   @override
//   String get listReferral => 'Danh sách referral';
//
//   @override
//   String get referralEmpty => 'Danh sách giới thiệu trống';
//
//   @override
//   String get referralContent => 'Hãy tích cực chia sẻ link giới thiệu nhiều bạn bè hơn nữa để nhận thật nhiều hoa hồng nha.';
//
//   @override
//   String get introduceNow => 'Giới thiệu ngay';
//
//   @override
//   String get introduceNewFr => 'Giới thiệu bạn mới';
//
//   @override
//   String get headRefTitle => 'Nhận thưởng không giới hạn';
//
//   @override
//   String get headRefContentReg => 'Đăng ký link và giới thiệu cho bạn bè để nhận hoa hồng bạn nhé!';
//
//   @override
//   String get headRefContentShare => 'Chia sẻ link giới thiệu cho bạn bè để nhận hoa hồng bạn nhé!';
//
//   @override
//   String get refLinkOutDate => 'Liên kết giới thiệu của bạn hết hạn';
//
//   @override
//   String get refLinkOutDateContent => 'Vui lòng liên hệ AM để tạo link liên kết và giới thiệu cho bạn bè để nhận hoa hồng bạn nhé!';
//
//   @override
//   String get unexpired => 'Còn hạn';
//
//   @override
//   String get expired => 'Hết hạn';
//
//   @override
//   String get totalBonus => 'Tổng số tiền bonus';
//
//   @override
//   String get bonusPaid => 'Bonus đã thanh toán';
//
//   @override
//   String get amountMoney => 'Số tiền';
//
//   @override
//   String get notes => 'Ghi chú';
//
//   @override
//   String get noRecorded => 'Chưa có dữ liệu nào\n được ghi nhận';
//
//   @override
//   String get effectiveDate => 'Ngày hiệu lực';
//
//   @override
//   String get progress => 'Tiến trình';
//
//   @override
//   String get historyPay => 'Lịch sử thanh toán';
//
//   @override
//   String get time => 'Thời gian';
//
//   @override
//   String get convert => 'Chuyển đổi';
//
//   @override
//   String get soDon => 'Số đơn';
//
//   @override
//   String get unit => '(Đơn vị : dvt)';
//
//   @override
//   String get now => 'Hiện tại';
//
//   @override
//   String get previous => 'Kỳ trước';
//
//   @override
//   String get currencyUnit => 'Đơn vị tiền tệ';
//
//   @override
//   String get approved => 'Được duyệt';
//
//   @override
//   String get pending => 'Đang xử lý';
//
//   @override
//   String get trash => 'Không hợp lệ';
//
//   @override
//   String get denied => 'Bị từ chối';
//
//   @override
//   String get preApproved => 'Tạm duyệt';
//
//   @override
//   String get selectTime => 'Chọn khoảng thời gian';
//
//   @override
//   String get enterOfferName => 'Nhập tên chiến dịch';
//
//   @override
//   String get selectOffer => 'Chọn chiến dịch';
//
//   @override
//   String get noRecordOvView => 'Chưa có dữ liệu nào được ghi nhận';
//
//   @override
//   String get chart => 'Biểu đồ';
//
//   @override
//   String get revenue => 'Doanh thu';
//
//   @override
//   String get averageIncome => 'Thu nhập TB/tháng';
//
//   @override
//   String get approvalRate => 'Tỷ lệ phê duyệt (AR)';
//
//   @override
//   String get conversionRate => 'Tỷ lệ chuyển đổi (CR)';
//
//   @override
//   String get detailInvoice => 'Chi tiết lịch sử thanh toán';
//
//   @override
//   String get invoice => 'Hoá đơn';
//
//   @override
//   String get startDate => 'Thời gian tạo';
//
//   @override
//   String get endDate => 'Thời gian hết hạn';
//
//   @override
//   String get payInfo => 'Thông tin thanh toán';
//
//   @override
//   String get listOffer => 'Danh sách chiến dịch';
//
//   @override
//   String get amountPaid => 'Đã thanh toán';
//
//   @override
//   String get availability => 'Khả dụng';
//
//   @override
//   String get pendingPay => 'Chờ thanh toán';
//
//   @override
//   String get incomeBill => 'Hoá đơn thu nhập';
//
//   @override
//   String get payInFromBank => 'Từ ngân hàng vào TingX';
//
//   @override
//   String get payOutFromTingX => 'Từ TingX về ngân hàng';
//
//   @override
//   String get saleStatistics => 'Thống kê doanh số nhé!';
//
//   @override
//   String get overView => 'Tổng quan';
//
//   @override
//   String get processing => 'Chờ xử lí';
//
//   @override
//   String get emptySearch => 'Không tìm thấy kết quả nào';
//
//   @override
//   String get hintSearch => 'Hãy thử sử dụng các từ khoá chung chung hơn';
//
//   @override
//   String get delHistorySearch => 'Xoá lịch sử tìm kiếm';
//
//   @override
//   String get seeMore => 'Hiển thị nhiều hơn';
//
//   @override
//   String get setting => 'Cài đặt';
//
//   @override
//   String get onMic => 'Để tiếp tục sử dụng tính năng vui lòng bật micrô';
//
//   @override
//   String get speechHint => 'Bạn cần tìm gì?';
//
//   @override
//   String get reMic => 'Hãy nhấn vào micrô để thử lại';
//
//   @override
//   String get account => 'Tài khoản';
//
//   @override
//   String get searchHintText => 'Nhập để tìm kiếm...';
//
//   @override
//   String get emptySearchDropDown => 'Không có kết quả tìm kiếm';
//
//   @override
//   String get select => 'Chọn';
//
//   @override
//   String get all => 'Tất cả';
//
//   @override
//   String get mobileApp => 'Ứng dụng\ndi động';
//
//   @override
//   String get eCommerce => 'Thương mại điện tử';
//
//   @override
//   String get functionalFoods => 'Thực phẩm chức năng';
//
//   @override
//   String get finance => 'Tài chính';
//
//   @override
//   String get cosmetics => 'Mỹ phẩm';
//
//   @override
//   String get tooManyTries => 'Quá nhiều lần thử';
//
//   @override
//   String get sendOTPFail => 'Gửi mã thất bại';
//
//   @override
//   String get reSendOTPFail => 'Gửi lại mã thất bại';
//
//   @override
//   String get invalidOTP => 'Mã OTP không đúng định dạng';
//
//   @override
//   String get otpNotCorrect => 'Mã xác minh chưa chính xác';
//
//   @override
//   String get loginFail => 'Đăng nhập thất bại';
//
//   @override
//   String get plsTryAgain => 'Vui lòng thử lại hoặc liên hệ tổng đài để được trợ giúp.';
//
//   @override
//   String get invalidSelectBankName => 'Vui lòng chọn tên ngân hàng';
//
//   @override
//   String get invalidNameBank => 'Vui lòng nhập tên chủ tài khoản';
//
//   @override
//   String get invalidNameBankContainVNChar => 'Tên CTK phải là không dấu';
//
//   @override
//   String get accNumInvalid => 'Vui lòng nhập số tài khoản';
//
//   @override
//   String get onlyNumber => 'Chỉ nhập số';
//
//   @override
//   String get currencyInvalid => 'Vui lòng chọn loại tiền tệ';
//
//   @override
//   String get passNotMatch => 'Mật khẩu không trùng khớp';
//
//   @override
//   String get invalidFirstName => 'Vui lòng nhập họ';
//
//   @override
//   String get invalidLastName => 'Vui lòng nhập tên';
//
//   @override
//   String get option => 'Tuỳ chọn';
//
//   @override
//   String get yesterday => 'Hôm qua';
//
//   @override
//   String get thisWeek => 'Tuần này';
//
//   @override
//   String get lastWeek => 'Tuần trước';
//
//   @override
//   String get thisMonth => 'Tháng này';
//
//   @override
//   String get last30Days => '30 ngày gần nhất';
//
//   @override
//   String get emailEmptyInvalid => 'Vui lòng nhập Email';
//
//   @override
//   String get emailInvalid => 'Email không đúng định dạng';
//
//   @override
//   String get passLengthInvalid => 'Mật khẩu có độ dài từ 6 ký tự';
//
//   @override
//   String get passInvalid => 'Mật khẩu sai định dạng';
//
//   @override
//   String get phoneEmptyInvalid => 'Vui lòng nhập số điện thoại';
//
//   @override
//   String get phoneLengthInvalid => 'Số điện thoại có độ dài từ 9 -> 12';
//
//   @override
//   String get phoneInvalid => 'Số điện thoại sai định dạng';
//
//   @override
//   String get plsGrantPermission => 'Vui lòng cấp phép trong cài đặt điện thoại';
//
//   @override
//   String get lib => 'Thư viện';
//
//   @override
//   String get pickImgFrom => 'Chọn ảnh từ';
//
//   @override
//   String get monday => 'Thứ Hai';
//
//   @override
//   String get tuesday => 'Thứ Ba';
//
//   @override
//   String get wednesday => 'Thứ Tư';
//
//   @override
//   String get thursday => 'Thứ Năm';
//
//   @override
//   String get friday => 'Thứ Sáu';
//
//   @override
//   String get saturday => 'Thứ Bảy';
//
//   @override
//   String get sunday => 'Chủ Nhật';
//
//   @override
//   String get unknown => 'Không xác định';
//
//   @override
//   String get brownRank2 => 'Hạng Đồng';
//
//   @override
//   String get silverRank2 => 'Hạng Bạc';
//
//   @override
//   String get goldRank2 => 'Hạng Vàng';
//
//   @override
//   String get selectLanguage => 'Chọn ngôn ngữ';
//
//   @override
//   String get createdAt => 'Ngày tạo';
//
//   @override
//   String get conversionDetail => 'Chi tiết chuyển đổi';
//
//   @override
//   String get date => 'Ngày';
//
//   @override
//   String get updatedAt => 'Ngày thay đổi';
//
//   @override
//   String get conversionStatus => 'Trạng thái';
//
//   @override
//   String get tax => 'Thuế';
//
//   @override
//   String get paymentStatus => 'Thanh toán';
//
//   @override
//   String get unPaid => 'Chưa thánh toán';
//
//   @override
//   String get advertiserOffer => 'Nhà cung cấp và chiến dịch';
//
//   @override
//   String get goal => 'Hình thức chạy';
//
//   @override
//   String get contact => 'Liên lạc';
//
//   @override
//   String get fName => 'Họ';
//
//   @override
//   String get lName => 'Tên';
//
//   @override
//   String get custom => 'Tuỳ chỉnh';
//
//   @override
//   String get technical => 'Kỹ thuật';
//
//   @override
//   String get ip => 'Địa chỉ IP';
//
//   @override
//   String get geo => 'Địa điểm';
//
//   @override
//   String get deviceType => 'Loại thiết bị';
//
//   @override
//   String get deviceBrand => 'Thương hiệu';
//
//   @override
//   String get deviceModel => 'Tên thiết bị';
//
//   @override
//   String get os => 'Hệ điều hành';
//
//   @override
//   String get browser => 'Trình duyệt';
//
//   @override
//   String get connectType => 'Phương thức';
//
//   @override
//   String get mobileOperator => 'Nhà mạng';
//
//   @override
//   String get conversionStatus2 => 'Trạng thái chuyển đổi';
//
//   @override
//   String get data => 'Dữ liệu';
//
//   @override
//   String get tingxWallet => 'Ví TingX';
//
//   @override
//   String get passEmptyInvalid => 'Vui lòng nhập mật khẩu';
//
//   @override
//   String get detailInvoiceCommission => 'Hoa hồng';
//
//   @override
//   String get detailInvoiceTotal => 'Số tiền';
//
//   @override
//   String get quantity => 'Số lượng';
//
//   @override
//   String get detailInvoiceSubTotal => 'Tổng hoa hồng';
//
//   @override
//   String get detailInvoiceCommissionReceived => 'Hoa hồng thực nhận';
//
//   @override
//   String get titleNewVersion => 'Đã có phiên bản mới';
//
//   @override
//   String get contentNerVersion => 'Cập nhật ngay để có trải nghiệm tốt hơn';
//
//   @override
//   String get update => 'Cập nhật';
//
//   @override
//   String get exchangeGifts => 'Đổi quà';
//
//   @override
//   String get exchange => 'Đổi ngay';
//
//   @override
//   String get soldOut => 'Hết hàng';
//
//   @override
//   String get dp2 => 'Điểm khả dụng';
//
//   @override
//   String get shippingInformation => 'Thông tin giao hàng';
//
//   @override
//   String get consignee => 'Người nhận hàng';
//
//   @override
//   String get updateAddress => 'Cập nhật địa chỉ';
//
//   @override
//   String get lastName => 'Họ';
//
//   @override
//   String get firstName => 'Tên';
//
//   @override
//   String get giftSelectCountry => 'Chọn quốc gia';
//
//   @override
//   String get specificAddress => 'Địa chỉ cụ thể (Số nhà, Đường phố)';
//
//   @override
//   String get exchangeSuccessfully => 'Đổi quà thành công!';
//
//   @override
//   String get exchangeContent => 'Phần quà của bạn đang được chuẩn bị và gửi đến bạn trong thời gian sớm nhất. Nếu có bất kì thắc mắc gì, vui lòng liên hệ với AM.';
//
//   @override
//   String get myMissions => 'Nhiệm vụ của bạn';
//
//   @override
//   String get goForIt => 'Làm ngay';
//
//   @override
//   String get giftProcessing => 'Đang thực hiện';
//
//   @override
//   String get completed => 'Hoàn thành';
//
//   @override
//   String get missionInstructions => 'Hướng dẫn nhiệm vụ';
//
//   @override
//   String get confirmGift => 'Tiếp tục';
//
//   @override
//   String get notEnoughDp => 'Bạn không đủ điểm đổi quà';
//
//   @override
//   String get editLocationShipping => 'Sửa lại';
//
//   @override
//   String get emptyValid => 'Vui lòng nhập';
// }
