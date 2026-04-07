# 🔍 CODE QUALITY AUDIT REPORT

**Project:** FoodTour App
**Sprint:** Sprint 3 - Day 1
**Task:** TASK-S3-001
**Date:** 07/04/2026, 08:44 GMT+7
**Auditor:** Dev Hương Ngáo 🔍🤪

---

## 📊 EXECUTIVE SUMMARY

**Total Issues:** 102 issues found
**Severity Breakdown:**
- 🔴 **Errors:** 5 (Critical)
- ⚠️ **Warnings:** 79 (Medium)
- ℹ️ **Info:** 18 (Low - Deprecations)

**Code Quality Rating:** 🟡 MEDIUM (needs improvement)

**Analysis Time:** 3.1 seconds

---

## 🔴 CRITICAL ERRORS (5)

### ERROR 1: Missing secure_storage_service.dart
**File:** `lib/core/api/interceptor.dart:4:8`
**Issue:** `Target of URI doesn't exist: '../services/secure_storage_service.dart'`
**Impact:** HIGH - API interceptor cannot access secure storage
**Lines affected:** 35, 44

**Root cause:** File path incorrect or file missing

**Fix required:**
```dart
// Check if file exists at correct path
// Or update import path
```

---

### ERROR 2: Undefined secureStorage (2 occurrences)
**File:** `lib/core/api/interceptor.dart`
**Lines:** 35, 44
**Issue:** `Undefined name 'secureStorage'`
**Impact:** HIGH - Cannot read/write tokens

**Fix required:**
```dart
// Ensure secureStorage is properly initialized
// Or inject via dependency injection
```

---

### ERROR 3: Undefined method 'import'
**File:** `lib/services/secure_storage_service.dart:127:26`
**Issue:** `The method 'import' isn't defined for the type 'SecureStorageService'`
**Impact:** MEDIUM - Import functionality broken

**Fix required:**
```dart
// Remove or implement import() method
```

---

### ERROR 4: Missing accordion package
**File:** `lib/widgets/package/package.dart:1:8`
**Issue:** `Target of URI doesn't exist: 'accordion/accordion.dart'`
**Impact:** LOW - Already deleted in Sprint 2

**Fix required:**
```dart
// Remove this import line
// export 'accordion/accordion.dart'; // DELETE THIS
```

---

## ⚠️ WARNINGS (79)

### Category 1: Unused Imports (30 issues)

**High Priority:**
- `lib/core/di/injection.dart:9` - Unused: `secure_storage_service.dart`
- `lib/ui/auth/login_screen.dart:2` - Unused: `email_auth_screen.dart`
- `lib/ui/auth/login_screen.dart:3` - Unnecessary: `cupertino.dart`

**Medium Priority:**
- `lib/popup/HeartShape.dart` - 3 unused imports (dart:convert, dart:math, lottie)
- `lib/ui/account/widgets/edit_profile_screen.dart` - 3 unused imports
- `lib/ui/add_place/add_place_screen.dart` - 3 unused imports
- `lib/ui/address/restaurant_detail_screen.dart` - 2 unused imports
- And 15+ more files...

**Impact:** LOW - Code bloat, slower compilation
**Effort:** LOW - Auto-fix available

---

### Category 2: Unused Fields/Variables (15 issues)

**Examples:**
- `lib/core/route.dart:40` - `_isLoggedIn` field unused
- `lib/services/fire_store.dart:9,10` - `_softDocId`, `_forceDocId` unused
- `lib/ui/add_place/add_place_screen.dart:39` - `_accentColor` unused
- `lib/ui/map/food_map_screen.dart:33` - `_navigatingTo` unused
- `lib/utils/helpers/check_token.dart:13` - `_password` unused
- And 10+ more...

**Impact:** LOW - Memory waste (minimal)
**Effort:** LOW - Remove unused code

---

### Category 3: Dead Null-Aware Expressions (20 issues)

**Pattern:** `value ?? fallback` where value can't be null

**Examples:**
- `lib/ui/account/widgets/history_screen.dart:131:46`
- `lib/ui/address/restaurant_detail_screen.dart:163:56`
- `lib/ui/home/home_screen.dart:323:71`
- `lib/ui/list_address/restaurant_list_screen.dart:141:34`
- And 16+ more...

**Impact:** LOW - Unnecessary code
**Effort:** LOW - Remove `??` operator

---

### Category 4: Unnecessary Non-Null Assertions (5 issues)

**Pattern:** `value!` where value can't be null

**Examples:**
- `lib/ui/address/restaurant_detail_screen.dart:247:56`
- `lib/ui/home/widget/restaurant_card.dart:45:41`
- `lib/ui/list_address/restaurant_list_screen.dart:242:45`

**Impact:** LOW - Unnecessary code
**Effort:** LOW - Remove `!` operator

---

### Category 5: Other Warnings (9 issues)

**Duplicate map keys:**
- `lib/data/sources/mock/address.dart:739,874` - Duplicate keys in map

**Unused elements:**
- `lib/core/route.dart:149` - `_cupertinoPage` not referenced
- `lib/ui/map/food_map_screen.dart:80` - `_translateManeuver` not referenced
- `lib/ui/spinWheel/providers/notifier.dart:57` - `_showPopup` not referenced

