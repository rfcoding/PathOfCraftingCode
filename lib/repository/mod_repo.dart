import 'dart:async' show Future;
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:poe_clicker/crafting/item/item.dart';
import '../crafting/mod.dart';
import '../crafting/fossil.dart';

class ModRepository {
  ModRepository._privateConstructor();

  static final ModRepository instance = ModRepository._privateConstructor();

  var rng = new Random();

  Map<String, List<Mod>> _prefixModMap;
  Map<String, List<Mod>> _suffixModMap;
  Map<String, Mod> _allModsMap;
  Map<String, List<String>> _modTagsMap;
  Map<String, List<Mod>> _modTierMap;

  bool _initialized;

  Future<bool> initialize() async {
    _initialized = false;
    _prefixModMap = Map();
    _suffixModMap = Map();
    _allModsMap = Map();
    _modTagsMap = Map();
    _modTierMap = Map();

    bool success = await loadModTypesJSONFromLocalStorage()
        .then((success) => loadModsJSONFromLocalStorage());

    _initialized = success;
    print("Prefix Mods ${_prefixModMap.keys.toString()}");
    print("Number of prefix tags: ${_prefixModMap.keys.length}");
    print("Suffix Mods ${_suffixModMap.keys.toString()}");
    print("Number of suffix tags: ${_suffixModMap.keys.length}");

    print("Number of Amulet prefix mods: ${_prefixModMap['amulet'].length}");
    print("Number of Amulet suffix mods: ${_suffixModMap['amulet'].length}");
    return _initialized;
  }

  Future<bool> loadModsJSONFromLocalStorage() async {
    var data = await rootBundle.loadString('data_repo/mods.json');
    Map<String, dynamic> jsonMap = json.decode(data);
    jsonMap.forEach((key, data) {
      String type = data['type'];
      List<String> tags = _modTagsMap[type];
      List<String> addsTags = List<String>.from(data['adds_tags']);
      Mod mod = Mod.fromJson(key, data, tags, addsTags);
      _allModsMap[mod.id] = mod;
      if (mod.generationType == "prefix" || mod.generationType == "suffix") {
        if (_modTierMap[mod.getGroupTagString()] == null) {
          _modTierMap[mod.getGroupTagString()] = List();
        }
        _modTierMap[mod.getGroupTagString()].add(mod);
      }
      for (SpawnWeight spawnWeight in mod.spawnWeights) {
        if (spawnWeight.weight == 0) {
          continue;
        }
        Map<String, List<Mod>> modMap;
        if ("prefix" == mod.generationType) {
          modMap = _prefixModMap;
        } else if ("suffix" == mod.generationType) {
          modMap = _suffixModMap;
        }
        if (modMap != null && shouldLoadDomain(mod.domain) &&
            !mod.isEssenceOnly) {
          String tag = spawnWeight.tag;
          List<Mod> modList = modMap[tag];
          if (modList == null) {
            modMap[tag] = List();
          }
          modMap[tag].add(mod);
        }
      }
    });
    _modTierMap.values.forEach((modList) {
      modList.sort((a, b) {
        return a.requiredLevel - b.requiredLevel;
      });
    });
    return true;
  }

  bool shouldLoadDomain(String domain) {
    return "item" == domain || "misc" == domain || "abyss_jewel" == domain;
  }

  Future<bool> loadModTypesJSONFromLocalStorage() async {
    var data = await rootBundle.loadString('data_repo/mod_types.json');
    Map<String, dynamic> jsonMap = json.decode(data);
    jsonMap.forEach((key, data) {
      List<String> tags = new List<String>.from(data['tags']);
      _modTagsMap[key] = tags;
    });
    return true;
  }

  Mod getPrefix(Item item, List<Fossil> fossils) {
    return getMod(getPossiblePrefixes(item, fossils), item, fossils);
  }

  Mod getSuffix(Item item, List<Fossil> fossils) {
    return getMod(getPossibleSuffixes(item, fossils), item, fossils);
  }

  List<Mod> getPossiblePrefixes(Item item, List<Fossil> fossils) {
    List<Mod> possibleMods = List();
    item.getAllTags().forEach((tag) {
      List<Mod> mods = _prefixModMap[tag];
      if (mods != null) {
        possibleMods.addAll(mods.where((mod) =>
        !item.alreadyHasModGroup(mod) &&
            item.itemLevel >= mod.requiredLevel && mod.domain == item.domain));
      }
    });
    fossils.map((fossil) => fossil.addedMods).expand((modId) => modId).forEach((
        modId) {
      Mod mod = getModById(modId);
      if (mod.generationType == "prefix" && !item.alreadyHasModGroup(mod)) {
        possibleMods.add(mod);
      }
    });
    possibleMods.addAll(_prefixModMap["default"].where((mod) =>
    !item.alreadyHasModGroup(mod) &&
        item.itemLevel >= mod.requiredLevel && mod.domain == item.domain
    ));
    return possibleMods;
  }

