import 'package:flutter/material.dart';
import 'dart:convert';
import 'item.dart';
import 'normal_item.dart';
import 'magic_item.dart';
import '../mod.dart';
import '../properties.dart';
import '../fossil.dart';
import '../../widgets/crafting_widget.dart';
import '../../widgets/utils.dart';
import '../../repository/mod_repo.dart';
import 'spending_report.dart';

class RareItem extends Item {
  Color textColor = Color(0xFFFFFC8A);
  Color boxColor = Color(0xFF201C1C);
  Color borderColor = Color(0xFF89672B);

  RareItem(String name,
      List<Mod> prefixes,
      List<Mod> suffixes,
      List<Mod> implicits,
      List<String> tags,
      WeaponProperties weaponProperties,
      ArmourProperties armourProperties,
      String itemClass,
      int itemLevel,
      SpendingReport spendingReport)
      : super(
      name,
      prefixes,
      suffixes,
      implicits,
      tags,
      weaponProperties,
      armourProperties,
      itemClass,
      itemLevel,
      spendingReport);

  factory RareItem.fromJson(Map<String, dynamic> data) {
    var prefixesJson = data['prefixes'] as List;
    List<Mod> prefixes = prefixesJson.map((prefix) => Mod.fromSavedJson(prefix)).toList();
    var suffixesJson = data['suffixes'] as List;
    List<Mod> suffixes = suffixesJson.map((suffix) => Mod.fromSavedJson(suffix)).toList();
    var implicitsJson = data['implicits'] as List;
    List<Mod> implicits = implicitsJson.map((implicit) => Mod.fromSavedJson(implicit)).toList();
    List<String> tags = new List<String>.from(json.decode(data['tags']));

    WeaponProperties weaponProperties;
    ArmourProperties armourProperties;
    if (tags.contains("weapon")) {
      weaponProperties = WeaponProperties.fromJson(data['properties']);
    } else if (tags.contains("armour")) {
      armourProperties = ArmourProperties.fromJson(data['properties']);
    }

    dynamic spendingReportData = data['spending_report'];
    return RareItem(
      data['name'],
      prefixes,
      suffixes,
      implicits,
      tags,
      weaponProperties,
      armourProperties,
      data['item_class'],
      data['item_level'],
      spendingReportData != null ? SpendingReport.fromJson(spendingReportData) : SpendingReport()
    );
  }

  @override
  String getRarity() {
    return "rare";
  }

  @override
  Color getBorderColor() {
    return Color(0xFF89672B);
  }

  @override
  Color getBoxColor() {
    return Color(0xFF201C1C);
  }

  @override
  Color getTextColor() {
    return Color(0xFFFFFC8A);
  }

  @override
  void reroll({List<Fossil> fossils: const[]}) {
    clearMods();
    fillMods(fossils: fossils);
  }

  void fillMods({List<Fossil> fossils: const[]}) {
    if (prefixes.isEmpty) {
      addPrefix(fossils: fossils);
    }
    if (suffixes.isEmpty) {
      addSuffix(fossils: fossils);
    }
    final int roll = rng.nextInt(100);
    int numberOfMods = 4;
    // 65% chance of 4 mods, 25% 5 mods, 10% 6 mods
    if (roll >= 90) {
      numberOfMods = 6;
    } else if (roll >= 65) {
      numberOfMods = 5;
    }
    print("number of mods: $numberOfMods");
    final int currentNumberOfMods = prefixes.length + suffixes.length;
    int numberOfNewMods = numberOfMods - currentNumberOfMods;
    print("number of new mods: $numberOfNewMods");
    for (int i = 0; i < numberOfNewMods; i++) {
      if (rng.nextBool()) {
        addPrefix(fossils: fossils);
      } else {
        addSuffix(fossils: fossils);
      }
    }
  }

  Item scour() {
    this.spendingReport.addSpending(scour: 1);
    if (suffixes.any((mod) => mod.group == "ItemGenerationCannotChangePrefixes")) {
      return scourSuffixes();
    } else if (prefixes.any((mod) => mod.group == "ItemGenerationCannotChangeSuffixes")) {
      return scourPrefixes();
    }
    return NormalItem(
        this.name,
        new List(),
        new List(),
        this.implicits,
        this.tags,
        this.weaponProperties,
        this.armourProperties,
        this.itemClass,
        this.itemLevel,
        this.spendingReport);
  }