**Invalid override:**
- `lib/ui/spinWheel/providers/notifier.dart:76` - Override on non-overriding member

**Invalid return type:**
- `lib/services/location_service.dart:34` - Null can't be returned in onError

---

## ℹ️ INFO - DEPRECATIONS (18)

### Deprecated: withOpacity (15 occurrences)

**Issue:** `withOpacity` is deprecated, use `.withValues()` instead

**Files affected:**
- `lib/config/themes/theme_data.dart:23`
- `lib/ui/account/account_screen.dart:78,156`
- `lib/ui/account/widgets/edit_profile_screen.dart:115`
- `lib/ui/address/restaurant_detail_screen.dart:210,303`
- `lib/ui/home/home_screen.dart:168,169`
- `lib/ui/map/food_map_screen.dart:225`
- `lib/widgets/base/btn.dart:63,73,81`
- `lib/widgets/shared/back_btn.dart:23`
- `lib/widgets/shared/loading_full.dart:10,17`
- `lib/widgets/shared/loading_overlay.dart:20`

**Impact:** LOW - Still works but deprecated
**Effort:** MEDIUM - Need to update all occurrences

**Fix pattern:**
```dart
// Old
color.withOpacity(0.5)

// New
color.withValues(alpha: 0.5)
```

---

### Other Deprecations (3)

**1. Geolocator settings:**
- `lib/services/location_service.dart:32,33`
- Use `settings` parameter instead

**2. Switch activeColor:**
- `lib/widgets/base/switch.dart:33`
- Use `activeTrackColor` instead

**3. WillPopScope:**
- `lib/widgets/helpers/showmanager.dart:140`
- Use `PopScope` instead

**4. Form field value:**
- `lib/ui/add_place/widget/category_dropdown.dart:43`
- Use `initialValue` instead

**5. URL launcher:**
- `lib/ui/favorite_address/providers/notifier.dart:69,70`
- Use `canLaunchUrl` and `launchUrl` instead

---

## 📈 PRIORITY MATRIX

### 🔴 P0 - FIX IMMEDIATELY (5 errors)
1. Fix secure_storage_service.dart import
2. Fix secureStorage undefined
3. Fix import() method
4. Remove accordion import
5. Fix location service return type

**Estimated time:** 1-2 hours

---

### 🟡 P1 - FIX THIS SPRINT (High-impact warnings)
1. Remove all unused imports (30 files)
2. Remove unused fields/variables (15 places)
3. Fix duplicate map keys (2 places)
4. Fix invalid override (1 place)

**Estimated time:** 2-3 hours

---

### 🟢 P2 - FIX LATER (Low-impact)
1. Remove dead null-aware expressions (20 places)
2. Remove unnecessary non-null assertions (5 places)
3. Update deprecated APIs (18 places)

**Estimated time:** 2-3 hours

---

## 🎯 RECOMMENDATIONS

### Immediate Actions (Today)

**1. Fix Critical Errors (P0)**
- Investigate secure_storage_service.dart path
- Fix interceptor.dart imports
- Remove accordion import from package.dart

**2. Clean Up Imports (P1)**
- Run `dart fix --apply` to auto-remove unused imports
- Manually review and remove unnecessary imports

**3. Remove Dead Code (P1)**
- Remove unused fields and variables
- Remove unused methods

---

### Short-term Actions (This Sprint)

**1. Fix Deprecations**
- Update `withOpacity` to `withValues` (15 places)
- Update other deprecated APIs (3 places)

**2. Improve Null Safety**
- Remove dead null-aware expressions
- Remove unnecessary non-null assertions

**3. Code Review**
- Review duplicate map keys
- Review invalid overrides

---

### Long-term Actions (Future Sprints)

**1. Add Linting Rules**
- Enable stricter lint rules
- Add custom lint rules
- Enforce in CI/CD

**2. Code Quality Tools**
- Add SonarQube or similar
- Add code coverage tracking
- Add complexity metrics

**3. Regular Audits**
- Monthly code quality audits
- Quarterly dependency audits
- Regular security audits

---

## 📊 METRICS

**Code Quality Score:** 6.5/10

**Breakdown:**
- Errors: -2.0 (5 errors)
- Warnings: -1.0 (79 warnings)
- Deprecations: -0.5 (18 deprecations)

**Target Score:** 9.0/10 (after Sprint 3)

**Improvement Needed:** +2.5 points

---

## ✅ NEXT STEPS

**TASK-S3-002: Fix Critical Errors**
- Fix secure_storage_service.dart
- Fix interceptor.dart
- Remove accordion import
- Test compilation

**TASK-S3-003: Clean Up Code**
- Remove unused imports
- Remove unused code
- Fix warnings

**TASK-S3-004: Update Deprecations**
- Update withOpacity
- Update other deprecated APIs

---

**Audit completed! Ready for fixes! 🔧**

_Audited by: Dev Hương Ngáo 🔍🤪_
_Time taken: ~30 minutes_
_Status: ✅ COMPLETE_
