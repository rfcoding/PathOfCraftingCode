import 'package:poe_clicker/crafting/item/magic_item.dart';
import 'package:poe_clicker/crafting/item/rare_item.dart';

import 'item/item.dart';
import 'mod.dart';

class BeastCraftCost {
  String itemId;
  int count;

  BeastCraftCost(this.itemId, this.count);
}

abstract class BeastCraft {
  static List<BeastCraft> allCrafts = [
    BeastMagicImprint(),
    BeastMagicRestoreImprint(),
    BeastAddPrefixRemoveSuffix(),
    BeastAddSuffixRemovePrefix(),
  ];
  static List<BeastCraft> getBeastCraftsForItem(Item item) {
    return allCrafts.where((craft) => craft.canDoCraft(item)).toList(growable: false);
  }

  String get displayName => "Unnamed craft";
  String get subheader => "";
  BeastCraftCost get cost => null;

  Item doCraft(Item item);
  bool canDoCraft(Item item);
}

class BeastMagicImprint extends BeastCraft {
  String get displayName => "Create an Imprint";
  String get subheader => "Of a Magic Item";
  BeastCraftCost get cost => BeastCraftCost("ManBearPig", 1);
  Item doCraft(Item item) {
    List<Mod> prefixes = List.generate(item.prefixes.length, (index) => Mod.copy(item.prefixes[index]));
    List<Mod> suffixes = List.generate(item.suffixes.length, (index) => Mod.copy(item.suffixes[index]));
    Item imprint = MagicItem.fromItem(item, prefixes, suffixes);
    item.imprint = imprint;
    return item;
  }

  bool canDoCraft(Item item) {
    return item is MagicItem;
  }
}

class BeastMagicRestoreImprint extends BeastCraft {
  String get displayName => "Restore Imprinted Item";
  String get subheader => "Of the Current Item";

  Item doCraft(Item item) {
    return item.imprint;
  }

  bool canDoCraft(Item item) {
    return item.imprint != null;
  }
}

class BeastAddPrefixRemoveSuffix extends BeastCraft {
  String get displayName => "Add a Prefix, Remove a Random SuffIx";

  Item doCraft(Item item) {
    item.suffixes.removeAt(item.rng.nextInt(item.suffixes.length));
    item.addPrefix();
    return item;
  }

  bool canDoCraft(Item item) {
    return (item is RareItem) &&
        !item.hasMaxPrefixes() &&
        item.suffixes.isNotEmpty &&
        !item.hasCannotChangePrefixes() &&
        !item.hasCannotChangeSuffixes();
  }
}

class BeastAddSuffixRemovePrefix extends BeastCraft {
  String get displayName => "Add a SuffIx, Remove a Random Prefix";

  Item doCraft(Item item) {
    item.prefixes.removeAt(item.rng.nextInt(item.prefixes.length));
    item.addSuffix();
    return item;
  }

  bool canDoCraft(Item item) {
    return (item is RareItem) &&
        !item.hasMaxSuffixes() &&
        item.prefixes.isNotEmpty &&
        !item.hasCannotChangePrefixes() &&
        !item.hasCannotChangeSuffixes();
  }
}
