flutter clean
rm ios/Podfile.lock pubspec.lock
rm -rf ios/Pods ios/.symlinks
flutter pub get
cd ios
pod install
cd ..
flutter build ios --release