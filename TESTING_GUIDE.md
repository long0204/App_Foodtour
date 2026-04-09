# Testing Guide - FoodTour App

## 📁 Test Structure

```
test/
├── unit/
│   ├── providers/
│   │   ├── auth_provider_test.dart
│   │   ├── community_provider_test.dart
│   │   └── suggestion_provider_test.dart
│   ├── services/
│   │   ├── auth_service_test.dart
│   │   └── cache_manager_test.dart
│   └── utils/
│       └── validators_test.dart
├── widget/
│   ├── auth/
│   │   └── login_screen_test.dart
│   └── home/
│       └── home_screen_test.dart
└── integration/
    └── auth_flow_test.dart
```

## 🧪 Unit Tests

### Example: Provider Test

```dart
// test/unit/providers/suggestion_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('SuggestionNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is loading', () {
      final state = container.read(suggestionProvider);
      expect(state, isA<AsyncLoading>());
    });

    test('fetchSuggestions returns data', () async {
      final notifier = container.read(suggestionProvider.notifier);
      
      await notifier.fetchSuggestions(21.0285, 105.8542);
      
      final state = container.read(suggestionProvider);
      expect(state, isA<AsyncData>());
    });
  });
}
```

### Example: Service Test

```dart
// test/unit/services/cache_manager_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CacheManager', () {
    late CacheManager<String> cache;

    setUp(() {
      cache = CacheManager<String>(
        defaultTTL: Duration(seconds: 1),
        maxSize: 3,
      );
    });

    test('set and get value', () {
      cache.set('key1', 'value1');
      expect(cache.get('key1'), 'value1');
    });

    test('expired value returns null', () async {
      cache.set('key1', 'value1', ttl: Duration(milliseconds: 100));
      await Future.delayed(Duration(milliseconds: 200));
      expect(cache.get('key1'), isNull);
    });

    test('LRU eviction when cache is full', () {
      cache.set('key1', 'value1');
      cache.set('key2', 'value2');
      cache.set('key3', 'value3');
      cache.set('key4', 'value4'); // Should evict key1
      
      expect(cache.has('key1'), false);
      expect(cache.has('key4'), true);
    });
  });
}
```

## 🎨 Widget Tests

### Example: Login Screen Test

```dart
// test/widget/auth/login_screen_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('Login screen shows all auth buttons', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    expect(find.text('Tiếp tục với Email'), findsOneWidget);
    expect(find.text('Đăng nhập với Google'), findsOneWidget);
    expect(find.text('Đăng nhập với Apple'), findsOneWidget);
  });

  testWidgets('Tapping Google button triggers login', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    await tester.tap(find.text('Đăng nhập với Google'));
    await tester.pump();

    // Verify loading indicator appears
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
```

## 🔗 Integration Tests

### Example: Auth Flow Test

```dart
// test/integration/auth_flow_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete auth flow', (tester) async {
    // Launch app
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    // Should show login screen
    expect(find.text('Chào mừng tới'), findsOneWidget);

    // Tap email login
    await tester.tap(find.text('Tiếp tục với Email'));
    await tester.pumpAndSettle();

    // Enter credentials
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.enterText(find.byType(TextField).last, 'password123');

    // Submit
    await tester.tap(find.text('Đăng nhập'));
    await tester.pumpAndSettle();

    // Should navigate to home
    expect(find.text('FoodTour'), findsOneWidget);
  });
}
```

## 🚀 Running Tests

### Unit Tests
```bash
flutter test test/unit/
```

### Widget Tests
```bash
flutter test test/widget/
```

### Integration Tests
```bash
flutter test integration_test/
```

### All Tests
```bash
flutter test
```

### With Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 📦 Required Packages

Add to `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  mockito: ^5.4.0
  build_runner: ^2.4.13
```

## ✅ Best Practices

1. **Test naming:** Use descriptive names
2. **Arrange-Act-Assert:** Structure tests clearly
3. **Mock dependencies:** Use mockito for external dependencies
4. **Test coverage:** Aim for >80% coverage
5. **Fast tests:** Keep unit tests under 100ms
6. **Isolated tests:** Each test should be independent

## 🎯 Priority Tests

**High Priority:**
- Auth flow (login, logout, session)
- API client (requests, errors, retry)
- Cache manager (set, get, expiration)
- Providers (state management)

**Medium Priority:**
- Validators (email, password)
- Error handling
- Navigation

**Low Priority:**
- UI widgets (buttons, cards)
- Animations
- Styling

---

_Testing ensures code quality and prevents regressions!_ 🧪
