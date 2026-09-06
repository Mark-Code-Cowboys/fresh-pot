import '../../data/database/app_database.dart';

extension RoastProcessLabel on RoastProcess {
  String get label => switch (this) {
        RoastProcess.washed => 'Washed',
        RoastProcess.natural => 'Natural',
        RoastProcess.honey => 'Honey',
        RoastProcess.anaerobic => 'Anaerobic',
        RoastProcess.other => 'Other',
      };
}

extension RoastLevelLabel on RoastLevel {
  String get label => switch (this) {
        RoastLevel.light => 'Light',
        RoastLevel.medLight => 'Med-light',
        RoastLevel.medium => 'Medium',
        RoastLevel.medDark => 'Med-dark',
        RoastLevel.dark => 'Dark',
      };
}

extension BrewMethodLabel on BrewMethod {
  String get label => switch (this) {
        BrewMethod.v60 => 'V60',
        BrewMethod.chemex => 'Chemex',
        BrewMethod.aeropress => 'AeroPress',
        BrewMethod.espresso => 'Espresso',
        BrewMethod.mokaPot => 'Moka pot',
        BrewMethod.frenchPress => 'French press',
        BrewMethod.drip => 'Drip',
        BrewMethod.coldBrew => 'Cold brew',
        BrewMethod.siphon => 'Siphon',
        BrewMethod.other => 'Other',
      };
}

extension GearKindLabel on GearKind {
  String get label => switch (this) {
        GearKind.grinder => 'Grinder',
        GearKind.brewer => 'Brewer',
        GearKind.machine => 'Machine',
        GearKind.kettle => 'Kettle',
        GearKind.scale => 'Scale',
        GearKind.other => 'Other',
      };
}

/// The bag's process for display — the user's own word when `other`.
String beanProcessLabel(Bean b) => b.process == RoastProcess.other
    ? (b.processLabel ?? RoastProcess.other.label)
    : b.process!.label;

/// The brew's method for display — the user's own word when `other`.
String brewMethodLabel(Brew b) => b.method == BrewMethod.other
    ? (b.methodLabel ?? BrewMethod.other.label)
    : b.method.label;

/// The gear's kind for display — the user's own word when `other`.
String gearKindLabel(GearData g) => g.kind == GearKind.other
    ? (g.kindLabel ?? GearKind.other.label)
    : g.kind.label;

/// Espresso weighs what comes out; everything else what goes in.
bool usesYield(BrewMethod m) => m == BrewMethod.espresso;
