# 🚀 SPRINT 5 - NEW FEATURES PLAN

**Sprint:** Sprint 5 - Smart Features & Social Engagement  
**Duration:** 2 weeks (14/04/2026 - 25/04/2026)  
**Focus:** Add 3 key features to boost user engagement  
**QA Engineer & PM:** Đệ sói ngáo 🐺🤪

---

## 🎯 SPRINT GOALS

Add 3 critical features to increase user engagement and retention:

1. **Smart Recommendations** 🤖 - AI-powered food suggestions
2. **Social Sharing** 📱 - Share to social media platforms
3. **Gamification** 🎮 - Badges, points, and achievements

**Success Criteria:**
- All 3 features implemented and tested
- User engagement increased by 30%
- Code quality maintained at 9.0/10
- No new critical bugs introduced

---

## 📋 FEATURE 1: SMART RECOMMENDATIONS 🤖

**Priority:** P0 - CRITICAL  
**Estimate:** 3 days (24 hours)  
**Value:** High retention, personalized experience

### User Stories:

**US-001:** As a user, I want to see personalized restaurant recommendations based on my history  
**US-002:** As a user, I want to see "Trending near me" section  
**US-003:** As a user, I want to see what my friends liked  

### Technical Tasks:

#### TASK-S5-001: Create Recommendation Engine
- **Priority:** P0 - CRITICAL
- **Estimate:** 8h
- **Description:**
  - Create `lib/services/recommendation_service.dart`
  - Implement collaborative filtering algorithm
  - Track user preferences (cuisine type, price range, rating)
  - Calculate similarity scores
  - Generate top 10 recommendations
- **Acceptance Criteria:**
  - Service returns personalized recommendations
  - Algorithm considers user history
  - Performance < 500ms

#### TASK-S5-002: Add "For You" Section to Home Screen
- **Priority:** P0 - CRITICAL
- **Estimate:** 6h
- **Description:**
  - Add "For You" carousel to home screen
  - Show personalized restaurant cards
  - Add "Why recommended" label
  - Implement pull-to-refresh
- **Files to modify:**
  - `lib/ui/home/home_screen.dart`
  - `lib/ui/home/widgets/for_you_section.dart` (new)
- **Acceptance Criteria:**
  - Section appears on home screen
  - Shows 10+ recommendations
  - Smooth scrolling
  - Beautiful UI

#### TASK-S5-003: Add "Trending Near Me" Feature
- **Priority:** P1 - HIGH
- **Estimate:** 6h
- **Description:**
  - Track restaurant views/check-ins
  - Calculate trending score (views in last 24h)
  - Show trending badge on cards
  - Add "Trending" filter to map
- **Files to modify:**
  - `lib/services/analytics_service.dart` (new)
  - `lib/ui/map/food_map_screen.dart`
  - `lib/widgets/restaurant_card.dart`
- **Acceptance Criteria:**
  - Trending badge shows correctly
  - Filter works on map
  - Updates every hour

#### TASK-S5-004: Add "Friends Also Liked" Section
- **Priority:** P1 - HIGH
- **Estimate:** 4h
- **Description:**
  - Query friends' favorites
  - Show "3 friends liked this" label
  - Add friends' avatars
  - Link to friends' profiles
- **Files to modify:**
  - `lib/ui/address/restaurant_detail_screen.dart`
  - `lib/widgets/friends_liked_section.dart` (new)
- **Acceptance Criteria:**
  - Shows friends who liked
  - Avatars display correctly
  - Tappable to view profiles

---

## 📋 FEATURE 2: SOCIAL SHARING 📱

**Priority:** P0 - CRITICAL  
**Estimate:** 2 days (16 hours)  
**Value:** Viral growth, user acquisition

### User Stories:

**US-004:** As a user, I want to share restaurants to Facebook/Instagram/Zalo  
**US-005:** As a user, I want to share my reviews with friends  
**US-006:** As a user, I want to generate beautiful share cards  

### Technical Tasks:

#### TASK-S5-005: Integrate Share Package
- **Priority:** P0 - CRITICAL
- **Estimate:** 2h
- **Description:**
  - Add `share_plus` package
  - Add `flutter_sharing_intent` package
  - Configure deep links
  - Test on iOS/Android
- **Files to modify:**
  - `pubspec.yaml`
  - `android/app/src/main/AndroidManifest.xml`
  - `ios/Runner/Info.plist`
- **Acceptance Criteria:**
  - Packages installed
  - Deep links working
  - Share sheet opens

#### TASK-S5-006: Create Share Card Generator
- **Priority:** P0 - CRITICAL
- **Estimate:** 6h
- **Description:**
  - Create beautiful share card template
  - Include restaurant photo, name, rating
  - Add QR code for deep link
  - Generate image from widget
  - Support multiple templates
- **Files to create:**
  - `lib/widgets/share/share_card.dart`
  - `lib/services/share_card_service.dart`
- **Acceptance Criteria:**
  - Card looks professional
  - Image generated < 2s
  - Multiple templates available

#### TASK-S5-007: Add Share Buttons to Restaurant Detail
- **Priority:** P0 - CRITICAL
- **Estimate:** 4h
- **Description:**
  - Add share button to app bar
  - Show share options (Facebook, Instagram, Zalo, Copy link)
  - Track share events
  - Show success message
- **Files to modify:**
  - `lib/ui/address/restaurant_detail_screen.dart`
  - `lib/widgets/dialogs/share_dialog.dart` (new)
- **Acceptance Criteria:**
  - Share button visible
  - All platforms work
  - Analytics tracked

#### TASK-S5-008: Add Share to Review Feature
- **Priority:** P1 - HIGH
- **Estimate:** 4h
- **Description:**
  - Add share button to reviews
  - Generate review card with user avatar
  - Include restaurant info
  - Share to social media
