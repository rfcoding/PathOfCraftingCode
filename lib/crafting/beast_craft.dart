import 'package:poe_clicker/crafting/item/magic_item.dart';

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
    BeastMagicRestoreImprint()
  ];
  static List<BeastCraft> getBeastCraftsForItem(Item item){
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
  Item doCraft(Item item){
    List<Mod> prefixes = List.generate(item.prefixes.length, (index) => Mod.copy(item.prefixes[index]));
    List<Mod> suffixes = List.generate(item.suffixes.length, (index) => Mod.copy(item.suffixes[index]));
    Item imprint = MagicItem.fromItem(item, prefixes, suffixes);
    item.imprint = imprint;
    return item;
  }

  bool canDoCraft(Item item){
    return item is MagicItem;
  }
}

class BeastMagicRestoreImprint extends BeastCraft {
  String get displayName => "Restore Imprinted Item";
  String get subheader => "Of the Current Item";
  
  Item doCraft(Item item) {
    return item.imprint;
  }

  bool canDoCraft(Item item){
    return item.imprint != null;
  }
}