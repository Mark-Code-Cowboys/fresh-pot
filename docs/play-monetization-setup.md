# Fresh Pot — Play monetization setup (manual checklist)

Do these in order — the products menu is hidden until Play has
processed a build containing the billing permission. Mirrors the
Course Ledger / Hitch Post checklists.

## 0. Payments profile (account level, one-time)

Already done. Skip.

## 1. Upload the AAB

Internal testing → Create release → `app-release.aab` (see
release-checklist.md for the build). The `in_app_purchase` plugin
embeds `com.android.vending.BILLING`; once Play processes the build,
**Monetize** unlocks.

## 2. One-time product (Monetize → Products → In-app products)

| Product ID | Name | Price |
| --- | --- | --- |
| `freshpot_pro_lifetime` | Fresh Pot Pro — Lifetime | $14.99 |

Id must match `lib/features/monetization/entitlements.dart` exactly.
Purchase option ID: `buy`. Mark **Active**.

Description (≤200 chars, shown in the purchase dialog):

> Fresh Pot Pro, forever: unlimited bags, brew trends, bag-label
> scanning, and export. One purchase, no subscription — your notes
> were never for rent.

## 3. Subscription (Monetize → Products → Subscriptions)

| Product ID | Base plan ID | Billing | Price |
| --- | --- | --- | --- |
| `freshpot_pro_monthly` | `monthly` | Monthly, auto-renewing | $1.49/mo |

Single base plan — cc_core's `premiumPrice()`/`buyPremium()` use the
first (only) plan. Enable the base plan, mark the subscription
**Active**.

Benefits list (shown on the store):
unlimited bags · brew trends · bag-label scan · CSV export & backup.

The in-app sheet presents monthly and lifetime as EQUAL citizens —
keep store pricing consistent with that framing (lifetime ≈ 10 months).

## 4. License testers

Play Console → Settings → License testing: add the test account(s) so
sandbox purchases don't charge. Verify on-device per the 11-step
paywall pass in `release-checklist.md`.

## 5. Data safety form

All "No" (no data collected, no data shared), except:
- "On-device processing only" note for bag-label images
- Purchases: handled by Google Play

Matches `docs/privacy-policy.md` — keep the two in sync. Fresh Pot
makes no network calls of its own (no map tiles here, unlike Hitch
Post) — the policy's "no network calls" wording is load-bearing;
revisit both if that ever changes.

## App Store (later, with the Codemagic iOS lane)

`freshpot_pro_lifetime` as a non-consumable; `freshpot_pro_monthly`
as an auto-renewable subscription in its own group.