  RareItem exalt() {
    if (prefixes.length + suffixes.length == 6) {
      return this;
    }
    this.spendingReport.addSpending(exalt: 1);
    addRandomMod();
    return this;
  }

  RareItem chaos() {
    this.spendingReport.addSpending(chaos: 1);
    reroll();
    return this;
  }

  RareItem annulment() {
    if (prefixes.isEmpty && suffixes.isEmpty) {
      return this;
    }
    this.spendingReport.addSpending(annulment: 1);
    List<Mod> mods = getMods();
    Mod modToRemove = mods[rng.nextInt(mods.length)];
    if (modToRemove.generationType == "prefix") {
      prefixes.remove(modToRemove);
    } else {
      suffixes.remove(modToRemove);
    }
    return this;
  }

  RareItem useFossils(List<Fossil> fossils) {
    List<Mod> forcedMods = fossils
        .map((fossil) => fossil.forcedMods)
        .expand((mods) => mods)
        .map((modId) => ModRepository.instance.getModById(modId))
        .toList();
    if (forcedMods.isEmpty) {
      reroll(fossils: fossils);
    } else {
      clearMods();
      Mod mod = ModRepository.instance.getMod(forcedMods, this, List());
      if (mod.generationType == "prefix") {
        prefixes.add(mod);
      } else {
        suffixes.add(mod);
      }
      fillMods(fossils: fossils);
    }
    return this;
  }

  @override
  Item scourPrefixes() {
    if (suffixes.length == 0) {
      return NormalItem(
          name,
          List(),
          List(),
          implicits,
          tags,
          weaponProperties,
          armourProperties,
          itemClass,
          itemLevel,
          spendingReport);
    } else if (suffixes.length == 1) {
      return MagicItem(
          name,
          List(),
          suffixes,
          implicits,
          tags,
          weaponProperties,
          armourProperties,
          itemClass,
          itemLevel,
          spendingReport);
    } else {
      prefixes.clear();
      return this;
    }
  }

  @override
  Item scourSuffixes() {
    if (prefixes.length == 0) {
      return NormalItem(
          name,
          List(),
          List(),
          implicits,
          tags,
          weaponProperties,
          armourProperties,
          itemClass,
          itemLevel,
          spendingReport);
    } else if (prefixes.length == 1) {
      return MagicItem(
          name,
          prefixes,
          List(),
          implicits,
          tags,
          weaponProperties,
          armourProperties,
          itemClass,
          itemLevel,
          spendingReport);
    } else {
      suffixes.clear();
      return this;
    }
  }

  @override
  void addRandomMod() {
    // Max mods
    if (getMods().length == 6) {
      return;
    }
    if (prefixes.length == 3) {
      addSuffix();
    } else if (suffixes.length == 3){
      addPrefix();
    } else {
      bool prefix = rng.nextInt(2) == 1;
      if (prefix) {
        addPrefix();
      } else {
        addSuffix();
      }
    }
  }

  @override
  bool hasMaxPrefixes() {
    return prefixes.length >= 3;
  }
  @override
  bool hasMaxSuffixes() {
    return suffixes.length >= 3;
  }

  @override
  Widget getActionsWidget(CraftingWidgetState state) {
    return
      Row(mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            imageButton('assets/images/scour.png', () =>
                state.itemChanged(this.scour())),
            imageButton('assets/images/chaos.png', () =>
                state.itemChanged(this.chaos())),
            imageButton('assets/images/exalted.png', () =>
                state.itemChanged(this.exalt())),
            imageButton('assets/images/annulment.png', () =>
                state.itemChanged(this.annulment())),
            imageButton('assets/images/divine.png', () =>
                state.itemChanged(this.divine())),
            emptySquare()
          ]);
  }

  @override
  String getHeaderLeftImagePath() {
    return 'assets/images/header-rare-left.png';
  }

  @override
  String getHeaderMiddleImagePath() {
    return 'assets/images/header-rare-middle.png';

  }

  @override
  String getHeaderRightImagePath() {
    return 'assets/images/header-rare-right.png';
  }

  @override
  String getDividerImagePath() {
    return 'assets/images/seperator-rare.png';
  }

  @override
  double getHeaderDecorationWidth() {
    return 29;
  }

  @override
  double getHeaderHeight() {
    return 34;
  }
}