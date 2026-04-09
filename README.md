# 🍜 FoodTour - Khám phá ẩm thực xung quanh bạn

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev/)
[![Riverpod](https://img.shields.io/badge/Riverpod-2.5.1-green.svg)](https://riverpod.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange.svg)](https://firebase.google.com/)

Ứng dụng di động giúp bạn khám phá và đánh giá các quán ăn ngon xung quanh.

---

## ✨ Tính năng

- 🔐 **Đăng nhập đa nền tảng:** Email, Google, Apple Sign In
- 📍 **Gợi ý thông minh:** Dựa trên vị trí và thời gian
- 🗺️ **Bản đồ tương tác:** Xem quán ăn trên bản đồ
- 🧭 **Dẫn đường:** Chỉ đường đến quán ăn
- ⭐ **Đánh giá & Review:** Chia sẻ trải nghiệm
- 📸 **Upload ảnh:** Thêm hình ảnh món ăn
- 🎡 **Vòng quay may mắn:** Gợi ý ngẫu nhiên
- 🌐 **Đa ngôn ngữ:** Tiếng Việt & English

---

## 🏗️ Kiến trúc

### State Management
- **Riverpod 2.5.1** - State management & DI
- **Riverpod Generator** - Code generation

### Backend
- **Firebase:** Auth, Firestore, Storage, Crashlytics
- **Supabase:** Database & API
- **REST API:** Custom backend

### UI/UX
- **Flutter ScreenUtil** - Responsive design
- **Animate Do** - Animations
- **Flutter Map** - Interactive maps
- **Lottie** - Animations

---

## 📁 Cấu trúc dự án

```
lib/
├── config/           # Constants, themes, l10n
├── core/             # Core functionality
│   ├── api/          # API client
│   ├── cache/        # Cache manager
│   ├── error/        # Error handling
│   ├── network/      # Network utilities
│   └── providers/    # Core providers
├── data/             # Data layer
│   ├── model/        # Data models
│   └── sources/      # Data sources
├── providers/        # Global providers
├── services/         # Services (auth, storage, etc.)
├── ui/               # UI screens
│   ├── auth/         # Authentication
│   ├── home/         # Home screen
│   ├── map/          # Map screen
│   └── account/      # Account screen
├── utils/            # Utilities
└── widgets/          # Reusable widgets
```

---

## 🚀 Bắt đầu

### Yêu cầu

- Flutter SDK 3.x
- Dart 3.x
- iOS 13+ / Android 5.0+
- Xcode 14+ (cho iOS)
- Android Studio / VS Code

### Cài đặt

1. **Clone repository:**
```bash
git clone https://github.com/your-repo/foodtour.git
cd foodtour
```

2. **Cài đặt dependencies:**
```bash
flutter pub get
```

3. **Setup environment variables:**
```bash
cp .env.example .env
# Edit .env với API keys của bạn
```

4. **Setup Firebase:**
- Tạo project trên Firebase Console
- Download `google-services.json` (Android) và `GoogleService-Info.plist` (iOS)
- Đặt vào thư mục tương ứng

5. **iOS Setup (cho Apple Sign In):**
```bash
cd ios
pod install
cd ..
```
- Mở `ios/Runner.xcworkspace` trong Xcode
- Add "Sign in with Apple" capability
- Enable trong Apple Developer Portal

6. **Run app:**
```bash
flutter run
```

---

## 🔧 Configuration

### Environment Variables (.env)

```env
BASE_URL=https://your-api.com/api
GOOGLE_SHEETS_API_KEY=your_key
CLOUDINARY_CLOUD_NAME=your_cloud
```

### Firebase Configuration

1. **Android:** `android/app/google-services.json`
2. **iOS:** `ios/Runner/GoogleService-Info.plist`

---

## 🧪 Testing

### Run tests:
```bash
# Unit tests
flutter test test/unit/

# Widget tests
flutter test test/widget/

# All tests
flutter test

# With coverage
flutter test --coverage
```

Xem thêm: [TESTING_GUIDE.md](TESTING_GUIDE.md)

---

## 📦 Build

### Android APK:
```bash
flutter build apk --release
```

### Android App Bundle:
```bash
flutter build appbundle --release
```

### iOS:
```bash
flutter build ios --release
```

---

## 🔄 Refactor History

### Phase 1: Critical Fixes (Completed)
- ✅ Removed duplicate auth systems
- ✅ Removed GetIt DI (pure Riverpod)
- ✅ Secured environment variables (.env)

### Phase 2: Code Cleanup (Completed)
- ✅ Cleaned unused imports
- ✅ API Client refactored to Riverpod provider
- ✅ Migrated 6 providers

### Phase 3: Optimization (Completed)
- ✅ Cache manager with LRU eviction
- ✅ Custom exception classes
- ✅ Retry policy for failed requests
- ✅ Offline mode detection
- ✅ Testing guide & structure

Xem chi tiết: [REFACTOR_ACTION_PLAN.md](REFACTOR_ACTION_PLAN.md)

---

## 🐛 Known Issues

### Apple Sign In
- Chỉ hoạt động trên device thật (iOS 13+)
- Cần Apple Developer Account
- Xem fix: [APPLE_SIGNIN_FIX.md](APPLE_SIGNIN_FIX.md)

---

## 📝 Documentation

- [REFACTOR_ACTION_PLAN.md](REFACTOR_ACTION_PLAN.md) - Refactor plan
- [TESTING_GUIDE.md](TESTING_GUIDE.md) - Testing guide
- [APPLE_SIGNIN_FIX.md](APPLE_SIGNIN_FIX.md) - Apple Sign In fix

---

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License.

---

## 👥 Team

- **Project Manager & QA:** Hương Ngáo 🔍🤪
- **Developer:** Long (Đại ca)

---

## 📞 Support

Có vấn đề? Tạo issue trên GitHub hoặc liên hệ team!

---

**Made with ❤️ by FoodTour Team**
