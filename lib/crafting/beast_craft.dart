import 'package:poe_clicker/crafting/item/magic_item.dart';
import 'package:poe_clicker/crafting/item/rare_item.dart';
import 'package:poe_clicker/repository/mod_repo.dart';

import 'item/item.dart';
import 'mod.dart';

class BeastCraftCost {
  String name;
  int count;

  BeastCraftCost(this.name, this.count);
}

abstract class BeastCraft {
  static List<BeastCraft> allCrafts = [
    BeastRestoreAndAddMagicImprint(),
    BeastMagicImprint(),
    BeastMagicRestoreImprint(),
    BeastAddPrefixRemoveSuffix(),
    BeastAddSuffixRemovePrefix(),
    BeastAddMod("GrantsBirdAspectCrafted", "Add Aspect of the Avian skill", BeastCraftCost("Saqawal, First of the Sky", 1)),
    BeastAddMod("GrantsCatAspectCrafted", "Add Aspect of the Cat skill", BeastCraftCost("Farrul, First of the Plains", 1)),
    BeastAddMod("GrantsCrabAspectCrafted", "Add Aspect of the Crab skill", BeastCraftCost("Craiceann, First of the Deep", 1)),
    BeastAddMod("GrantsSpiderAspectCrafted", "Add Aspect of the Spider skill", BeastCraftCost("Fenumus, First of the Night", 1)),
  ];
  static List<BeastCraft> getBeastCraftsForItem(Item item) {
    return allCrafts.where((craft) => craft.canDoCraft(item)).toList(growable: false);
  }

  String displayName;
  String subheader;
  BeastCraftCost cost;

  BeastCraft({this.displayName, this.subheader, this.cost});

  Item doCraft(Item item);
  bool canDoCraft(Item item);
}

class BeastMagicImprint extends BeastCraft {  
  BeastMagicImprint() : super(displayName: "Create an Imprint", subheader: "Of a Magic Item", cost: BeastCraftCost("Craicic Chimeral", 1));

  Item doCraft(Item item) {
    item.imprint = null;
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

class BeastRestoreAndAddMagicImprint extends BeastCraft {  
  BeastRestoreAndAddMagicImprint() : super(displayName: "Restore and create a new Imprint", subheader: "Of a Magic Item", cost: BeastCraftCost("Craicic Chimeral", 1));

  Item doCraft(Item item) {
    item = item.imprint;
    List<Mod> prefixes = List.generate(item.prefixes.length, (index) => Mod.copy(item.prefixes[index]));
    List<Mod> suffixes = List.generate(item.suffixes.length, (index) => Mod.copy(item.suffixes[index]));
    Item imprint = MagicItem.fromItem(item, prefixes, suffixes);
    item.imprint = imprint;
    return item;
  }

  bool canDoCraft(Item item) {
    return item.imprint != null;
  }
}


class BeastMagicRestoreImprint extends BeastCraft {

  BeastMagicRestoreImprint() : super(displayName: "Restore Imprinted Item");

  Item doCraft(Item item) {
    item = item.imprint;
    List<Mod> prefixes = List.generate(item.prefixes.length, (index) => Mod.copy(item.prefixes[index]));
    List<Mod> suffixes = List.generate(item.suffixes.length, (index) => Mod.copy(item.suffixes[index]));
    return MagicItem.fromItem(item, prefixes, suffixes);
  }

  bool canDoCraft(Item item) {
    return item.imprint != null;
  }
}

class BeastAddPrefixRemoveSuffix extends BeastCraft {
  BeastAddPrefixRemoveSuffix() : super(displayName: "Add a Prefix, Remove a Random SuffIx", cost: BeastCraftCost("Farric Wolf Alpha", 1));

  Item doCraft(Item item) {
    item.addPrefix();
    item.suffixes.removeAt(item.rng.nextInt(item.suffixes.length));
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
  BeastAddSuffixRemovePrefix() : super(displayName: "Add a SuffIx, Remove a Random Prefix", cost: BeastCraftCost("Farric Lynx Alpha", 1));

  Item doCraft(Item item) {
    item.addSuffix();
    item.prefixes.removeAt(item.rng.nextInt(item.prefixes.length));
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

class BeastAddMod extends BeastCraft {
  final String _modKey;

  BeastAddMod(this._modKey, String displayName, BeastCraftCost cost) : super(displayName: displayName, cost: cost);

  Item doCraft(Item item){
    Mod mod = ModRepository.instance.getModById(_modKey);
    item.addMod(mod);
    return item;
  }

  bool canDoCraft(Item item){
    Mod mod = ModRepository.instance.getModById(_modKey);
    return item.canAddMod(mod);
  }
}
