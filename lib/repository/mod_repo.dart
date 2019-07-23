import 'dart:async' show Future;
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:poe_clicker/crafting/item.dart';
import '../crafting/mod.dart';

class ModRepository {
  ModRepository._privateConstructor();

  static final ModRepository instance = ModRepository._privateConstructor();

  var rng = new Random();

  Map<String, List<Mod>> _prefixModMap;
  Map<String, List<Mod>> _suffixModMap;
  Map<String, Mod> _allModsMap;

  bool _initializing;
  bool _initialized;

  Future<bool> initialize() async {
    _initializing = true;
    _initialized = false;
    _prefixModMap = Map();
    _suffixModMap = Map();
    _allModsMap = Map();

    bool success = await loadModsJSONFromLocalStorage();
    _initializing = false;
    _initialized = success;
    print("Prefix Mods ${_prefixModMap.keys.toString()}");
    print("Number of prefix tags: ${_prefixModMap.keys.length}");
    print("Suffix Mods ${_suffixModMap.keys.toString()}");
    print("Number of suffix tags: ${_suffixModMap.keys.length}");

    print("Number of Amulet prefix mods: ${_prefixModMap['amulet'].length}");
    print("Number of Amulet suffix mods: ${_suffixModMap['amulet'].length}");
    return success;
  }

  Future<bool> loadModsJSONFromLocalStorage() async {
    var data = await rootBundle.loadString('data_repo/mods.json');
    Map<String, dynamic> jsonMap = json.decode(data);
    jsonMap.forEach((key, data) {
      Mod mod = Mod.fromJson(key, data);
      _allModsMap[mod.id] = mod;
      mod.spawnWeights.forEach((spawnWeight) {
        Map<String, List<Mod>> modMap;

        if ("prefix" == mod.generationType) {
          modMap = _prefixModMap;
        } else if ("suffix" == mod.generationType) {
          modMap = _suffixModMap;
        }

        if (modMap != null && "item" == mod.domain && !mod.isEssenceOnly) {
          String tag = spawnWeight.tag;
          List<Mod> modList = modMap[tag];
          if (modList == null) {
            modMap[tag] = List();
          }
          modMap[tag].add(mod);
        }
      });
    });
    return true;
  }

  Mod getPrefix(Item item) {
    List<Mod> possibleMods = List();
    item.tags.forEach((tag) {
      List<Mod> mods = _prefixModMap[tag];
      if (mods != null) {
        possibleMods.addAll(mods);
      }
    });
    return getMod(possibleMods, item);

  }

  Mod getSuffix(Item item) {
    List<Mod> possibleMods = List();
    item.tags.forEach((tag) {
      List<Mod> mods = _suffixModMap[tag];
      if (mods != null) {
        possibleMods.addAll(mods);
      }
    });
    return getMod(possibleMods, item);
  }

  Mod getMod(List<Mod> possibleMods, Item item) {
    Map<String, int> weightIdMap = Map();
    int totalWeight = 0;
    possibleMods.forEach((mod) {
      int weight = 1;
      int defaultWeight = 0;
      mod.spawnWeights.forEach((spawnWeight) {
        if (item.tags.contains(spawnWeight.tag)) {
          weight = max(weight, spawnWeight.weight);
        }
        if (spawnWeight.tag == "default") {
          defaultWeight = spawnWeight.weight;
        }
      });
      if (weight == 1) {
        weight = defaultWeight;
      }
      if (!weightIdMap.containsKey(mod.id)) {
        totalWeight += weight;
        weightIdMap[mod.id] = weight;
      }
    });
    int roll = rng.nextInt(totalWeight);
    int sum = 0;
    for (MapEntry<String, int> entry in weightIdMap.entries) {
      sum += entry.value;
      if (sum >= roll) {
        return _allModsMap[entry.key];
      }
    }
  }
}

class CraftingMod {
  int weight;
  String id;

  CraftingMod({
    this.weight,
    this.id
});
}
