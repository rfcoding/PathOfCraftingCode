import 'package:flutter/material.dart';
import 'package:poe_clicker/repository/essence_repo.dart';
import 'dart:convert';
import 'dart:math';
import '../essence.dart';
import 'item.dart';
import 'normal_item.dart';
import 'magic_item.dart';
import '../mod.dart';
import '../properties.dart';
import '../fossil.dart';
import '../currency_type.dart';
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
      List<Mod> enchantments,
      List<String> tags,
      WeaponProperties weaponProperties,
      ArmourProperties armourProperties,
      String itemClass,
      int itemLevel,
      String domain,
      SpendingReport spendingReport,
      Item imprint,
      bool corrupted)
      : super(
      name,
      prefixes,
      suffixes,
      implicits,
      enchantments,
      tags,
      weaponProperties,
      armourProperties,
      itemClass,
      itemLevel,
      domain,
      spendingReport,
      imprint,
      corrupted);

  factory RareItem.fromJson(Map<String, dynamic> data) {
    var prefixesJson = data['prefixes'] as List;
    List<Mod> prefixes = prefixesJson == null ? List() : prefixesJson.map((prefix) => Mod.fromSavedJson(prefix)).toList();
    var suffixesJson = data['suffixes'] as List;
    List<Mod> suffixes = suffixesJson == null ? List() : suffixesJson.map((suffix) => Mod.fromSavedJson(suffix)).toList();
    var implicitsJson = data['implicits'] as List;
    List<Mod> implicits = implicitsJson == null ? List() : implicitsJson.map((implicit) => Mod.fromSavedJson(implicit)).toList();
    var enchantmentsJson = data['enchantments'] as List;
    List<Mod> enchantments = enchantmentsJson == null ? List() : enchantmentsJson.map((enchant) => Mod.fromSavedJson(enchant)).toList();
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
      enchantments,
      tags,
      weaponProperties,
      armourProperties,
      data['item_class'],
      data['item_level'],
      // Shitty fix for loading old items
      data['domain'] != null ? data['domain'] : 'item',
      spendingReportData != null ? SpendingReport.fromJson(spendingReportData) : SpendingReport.empty(),
      data['imprint'] != null ? Item.fromJson(data['imprint']) : null,
      data['corrupted'] != null ? data['corrupted'] : false,
    );
  }


  factory RareItem.fromItem(Item item, List<Mod> prefixes, List<Mod> suffixes) {
    return RareItem(
        item.name,
        prefixes,
        suffixes,
        List.generate(item.implicits.length, (index) => Mod.copy(item.implicits[index])),
        List.generate(item.enchantments.length, (index) => Mod.copy(item.enchantments[index])),
        item.tags,
        item.weaponProperties,
        item.armourProperties,
        item.itemClass,
        item.itemLevel,
        item.domain,
        item.spendingReport,
        item != null ? Item.copy(item.imprint) : null,
        item.corrupted);
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
    if (hasCannotChangePrefixes() && hasCannotChangeSuffixes()) {
      return;
    } else if (hasCannotChangePrefixes()) {
      suffixes.clear();
    } else if (hasCannotChangeSuffixes()) {
      prefixes.clear();
    } else {
      clearMods();
    }
    fillMods(fossils: fossils);
  }

  @override
  int getNumberOfNewMods() {
    final int roll = rng.nextInt(100);
    int numberOfMods = 0;
    if (domain == "item") {
      numberOfMods = 4;
      // 65% chance of 4 mods, 25% 5 mods, 10% 6 mods
      if (roll >= 90) {
        numberOfMods = 6;
      } else if (roll >= 65) {
        numberOfMods = 5;
      }
    } else {
      numberOfMods = 3;
      if (roll >= 85) {
        numberOfMods = 4;
      }
    }
    return numberOfMods;
  }

  Item scour() {
    if ((prefixes.isEmpty && suffixes.isEmpty)
        || (hasCannotChangePrefixes() && hasCannotChangeSuffixes())) {
      return this;
    }
    this.spendingReport.addSpending(CurrencyType.scour, 1);
    if (hasCannotChangePrefixes()) {
      return scourSuffixes();
    } else if (hasCannotChangeSuffixes()) {
      return scourPrefixes();
    }
    return NormalItem.fromItem(this, List(), List());
  }

  RareItem exalt() {
    if (hasMaxMods()) {
      return this;
    }
    this.spendingReport.addSpending(CurrencyType.exalt, 1);
    addRandomMod();
    return this;
  }

  RareItem chaos() {
    this.spendingReport.addSpending(CurrencyType.chaos, 1);
    reroll();
    return this;
  }

  RareItem corrupt() {
    this.spendingReport.addSpending(CurrencyType.vaal, 1);
    this.corrupted = true;
    int roll = rng.nextInt(100);
    if (roll < 25) {
      // No effect
    } else if (roll < 50) {
      // White socket == no effect
    } else if (roll < 75) {
      // Re-roll into rare
      reroll();
    } else {
      // Implicit
      addVaalImplicit();
    }
    return this;
  }

  RareItem annulment() {
    if ((prefixes.isEmpty && suffixes.isEmpty)
        || (hasCannotChangeSuffixes() && hasCannotChangePrefixes())) {
      return this;
    }
    this.spendingReport.addSpending(CurrencyType.annulment, 1);
    Mod modToRemove;
    if (hasCannotChangePrefixes()) {
      modToRemove = suffixes[rng.nextInt(suffixes.length)];
    } else if (hasCannotChangeSuffixes()) {
      modToRemove = prefixes[rng.nextInt(prefixes.length)];
    } else {
      List<Mod> mods = getMods();
      modToRemove = mods[rng.nextInt(mods.length)];
    }
    if (modToRemove.generationType == "prefix") {
      prefixes.remove(modToRemove);
    } else {
      suffixes.remove(modToRemove);
    }
    return this;
  }

  RareItem useFossils(List<Fossil> fossils) {
    Mod essenceMod;
    List<Mod> forcedMods = fossils
        .map((fossil) => fossil.forcedMods)
        .expand((mods) => mods)
        .map((modId) => ModRepository.instance.getModById(modId))
        .toList();
    int corruptEssenceChange = fossils.where((fossil) => fossil.corruptEssenceChance != null)
        .map((fossil) => fossil.corruptEssenceChance)
        .reduce((total, chance) => total += chance);
    if (rng.nextInt(100) < corruptEssenceChange) {
      Essence corruptEssence = EssenceRepository.instance.getRandomCorruptedEssence();
      essenceMod = getEssenceModFromEssence(corruptEssence);
    }
    clearMods();
    addEssenceMod(essenceMod);
    addForcedMods(forcedMods);
    fillMods(fossils: fossils);


    if (fossils.any((fossil) => fossil.enchants)) {
      enchant();
    }
    spendingReport.spendFossils(fossils);
    spendingReport.spendResonator(fossils);
    return this;
  }

  void addForcedMods(List<Mod> forcedMods) {
    for (Mod maybeMod in forcedMods) {
      Mod mod = ModRepository.instance.selectRandomMod([maybeMod], this, List());
      if (mod != null) {
        if (mod.isPrefix()) {
          prefixes.add(mod);
        } else {
          suffixes.add(mod);
        }
      }
    }
  }

  void addEssenceMod(Mod essenceMod) {
    if (essenceMod == null) {
      return;
    }
    if (essenceMod.isPrefix()) {
      prefixes.add(essenceMod);
    } else {
      suffixes.add(essenceMod);
    }
  }

  @override
  Item scourPrefixes() {
    if (suffixes.length == 0) {
      return NormalItem.fromItem(this, List(), List());
    } else if (suffixes.length == 1) {
      return MagicItem.fromItem(this, List(), suffixes);
    } else {
      prefixes.clear();
      return this;
    }
  }

  @override
  Item scourSuffixes() {
    if (prefixes.length == 0) {
      return NormalItem.fromItem(this, List(), List());
    } else if (prefixes.length == 1) {
      return MagicItem.fromItem(this, prefixes, List());
    } else {
      suffixes.clear();
      return this;
    }
  }

  @override
  int maxNumberOfAffixes() {
    return domain == "item" ? 6 : 4;
  }

  @override
  int maxNumberOfPrefixes() {
    return domain == "item" ? 3 : 2;
  }

  @override
  int maxNumberOfSuffixes() {
    return domain == "item" ? 3 : 2;
  }

  @override
  Widget getNormalActionsWidget(CraftingWidgetState state) {
    return
      Row(mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            imageButton('assets/images/scour.png', 'Orb of Scouring', () =>
                state.itemChanged(this.scour())),
            imageButton('assets/images/chaos.png', 'Chaos orb', () =>
                state.itemChanged(this.chaos())),
            imageButton('assets/images/exalted.png', 'Exalted orb', () =>
                state.itemChanged(this.exalt())),
            imageButton('assets/images/annulment.png', 'Orb of Annulment', () =>
                state.itemChanged(this.annulment())),
            imageButton('assets/images/divine.png', 'Divine orb', () =>
                state.itemChanged(this.divine())),
            imageButton('assets/images/vaal.png', 'Vaal orb', () =>
                state.itemChanged(this.corrupt())),
          ]);
  }

  @override
  Widget getDisabledActionsWidget(CraftingWidgetState state) {
    return
      Row(mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            disabledImageButton('assets/images/scour.png', 'Orb of Scouring', null),
            disabledImageButton('assets/images/chaos.png', 'Chaos orb', null),
            disabledImageButton('assets/images/exalted.png', 'Exalted orb', null),
            disabledImageButton('assets/images/annulment.png', 'Orb of Annulment', null),
            disabledImageButton('assets/images/divine.png', 'Divine orb', null),
            disabledImageButton('assets/images/vaal.png', 'Vaal orb', null),
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