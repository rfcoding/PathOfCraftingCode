import 'dart:math';
import 'mod.dart';
import '../repository/mod_repo.dart';

class Item {
  String name;
  List<Mod> mods;
  List<String> tags;
  Random rng = new Random();

  Item(String name) {
    this.name = name;
    mods = new List();
    tags = [
      "bow",
      "ranged",
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
    int nPrefixes = rng.nextInt(3) + 1;
    int nSuffixes = max((rng.nextInt(3) + 1), 4 - nPrefixes);
    print("Prefixes: $nPrefixes, Suffixes: $nSuffixes");
    for (int i = 0; i < nPrefixes; i++) {
      Mod prefix = ModRepository.instance.getPrefix(this);
      print("Prefix: ${prefix.debugString()}");
      mods.add(prefix);
    }

    for (int i = 0; i < nSuffixes; i++) {
      Mod suffix = ModRepository.instance.getSuffix(this);
      print("Suffix: ${suffix.debugString()}");
      mods.add(suffix);
    }

  }

}