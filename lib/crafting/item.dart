import 'dart:math';
import 'mod.dart';
import '../repository/mod_repo.dart';
import '../repository/translation_repo.dart';

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
      "bow_elder",
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

  List<String> getStatStrings() {
    return mods.map((mod) => mod.getStatStrings()).expand((string) => string).toList();
    //final List<Stat> stats = mods.map((mod) => mod.stats).expand((stat) => stat).toList();
    //return TranslationRepository.instance.getTranslationFromStats(stats);
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

  bool alreadyHasModGroup(Mod mod) {
    for (Mod ownMod in mods) {
      if (ownMod.group == mod.group) {
        return true;
      }
    }
    return false;
  }

}