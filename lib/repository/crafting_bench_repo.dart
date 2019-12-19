import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../crafting/mod.dart';
import '../crafting/item/item.dart';
import 'mod_repo.dart';

class CraftingBenchRepository {

  CraftingBenchRepository._privateConstructor();
  static final CraftingBenchRepository instance = CraftingBenchRepository._privateConstructor();

  List<CraftingBenchOption> craftingBenchOptions;

  Future<bool> initialize() async {
    craftingBenchOptions = List();
    var data = await rootBundle.loadString('data_repo/crafting_bench_options.json');
    var jsonList = json.decode(data);
    jsonList.forEach((data) {
      CraftingBenchOption craftingBenchOption = CraftingBenchOption.fromJson(data);
      craftingBenchOptions.add(craftingBenchOption);
    });
    return true;
  }

  Map<String, List<CraftingBenchOption>> getCraftingOptionsForItem(Item item) {
    Map<String, List<CraftingBenchOption>> optionsMap = Map();
    for (CraftingBenchOption option in craftingBenchOptions) {
      if (itemCanHaveMod(item, option)) {
        if (optionsMap[option.benchGroup] == null) {
          optionsMap[option.benchGroup] = List();
        }
        optionsMap[option.benchGroup].add(option);
      }
    }
    optionsMap.values.forEach((list) => list.sort((a, b) => a.compareTo(b)));
    return optionsMap;
  }
}

bool itemCanHaveMod(Item item, CraftingBenchOption option) {
  if (!option.itemClasses.contains(item.itemClass)
      || item.getMods().map((mod) => mod.group).contains(option.mod.group)) {
    return false;  
  }

  if (!item.canAddCraftedModifier()) {
    return false;
  }

  if (option.mod.generationType == "prefix") {
    return !item.hasMaxPrefixes();
  }
  return !item.hasMaxSuffixes();
}

class CraftingBenchOptionCost {
  final String itemId;
  final int count;

  CraftingBenchOptionCost(this.itemId, this.count);
}

class CraftingBenchOption implements Comparable<CraftingBenchOption> {
  String benchDisplayName;
  String benchGroup;
  int benchTier;
  List<String> itemClasses;
  Mod mod;
  List<CraftingBenchOptionCost> costs;

  CraftingBenchOption({
    this.benchDisplayName,
    this.benchGroup,
    this.benchTier,
    this.itemClasses,
    this.mod,
    this.costs
  });

  factory CraftingBenchOption.fromJson(Map<String, dynamic> json) {
    String modId = json['mod_id'];
    Mod mod = ModRepository.instance.getModById(modId);
    String displayName = mod.getStatStringWithValueRanges().join("\n");
    final List<CraftingBenchOptionCost> costs = List();
    Map<String, dynamic> costJson = json['cost'];
    costJson.forEach((type, count) {
      costs.add(CraftingBenchOptionCost(type, count));
    });

    return CraftingBenchOption(
      benchDisplayName: displayName,
      benchGroup: json['bench_group'],
      benchTier: json['bench_tier'],
      itemClasses: List<String>.from(json['item_classes']),
      mod: mod,
      costs: costs
    );
  }

  @override
  int compareTo(CraftingBenchOption other) {
    return other.benchTier - this.benchTier;
  }
}