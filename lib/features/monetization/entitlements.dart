import 'package:cc_core/cc_core.dart';

// The billing wrapper, entitlement cache, and store types live in
// cc_core; this file keeps Fresh Pot's product catalog and re-exports
// the shared types for app import sites.
export 'package:cc_core/cc_core.dart'
    show
        EntitlementService,
        FakeEntitlementService,
        StoreEntitlementService,
        StoreProducts,
        StoreUnavailableException;

/// Store product ids. Must match the products configured in Play
/// Console (and later App Store Connect) exactly.
abstract final class ProductIds {
  static const proMonthly = 'freshpot_pro_monthly';
  static const proLifetime = 'freshpot_pro_lifetime';
  static const all = [proMonthly, proLifetime];
}

/// Fresh Pot's catalog: one Pro entitlement, sold as a cheap monthly
/// subscription or a lifetime unlock — equal citizens, per the rescue
/// positioning (incumbents lock archives behind subscriptions; we
/// don't). cc_core's `isUnlimited()` is true for either.
const fpStoreProducts = StoreProducts(
  lifetimeUnlock: ProductIds.proLifetime,
  premiumSubscription: ProductIds.proMonthly,
);
