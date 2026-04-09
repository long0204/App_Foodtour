# 🔧 REFACTOR ACTION PLAN - FOODTOUR APP

**Ngày:** 09/04/2026  
**Người thực hiện:** Hương Ngáo (QA & PM)  
**Mục tiêu:** Chuẩn hóa architecture, loại bỏ duplicate code, tối ưu performance

---

## 📋 TỔNG QUAN VẤN ĐỀ

Sau khi audit toàn bộ dự án, phát hiện các vấn đề chính:

1. **3 auth providers khác nhau** → Gây confusion, duplicate logic
2. **Mix GetIt + Riverpod** → DI không consistent
3. **API keys hardcoded** → Security risk
4. **Unused/commented code** → Code smell
5. **Mixed state management patterns** → Khó maintain

---

## 🎯 ACTION PLAN (3 PHASES)

### **PHASE 1: CRITICAL FIXES (Priority 1)** ⚡
**Timeline:** 2-3 giờ  
**Goal:** Fix các vấn đề nghiêm trọng ảnh hưởng architecture

#### Task 1.1: Chuẩn hóa Auth System
- [ ] **Chọn auth system chính:** `lib/ui/auth/providers/auth_notifier.dart` (Firebase direct)
- [ ] **Xóa:** `lib/providers/auth_provider.dart` (commented)
- [ ] **Xóa:** `lib/presentation/providers/auth_provider.dart` (Clean Architecture - chưa dùng)
- [ ] **Xóa:** `lib/domain/usecases/login_usecase.dart`, `logout_usecase.dart`
- [ ] **Xóa:** `lib/data/repositories/auth_repository_impl.dart`
- [ ] **Xóa:** `lib/data/datasources/remote/auth_remote_datasource.dart`
- [ ] **Xóa:** `lib/data/datasources/local/secure_storage_datasource.dart`
- [ ] **Update:** Tất cả imports liên quan

**Lý do:** Firebase Auth đã được implement đầy đủ trong `auth_notifier.dart`, không cần thêm abstraction layer

#### Task 1.2: Loại bỏ GetIt DI
- [ ] **Xóa:** `lib/core/di/injection.dart`
- [ ] **Xóa:** `lib/core/providers/repository_providers.dart`
- [ ] **Xóa:** `lib/core/providers/usecase_providers.dart`
- [ ] **Remove dependency:** `get_it: 7.7.0` từ `pubspec.yaml`
- [ ] **Migrate:** API Client sang Riverpod provider

**Lý do:** Riverpod đã đủ mạnh cho DI, không cần GetIt

#### Task 1.3: Secure Environment Variables
- [ ] **Create:** `.env` file ở root
- [ ] **Add:** `.env` vào `.gitignore`
- [ ] **Install:** `flutter_dotenv` package
- [ ] **Move:** API keys từ `env.dart` sang `.env`
- [ ] **Update:** `env.dart` để đọc từ `.env`
- [ ] **Create:** `.env.example` template

**File `.env`:**
```env
BASE_URL=https://foodend.onrender.com/api
GOOGLE_SHEETS_API_KEY=AIzaSyCVGKpHpigRX3b15mHDbXU2w40GBMXTC9g
SPREADSHEET_ID=14Y_Y8-UFLkVKo3HYmsBPylz28SZy2fPj2z5DzORxFac
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
```

---

### **PHASE 2: CODE CLEANUP (Priority 2)** 🧹
**Timeline:** 1-2 giờ  
**Goal:** Xóa code thừa, chuẩn hóa patterns

#### Task 2.1: Xóa Unused Code
- [ ] **Xóa:** `lib/ui/home/providers/state.dart` (toàn bộ commented)
- [ ] **Xóa:** `lib/presentation/screens/auth/login_screen_example.dart` (example file)
- [ ] **Review & xóa:** Tất cả TODO comments không còn relevant
- [ ] **Xóa:** Unused imports (run `dart fix --dry-run`)

