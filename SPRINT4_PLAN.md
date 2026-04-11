# 🚀 SPRINT 4 - BUG FIXES & CODE QUALITY

**Ngày bắt đầu:** 11/04/2026  
**Thời gian:** 3-4 ngày  
**QA Engineer:** Đệ sói ngáo 🐺🤪  
**PM:** Đại ca Long

---

## 🎯 MỤC TIÊU SPRINT

1. **Fix tất cả critical bugs** (P0)
2. **Clean up code quality** (P1)
3. **Improve UI/UX** (Bug.md issues)
4. **Update dependencies** (125 packages)

**Target Code Quality:** 6.5/10 → 9.0/10

---

## 📋 TASK BREAKDOWN

### 🔴 DAY 1 - CRITICAL FIXES (11/04/2026)

#### **TASK-S4-001: Fix Secure Storage Issues** ⏱️ 1h
**Priority:** P0 - CRITICAL  
**Files:**
- `lib/core/api/interceptor.dart`
- `lib/services/secure_storage_service.dart`

**Issues:**
1. Fix import path: `../services/secure_storage_service.dart`
2. Initialize `secureStorage` properly
3. Remove/implement `import()` method

**Acceptance Criteria:**
- ✅ No import errors
- ✅ secureStorage accessible in interceptor
- ✅ Compilation successful

---

#### **TASK-S4-002: Fix API Client Initialization** ⏱️ 1h
**Priority:** P0 - CRITICAL  
**Bug:** `LateInitializationError: Field 'apiClient' has not been initialized`

**Root Cause:** apiClient chưa được init trước khi dùng

**Files to check:**
- `lib/core/providers/api_client_provider.dart`
- `lib/providers/community_provider.dart`
- `lib/ui/map/providers/notifier.dart`
- `lib/ui/address/providers/notifier.dart`

**Fix:**
```dart
// Ensure apiClient is initialized in main.dart
// Or use proper Riverpod provider pattern
```

**Acceptance Criteria:**
- ✅ No LateInitializationError
- ✅ Map loads restaurants successfully
- ✅ All API calls work

---

#### **TASK-S4-003: Fix Login Flow** ⏱️ 1.5h
**Priority:** P0 - CRITICAL  
**Bug:** Google/Apple login không tự động đăng ký

**Files:**
- `lib/ui/auth/login_screen.dart`
- `lib/services/auth_service.dart`
- `lib/data/repositories/auth_repository.dart`

**Current behavior:**
- User clicks Google/Apple login
- Firebase auth succeeds
- But app doesn't register user in backend
- User stuck at login screen

**Expected behavior:**
- Click Google/Apple login
- Firebase auth succeeds
- Auto-register user in backend if new
- Navigate to home screen

**Acceptance Criteria:**
- ✅ New users auto-register
- ✅ Existing users login successfully
- ✅ Navigate to home after login
- ✅ Test on both Google & Apple

---

#### **TASK-S4-004: Remove Dead Imports** ⏱️ 30min
**Priority:** P0 - CRITICAL  
**Files:**
- `lib/widgets/package/package.dart` (accordion import)
- `lib/core/di/injection.dart` (if still exists)

**Fix:**
```dart
// Remove this line:
// export 'accordion/accordion.dart';
```

**Acceptance Criteria:**
- ✅ No import errors
- ✅ Compilation successful

---

#### **TASK-S4-005: Fix Location Service** ⏱️ 30min
**Priority:** P0 - CRITICAL  
**File:** `lib/services/location_service.dart:34`

**Issue:** Null can't be returned in onError

**Fix:**
```dart
// Change return type or handle error properly
```

**Acceptance Criteria:**
- ✅ No type errors
- ✅ Location service works

---

**DAY 1 TOTAL:** ~4.5 hours

---

### 🟡 DAY 2 - CODE CLEANUP (12/04/2026)

#### **TASK-S4-006: Clean Unused Imports** ⏱️ 1h
**Priority:** P1 - HIGH  
**Count:** 30 files

**Method:**
```bash
# Auto-fix
dart fix --apply

# Manual review
# Check each file
```