- **Files to modify:**
  - `lib/ui/address/widgets/review_card.dart`
  - `lib/widgets/share/review_share_card.dart` (new)
- **Acceptance Criteria:**
  - Share button on reviews
  - Card includes review text
  - Beautiful design

---

## 📋 FEATURE 3: GAMIFICATION 🎮

**Priority:** P1 - HIGH  
**Estimate:** 3 days (24 hours)  
**Value:** High engagement, retention

### User Stories:

**US-007:** As a user, I want to earn badges for achievements  
**US-008:** As a user, I want to earn points for activities  
**US-009:** As a user, I want to see my progress and level  
**US-010:** As a user, I want to compete with friends on leaderboard  

### Technical Tasks:

#### TASK-S5-009: Create Gamification System
- **Priority:** P1 - HIGH
- **Estimate:** 8h
- **Description:**
  - Create points system (review = 10pts, check-in = 5pts, etc.)
  - Create badge definitions (Foodie Explorer, Review Master, etc.)
  - Create level system (1-50 levels)
  - Track user progress
  - Store in Firestore
- **Files to create:**
  - `lib/services/gamification_service.dart`
  - `lib/models/badge.dart`
  - `lib/models/user_progress.dart`
- **Acceptance Criteria:**
  - Points awarded correctly
  - Badges unlock at milestones
  - Levels calculated properly

#### TASK-S5-010: Create Badges UI
- **Priority:** P1 - HIGH
- **Estimate:** 6h
- **Description:**
  - Design badge icons (10+ badges)
  - Create badge collection screen
  - Show locked/unlocked states
  - Add badge details popup
  - Show progress bars
- **Files to create:**
  - `lib/ui/badges/badges_screen.dart`
  - `lib/widgets/badge_card.dart`
  - `assets/badges/*.svg` (badge icons)
- **Acceptance Criteria:**
  - Beautiful badge designs
  - Smooth animations
  - Progress visible

#### TASK-S5-011: Add Points & Level to Profile
- **Priority:** P1 - HIGH
- **Estimate:** 4h
- **Description:**
  - Show points and level on profile
  - Add progress bar to next level
  - Show recent achievements
  - Add "View all badges" button
- **Files to modify:**
  - `lib/ui/account/account_screen.dart`
  - `lib/widgets/profile/level_card.dart` (new)
- **Acceptance Criteria:**
  - Level displays correctly
  - Progress bar animates
  - Badges visible

#### TASK-S5-012: Create Leaderboard
- **Priority:** P2 - MEDIUM
- **Estimate:** 6h
- **Description:**
  - Create leaderboard screen
  - Show top 100 users by points
  - Show friends leaderboard
  - Add filters (This week, This month, All time)
  - Show user's rank
- **Files to create:**
  - `lib/ui/leaderboard/leaderboard_screen.dart`
  - `lib/widgets/leaderboard/user_rank_card.dart`
- **Acceptance Criteria:**
  - Leaderboard loads fast
  - Real-time updates
  - User can find themselves

---

## 📊 SPRINT BREAKDOWN

### Week 1 (14/04 - 18/04):
- **Day 1-2:** Smart Recommendations (TASK-S5-001 to S5-004)
- **Day 3-4:** Social Sharing (TASK-S5-005 to S5-008)
- **Day 5:** Testing & Bug fixes

### Week 2 (21/04 - 25/04):
- **Day 1-3:** Gamification (TASK-S5-009 to S5-012)
- **Day 4:** Integration testing
- **Day 5:** Final testing & deployment

---

## 🎯 SUCCESS METRICS

### Engagement Metrics:
- **Daily Active Users:** +30%
- **Session Duration:** +50%
- **Shares per user:** 2+ per week
- **Reviews per user:** +40%

### Technical Metrics:
- **Code Quality:** Maintain 9.0/10
- **Test Coverage:** 80%+
- **Performance:** No regression
- **Crash Rate:** < 0.1%

---

## 📦 DEPENDENCIES

### New Packages:
```yaml
dependencies:
  share_plus: ^7.2.1
  flutter_sharing_intent: ^1.1.0
  screenshot: ^2.1.0
  qr_flutter: ^4.1.0
```

### Backend Changes:
- Add analytics tracking endpoints
- Add gamification endpoints
- Add leaderboard queries
- Add share tracking

---

## 🚨 RISKS & MITIGATION

### Risk 1: Recommendation Algorithm Performance
- **Mitigation:** Cache recommendations, update hourly
- **Fallback:** Show popular restaurants if algorithm fails

### Risk 2: Share Feature Platform Issues
- **Mitigation:** Test on multiple devices
- **Fallback:** Always provide "Copy link" option

### Risk 3: Gamification Complexity
- **Mitigation:** Start simple, iterate based on feedback
- **Fallback:** Launch with basic points system first

---

## ✅ DEFINITION OF DONE

- [ ] All tasks completed and tested
- [ ] Code reviewed and approved
- [ ] Unit tests written (80% coverage)
- [ ] Integration tests passed
- [ ] UI/UX approved by design team
- [ ] Performance benchmarks met
- [ ] Documentation updated
- [ ] Deployed to staging
- [ ] User acceptance testing passed
- [ ] Deployed to production

---

## 📝 NOTES

- Focus on mobile-first design
- Ensure offline support where possible
- Keep animations smooth (60fps)
- Follow Material Design 3 guidelines
- Maintain code quality at 9.0/10

---

**Created:** 11/04/2026 - 5:13 PM GMT+7  
**Status:** 📋 READY TO START

**Đệ sói ngáo 🐺🤪**  
_QA Engineer & Project Manager_
