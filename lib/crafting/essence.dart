import 'item/item.dart';
import 'mod.dart';

class Essence implements Comparable<Essence>{
  static const Map<String, String> TEMP_FIX_ESSENCE_ITEM_TYPES = {
    "Rune Dagger" : "Dagger",
    "Warstaff" : "Staff"
  };

  int level;
  Map<String, dynamic> mods;
  String name;

  Essence({
    this.level,
    this.mods,
    this.name
  });

  factory Essence.fromJson(Map<String, dynamic> json) {
    return Essence(
      level: json['level'],
      mods: json['mods'],
      name: json['name'],
    );
  }

  String getModForItemClass(String itemClass) {
    return mods[itemClass] as String;
  }

  String getModIdForItem(Item item) {
    String itemClass = item.itemClass;
    if (TEMP_FIX_ESSENCE_ITEM_TYPES.keys.contains(itemClass)) {
      itemClass = TEMP_FIX_ESSENCE_ITEM_TYPES[itemClass];
    }
    return mods[itemClass];
  }

  @override
  int compareTo(Essence other) {
    return other.level - level;
  }
}