  List<Mod> getPossibleSuffixes(Item item, List<Fossil> fossils) {
    List<Mod> possibleMods = List();
    item.getAllTags().forEach((tag) {
      List<Mod> mods = _suffixModMap[tag];
      if (mods != null) {
        possibleMods.addAll(mods.where((mod) =>
        !item.alreadyHasModGroup(mod) &&
            item.itemLevel >= mod.requiredLevel
            && mod.domain == item.domain));
      }
    });
    fossils.map((fossil) => fossil.addedMods).expand((modId) => modId).forEach((
        modId) {
      Mod mod = getModById(modId);
      if (mod.generationType == "suffix" && !item.alreadyHasModGroup(mod)) {
        possibleMods.add(mod);
      }
    });

    possibleMods.addAll(_suffixModMap["default"].where((mod) =>
    !item.alreadyHasModGroup(mod) &&
        item.itemLevel >= mod.requiredLevel
        && mod.domain == item.domain
    ));
    return possibleMods;
  }

  Mod getMod(List<Mod> possibleMods, Item item, List<Fossil> fossils) {
    Map<String, ModWeightHolder> modWeightMap = getModWeights(possibleMods, item, fossils);
    if (modWeightMap.isEmpty) {
      return null;
    }
    int totalWeight = modWeightMap.values
        .map((modWeightMap) => modWeightMap.weight)
        .reduce((total, weight) => total + weight);
    if (totalWeight == 0) {
      return null;
    }
    int roll = rng.nextInt(totalWeight);
    int sum = 0;
    for (MapEntry<String, ModWeightHolder> entry in modWeightMap.entries) {
      sum += entry.value.weight;
      if (sum >= roll) {
        return entry.value.mod;
      }
    }
    return null;
  }

  Map<String, ModWeightHolder> getModWeights(List<Mod> possibleMods, Item item, List<Fossil> fossils) {
    bool isBow = item.itemClass == "Bow";
    Map<String, ModWeightHolder> weightIdMap = Map();
    possibleMods.forEach((mod) {
      int weight = 1;
      int defaultWeight = 0;
      for (SpawnWeight spawnWeight in mod.spawnWeights) {
        if (item.getAllTags().contains(spawnWeight.tag)) {
          if (spawnWeight.weight == 0) {
            weight = 0;
            break;
          }
          weight = max(weight, spawnWeight.weight);
        }
        if (spawnWeight.tag == "default") {
          defaultWeight = spawnWeight.weight;
        }
      }
      // Ugly bow hack :(
      if (isBow) {
        if ((item.hasCannotRollAttackMods() &&
            mod.spawnWeights.any((weight) => weight.tag == "no_attack_mods"))
            || (item.hasCannotRollCasterMods() &&
                mod.spawnWeights.any((weight) => weight.tag ==
                    "no_caster_mods"))) {
          weight = 0;
        } else if (mod.spawnWeights.any((weight) => weight.tag == "bow" &&
            weight.weight > 0)) {
          weight = mod.spawnWeights
              .firstWhere((weight) => weight.tag == "bow")
              .weight;
        }
      }
      if (weight == 1) {
        weight = defaultWeight;
      }
      if (weight > 0 && !weightIdMap.containsKey(mod.id)) {
        weight = calculateFossilWeight(mod, fossils, weight);
        weightIdMap[mod.id] = ModWeightHolder(mod: mod, weight: weight);
      }
    });
    return weightIdMap;
  }

  Mod getModById(String id) {
    return _allModsMap[id];
  }

  int getModTier(Mod mod) {
    String id = mod.getGroupTagString();
    List<Mod> modsInGroup = _modTierMap[id];
    Mod modWithSameId = modsInGroup.firstWhere((m) => m.id == mod.id);
    return modsInGroup != null ? modsInGroup.length -
        modsInGroup.indexOf(modWithSameId) : 1;
  }

  int calculateFossilWeight(Mod mod, List<Fossil> fossils, int spawnWeight) {
    List<FossilModWeight> positiveWeights = fossils.map((fossil) =>
    fossil.positiveModWeights)
        .expand((weights) => weights)
        .where((weights) => mod.tags.contains(weights.tag))
        .toList();

    List<FossilModWeight> negativeWeights = fossils.map((fossil) =>
    fossil.negativeModWeights)
        .expand((weights) => weights)
        .where((weights) => mod.tags.contains(weights.tag))
        .toList();

    for (FossilModWeight modWeight in negativeWeights) {
      spawnWeight *= (modWeight.weight / 100).floor();
    }
    for (FossilModWeight modWeight in positiveWeights) {
      spawnWeight *= (modWeight.weight / 100).floor();
    }
    return spawnWeight;
  }
}

class ModWeightHolder {
  Mod mod;
  int weight;

  ModWeightHolder({
    this.mod,
    this.weight
  });
}
