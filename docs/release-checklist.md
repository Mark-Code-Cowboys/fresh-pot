# Fresh Pot — Release checklist

Work top to bottom; nothing ships with an unchecked box above it.

## Code

- [x] `pubspec.yaml` version bumped (`1.0.0+1` for the first release)
- [x] cc_core pinned to a pushed tag (currently `v0.17.0`) —
      `pubspec_overrides.yaml` is git-ignored and must NOT influence the
      release build: `flutter pub get` on a clean checkout resolves
- [x] `flutter analyze` — zero issues
- [x] `flutter test` — all green (55)
- [x] `dart run flutter_launcher_icons` output committed (android/ios)
- [ ] Incumbent sample export received → its headers added to
      `fpCsvFields` guess tiers + fixture test (D-addendum)

## The 11-step paywall pass (both platforms, sandbox/license testers)

Run in order on a fresh install. Same pass on iOS once the Codemagic
lane exists — steps identical, StoreKit sandbox account instead.

1. [ ] Fresh install → onboarding → "Just look around": counter reads
       "0 of 5 free beans used", Trends shows the Pro teaser
2. [ ] Add 5 bags → each add ticks the counter; the 6th add opens the
       paywall instead of the composer
3. [ ] Dismiss ("Maybe later") → no bag added, gate still closed
4. [ ] Delete a bag → still gated (lifetime tally — history isn't a
       recyclable slot)
5. [ ] Bag-label scan as free user → paywall first
6. [ ] CSV import as free user with 4 bags → imports 1 row, reports
       the rest as past the cap (never silently dropped)
7. [ ] Buy monthly (sandbox) → sheet closes itself, counter gone,
       6th composer opens, Trends content live
8. [ ] Kill + relaunch offline → still Pro (entitlement cache)
9. [ ] Cancel the subscription → after sandbox expiry + relaunch,
       gates return; every bag and note still readable and editable
10. [ ] Buy lifetime on a second tester from ITS OWN equal-citizen
        button → same entitlement
11. [ ] Uninstall → reinstall → Restore purchase → Pro returns; then
        restore a backup → journal AND free-tier tally intact

## On-device (Pixel), release build

- [ ] `flutter run --release` cold start < 2s, no red screens
- [ ] Onboarding shows once; kill/relaunch skips it
- [ ] Bag scan on a real bag: scanner opens, "The label says" shows
      the transcription verbatim, confirm fills the composer
- [ ] CSV import: a Sheets export maps and lands; re-import adds 0
- [ ] Brew it again from a bean detail; dial-in card updates when a
      better-rated brew lands
- [ ] Backup → share to Drive → wipe app data → restore → journal,
      photos, and free-tier tally intact
- [ ] DEMO_SEED build only for screenshots — never the uploaded AAB
- [ ] Dark theme spot-check: home, bean detail, composer, paywall,
      trends calendar

## Store

- [ ] Privacy policy live at code-cowboys.com/privacy/freshpot
      (source: `docs/privacy-policy.md`)
- [ ] Listing fields pasted from `docs/play-store-listing.md`
- [ ] Screenshots: 6 per the listing doc (#3 bag scan needs a real
      bag on-device)
- [ ] Feature graphic + 512 store icon exported
- [ ] Products created per `docs/play-monetization-setup.md`, Active
- [ ] Data safety form matches the privacy policy

## Build & upload

- [ ] `android/key.properties` + keystore in place (never committed)
- [ ] `flutter build appbundle --release`
- [ ] Internal testing release; license testers run the 11-step pass
- [ ] Promote to closed → production when the boxes above are checked

## Post-launch

- [ ] Tag the app repo `v1.0.0`
- [ ] Note any cc_core friction found during release in
      course-ledger's `docs/cc-core-gaps.md` (the fleet ledger)
- [ ] Backlog: incumbent mapper (awaiting sample), brews CSV export if
      asked, inventory of open bags by weight remaining