#### Task 2.2: Chuẩn hóa State Management
- [ ] **Quyết định:** Chỉ dùng Riverpod Generator (`@riverpod`)
- [ ] **Migrate:** `CommunityRestaurantNotifier` sang Riverpod Generator
- [ ] **Migrate:** `SuggestionNotifier` sang Riverpod Generator
- [ ] **Remove:** Manual StateNotifier classes
- [ ] **Run:** `flutter pub run build_runner build --delete-conflicting-outputs`

#### Task 2.3: API Client Refactor
- [ ] **Create:** `lib/core/providers/api_client_provider.dart`
- [ ] **Convert:** `apiClient` global variable → Riverpod provider
- [ ] **Update:** Tất cả nơi dùng `apiClient` → `ref.read(apiClientProvider)`

**Code mẫu:**
```dart
@riverpod
ApiClient apiClient(ApiClientRef ref) {
  return ApiClient(secureStorage: secureStorage);
}
```

---

### **PHASE 3: OPTIMIZATION (Priority 3)** 🚀
**Timeline:** 2-3 giờ  
**Goal:** Tối ưu performance, improve code quality

#### Task 3.1: Improve Caching
- [ ] **Add:** Cache invalidation strategy
- [ ] **Add:** Cache size limits
- [ ] **Implement:** LRU cache cho images
- [ ] **Add:** Cache clear on logout

#### Task 3.2: Error Handling Enhancement
- [ ] **Create:** Custom exception classes
- [ ] **Add:** User-friendly error messages
- [ ] **Implement:** Retry logic cho failed requests
- [ ] **Add:** Offline mode detection

#### Task 3.3: Testing Setup
- [ ] **Setup:** Test folder structure
- [ ] **Add:** Unit tests cho providers
- [ ] **Add:** Widget tests cho critical screens
- [ ] **Add:** Integration tests cho auth flow

#### Task 3.4: Documentation
- [ ] **Update:** README.md với setup instructions
- [ ] **Add:** Architecture diagram
- [ ] **Document:** API endpoints
- [ ] **Add:** Contributing guidelines

---

## 📊 TRACKING

### Phase 1 Progress
- [ ] Task 1.1: Auth System (0/6)
- [ ] Task 1.2: Remove GetIt (0/5)
- [ ] Task 1.3: Environment Variables (0/6)

### Phase 2 Progress
- [ ] Task 2.1: Cleanup (0/4)
- [ ] Task 2.2: State Management (0/5)
- [ ] Task 2.3: API Client (0/3)

### Phase 3 Progress
- [ ] Task 3.1: Caching (0/4)
- [ ] Task 3.2: Error Handling (0/4)
- [ ] Task 3.3: Testing (0/4)
- [ ] Task 3.4: Documentation (0/4)

---

## ⚠️ RISKS & MITIGATION

**Risk 1:** Breaking existing features khi xóa code  
**Mitigation:** Test kỹ sau mỗi task, commit nhỏ, có thể rollback

**Risk 2:** Merge conflicts nếu team đang code  
**Mitigation:** Thông báo team trước, tạo branch riêng

**Risk 3:** Environment variables bị expose  
**Mitigation:** Double check `.gitignore`, review PR kỹ

---

## 🎯 SUCCESS CRITERIA

- ✅ Chỉ còn 1 auth provider duy nhất
- ✅ Không còn GetIt trong codebase
- ✅ API keys không còn trong code
- ✅ Không còn commented code
- ✅ Tất cả providers dùng Riverpod Generator
- ✅ Build thành công không lỗi
- ✅ App chạy bình thường sau refactor

---

## 📝 NOTES

- Backup code trước khi bắt đầu
- Commit sau mỗi task hoàn thành
- Test trên emulator sau mỗi phase
- Update team progress mỗi 2 giờ

---

**Bắt đầu:** 09/04/2026 - 19:30  
**Dự kiến hoàn thành:** 10/04/2026 - 02:00 (6-8 giờ)
