import 'mod.dart';
import '../repository/mod_repo.dart';

class Item {
  String name;
  List<Mod> mods;
  List<String> tags;

  Item(String name) {
    this.name = name;
    mods = new List();
    tags = [
      "bow",
      "ranged",
      "two_hand_weapon",
      "twohand",
      "weapon",
    ];
    reroll();
  }

  List<Mod> getMods() {
    return mods;
  }

  @override
  String toString() {
    return name;
  }

  void reroll() {
    mods.clear();
    Mod prefix = ModRepository.instance.getPrefix(this);
    Mod suffix = ModRepository.instance.getSuffix(this);
    print("Prefix: $prefix");
    print("Suffix: $suffix");
    mods.add(prefix);
    mods.add(suffix);
  }

}