# Fresh Pot — Google Play Store Listing

Copy-paste source for the Play Console listing. Character limits noted
per field; counts verified at draft time (2026-09-05).

---

## App name (max 30 chars)

> Fresh Pot: Coffee Journal

(25 chars. Alternatives: "Fresh Pot" alone (9); "Fresh Pot — Brew Log
& Notes" (27).)

## Short description (max 80 chars)

> Your tasting notes belong to you. A coffee journal with no account, no cloud.

(77 chars — the ownership pitch IS the differentiation.)

## Full description (max 4000 chars)

> **Your tasting notes belong to you.**
>
> Fresh Pot is the coffee journal you keep: every bag, every brew,
> every note — on your phone, in your words, and never held for
> ransom. No account. No cloud. No subscription needed to read your
> own archive, ever.
>
> **The bean journal**
> • Every bag with roaster, origin, process, roast date, and price
> • The bag on your counter floats to the top
> • Star ratings and tasting notes in your own words, with bag photos
>
> **The brew log**
> • Method-aware logging: espresso weighs the yield, pour-over the
>   water — ratio computed for you
> • Grind settings with your grinder next to them, so "17" means
>   something
> • The dial-in card: your best-rated brew's numbers pinned to the
>   bag, ready to read at the bench
> • Brew it again: one tap re-loads yesterday's cup, you rate today's
>
> **Switching? Bring your notes.**
> The CSV importer maps your existing spreadsheet or app export —
> re-import safe, nothing duplicated. And the bag-label scanner reads
> roaster, coffee, origin, and roast date straight off the bag; you
> confirm every value.
>
> **Trends (Pro)**
> Ratings by roaster and by origin. The brewing calendar. Bag prices
> over time. How your cups actually get made. Export your notes as
> CSV or a full backup — the archive the incumbents wouldn't give
> back.
>
> **Private by construction**
> No account. No cloud. No analytics. Label reading happens on-device.
> Your first 5 bags are free forever; Fresh Pot Pro is a cheap
> monthly or a one-time lifetime unlock — equal citizens, pick the
> one that suits you.
>
> The journal is yours. We never see it.

## Keywords (App Store keyword field; woven into Play description above)

coffee journal, brew log, espresso diary, pour over notes, coffee
tasting notes, coffee bag tracker, dial in, brew notes

## Category

Food & Drink (secondary consideration: Lifestyle)

## Privacy policy URL

https://code-cowboys.com/privacy/freshpot
(Source text: `docs/privacy-policy.md` — publish before submission.)

---

## Screenshots (phone, 1080×2400, DEMO_SEED data)

Run `flutter run --dart-define=DEMO_SEED=true`; the seed plants 8 bags
/ 60 brews with notes written for these shots. Order per the prompt:

1. **The dial-in card** — Guji Highlands bean detail: chips, notes,
   "The dial-in" card (V60 · 15g · 1:16.7 · grind 17 · 205°F · 2:45)
   over the brew history. Caption: "Your best cup's numbers, pinned."
2. **The brew composer** — espresso mode (Dose/Yield) with grinder
   picker. Caption: "Espresso weighs the yield. Pour-over the water."
3. **The bag scan** — the "The label says" confirm dialog over the
   composer (needs a REAL bag on-device; demo build is already Pro).
   Caption: "Shoot the bag. Confirm. Done."
4. **The trends heatmap** — Trends tab scrolled to the brewing
   calendar (September 2026 shows the daily Guji arc). Caption: "Your
   brewing year, at a glance."
5. **The import** — cc_core mapping screen mid-import of a sample CSV.
   Caption: "Switching? Your notes come with you."
6. **The beans list** — home with 8 bags, two on the counter.
   Caption: "Every bag you've loved. And the ones you haven't."

Shot 6 note: demo fakes Pro so no counter shows — that's the intended
clean shot; the free-tier framing lives in the paywall/listing copy.

Feature graphic (1024×500) and 512px store icon: derive from
`assets/icon/` art — roast brown, the steaming-pot mark, wordmark
right. TODO alongside first upload.