**Files (sample):**
- `lib/ui/auth/login_screen.dart`
- `lib/popup/HeartShape.dart`
- `lib/ui/account/widgets/edit_profile_screen.dart`
- `lib/ui/add_place/add_place_screen.dart`
- And 26+ more...

**Acceptance Criteria:**
- ✅ All unused imports removed
- ✅ No compilation errors
- ✅ App runs successfully

---

#### **TASK-S4-007: Remove Dead Code** ⏱️ 1.5h
**Priority:** P1 - HIGH  
**Count:** 15 unused fields/variables

**Files:**
- `lib/core/route.dart:40` - `_isLoggedIn`
- `lib/services/fire_store.dart:9,10` - `_softDocId`, `_forceDocId`
- `lib/ui/add_place/add_place_screen.dart:39` - `_accentColor`
- `lib/ui/map/food_map_screen.dart:33` - `_navigatingTo`
- And 11+ more...

**Acceptance Criteria:**
- ✅ All unused code removed
- ✅ No warnings
- ✅ App functionality unchanged

---

#### **TASK-S4-008: Fix Null-Aware Expressions** ⏱️ 1h
**Priority:** P1 - MEDIUM  
**Count:** 20 dead `??` operators

**Pattern:**
```dart
// Before
value ?? fallback  // where value can't be null

// After
value  // just remove ??
```

**Acceptance Criteria:**
- ✅ All dead `??` removed
- ✅ No warnings
- ✅ Code cleaner

---

#### **TASK-S4-009: Fix Duplicate Map Keys** ⏱️ 30min
**Priority:** P1 - HIGH  
**File:** `lib/data/sources/mock/address.dart:739,874`

**Issue:** Duplicate keys in map

**Acceptance Criteria:**
- ✅ No duplicate keys
- ✅ Data integrity maintained

---

**DAY 2 TOTAL:** ~4 hours

---

### 🟢 DAY 3 - UI/UX IMPROVEMENTS (13/04/2026)

#### **TASK-S4-010: Add "Remember Me" Feature** ⏱️ 1h
**Priority:** P1 - HIGH  
**Bug:** Thiếu nút ghi nhớ tài khoản cho email login

**Files:**
- `lib/ui/auth/login_screen.dart`
- `lib/services/secure_storage_service.dart`

**Implementation:**
```dart
// Add checkbox "Ghi nhớ tài khoản"
// Save email/password to secure storage
// Auto-fill on next login
```

**Acceptance Criteria:**
- ✅ Checkbox "Ghi nhớ tài khoản"
- ✅ Save credentials securely
- ✅ Auto-fill on next login
- ✅ Clear on logout

---

#### **TASK-S4-011: Redesign Confirmation Popup** ⏱️ 2h
**Priority:** P1 - MEDIUM  
**Bug:** Popup xác nhận chưa đẹp

**Files:**
- `lib/widgets/dialogs/confirm_dialog.dart`
- `lib/widgets/dialogs/common_dialog.dart`

**Design:**
- Modern, clean design
- Consistent with app theme
- Clear CTA buttons
- Smooth animations

**Acceptance Criteria:**
- ✅ Beautiful popup design
- ✅ Reusable component
- ✅ Used across app
- ✅ Smooth animations

---

#### **TASK-S4-012: Improve Login Screen UI** ⏱️ 2h
**Priority:** P1 - MEDIUM  
**Bug:** Màn hình LoginScreen cần đẹp hơn

**Files:**
- `lib/ui/auth/login_screen.dart`

**Improvements:**
- Modern design
- Better spacing
- Smooth animations
- Clear CTAs
- Social login buttons

**Acceptance Criteria:**
- ✅ Beautiful login screen
- ✅ Responsive design
- ✅ Smooth animations
- ✅ User-friendly

---

#### **TASK-S4-013: UI Consistency Review** ⏱️ 3h
**Priority:** P2 - MEDIUM  
**Bug:** Giao diện các màn chưa đồng bộ

**Screens to review:**
- Home screen
- List screen
- Detail screen
- Profile screen
- Share screen

**Check:**
- Colors consistent
- Spacing consistent
- Typography consistent
- Components reusable

