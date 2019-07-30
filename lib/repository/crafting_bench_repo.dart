import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../crafting/mod.dart';
import 'mod_repo.dart';

class CraftingBenchRepository {

  CraftingBenchRepository._privateConstructor();
  static final CraftingBenchRepository instance = CraftingBenchRepository._privateConstructor();

  List<CraftingBenchOption> craftingBenchOptions;

  Future<bool> initialize() async {
    craftingBenchOptions = List();
    var data = await rootBundle.loadString('data_repo/crafting_bench_options.json');
    var jsonList = json.decode(data);
    jsonList.forEach((data) => craftingBenchOptions.add(CraftingBenchOption.fromJson(data)));
    return true;
  }
}

class CraftingBenchOption {
  String benchGroup;
  int benchTier;
  List<String> itemClasses;
  Mod mod;

  CraftingBenchOption({
    this.benchGroup,
    this.benchTier,
    this.itemClasses,
    this.mod,
  });

  factory CraftingBenchOption.fromJson(Map<String, dynamic> json) {
    String modId = json['mod_id'];
    Mod mod = ModRepository.instance.getModById(modId);
    return CraftingBenchOption(
      benchGroup: json['bench_group'],
      benchTier: json['bench_tier'],
      itemClasses: List<String>.from(json['item_classes']),
      mod: mod,
    );
  }
}