**Acceptance Criteria:**
- ✅ Consistent design system
- ✅ All screens aligned
- ✅ Reusable components
- ✅ Design documentation

---

**DAY 3 TOTAL:** ~8 hours

---

### 🔵 DAY 4 - DEPRECATIONS & DEPENDENCIES (14/04/2026)

#### **TASK-S4-014: Update withOpacity** ⏱️ 1.5h
**Priority:** P2 - MEDIUM  
**Count:** 15 occurrences

**Pattern:**
```dart
// Before
color.withOpacity(0.5)

// After
color.withValues(alpha: 0.5)
```

**Files:**
- `lib/config/themes/theme_data.dart:23`
- `lib/ui/account/account_screen.dart:78,156`
- `lib/ui/address/restaurant_detail_screen.dart:210,303`
- And 10+ more...

**Acceptance Criteria:**
- ✅ All withOpacity updated
- ✅ No deprecation warnings
- ✅ Visual appearance unchanged

---

#### **TASK-S4-015: Update Other Deprecations** ⏱️ 1h
**Priority:** P2 - MEDIUM  
**Count:** 3 APIs

**Updates:**
1. **Geolocator settings** - Use `settings` parameter
2. **Switch activeColor** - Use `activeTrackColor`
3. **WillPopScope** - Use `PopScope`

**Acceptance Criteria:**
- ✅ All deprecations fixed
- ✅ No warnings
- ✅ Functionality unchanged

---

#### **TASK-S4-016: Update Dependencies** ⏱️ 2h
**Priority:** P2 - LOW  
**Count:** 125 packages outdated

**Critical updates:**
- `flutter_riverpod: 2.6.1 → 3.3.1`
- `go_router: 14.6.2 → 17.2.0`
- `firebase_*` packages
- `google_sign_in: 6.3.0 → 7.2.0`

**Method:**
```bash
# Check outdated
flutter pub outdated

# Update carefully
flutter pub upgrade

# Test after each major update
flutter test
```

**Acceptance Criteria:**
- ✅ Critical packages updated
- ✅ No breaking changes
- ✅ All tests pass
- ✅ App runs successfully

---

#### **TASK-S4-017: Final Testing** ⏱️ 2h
**Priority:** P0 - CRITICAL

**Test scenarios:**
1. Login flow (Email, Google, Apple)
2. Map loading & navigation
3. Restaurant list & detail
4. Add place
5. Profile & settings
6. Spin wheel
7. Offline mode

**Acceptance Criteria:**
- ✅ All features work
- ✅ No crashes
- ✅ No errors in console
- ✅ Performance good

---

**DAY 4 TOTAL:** ~6.5 hours

---

## 📊 SPRINT SUMMARY

### Time Estimate:
- **Day 1:** 4.5 hours (Critical fixes)
- **Day 2:** 4 hours (Code cleanup)
- **Day 3:** 8 hours (UI/UX)
- **Day 4:** 6.5 hours (Deprecations & testing)
- **Total:** ~23 hours (~3-4 days)

### Tasks:
- **Total:** 17 tasks
- **P0 (Critical):** 6 tasks
- **P1 (High):** 7 tasks
- **P2 (Medium):** 4 tasks

### Expected Results:
- ✅ 0 critical errors
- ✅ 0 warnings
- ✅ Code quality: 9.0/10
- ✅ All bugs fixed
- ✅ Better UI/UX
- ✅ Updated dependencies

---

## 🎯 SUCCESS CRITERIA

1. **No critical errors** - All P0 bugs fixed
2. **Clean codebase** - No warnings, no dead code
3. **Modern UI** - Beautiful, consistent design
4. **Up-to-date** - Latest dependencies
5. **Well tested** - All features work
6. **Production ready** - Can deploy anytime

---

## 📝 DAILY REPORTS

Em sẽ báo cáo hàng ngày:
- **8:00 AM:** Daily standup (plan for today)
- **5:00 PM:** End of day report (progress, blockers)

---

## 🚀 LET'S GO!

**Ready to start Day 1?** 🐺💪

_Created by: Đệ sói ngáo 🐺🤪_  
_Date: 11/04/2026 - 10:02 AM GMT+7_
