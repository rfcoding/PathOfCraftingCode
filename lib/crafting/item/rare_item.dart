import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'item.dart';
import 'normal_item.dart';
import 'magic_item.dart';
import '../mod.dart';
import '../properties.dart';
import '../fossil.dart';
import '../../widgets/crafting_widget.dart';
import '../../widgets/utils.dart';

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
      int itemLevel)
      : super(
      name,
      prefixes,
      suffixes,
      implicits,
      tags,
      weaponProperties,
      armourProperties,
      itemClass,
      itemLevel);

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
    int nPrefixes = rng.nextInt(3 - prefixes.length) + 1;
    int nSuffixes = max((rng.nextInt(3 - suffixes.length) + 1), 4 - nPrefixes);
    for (int i = 0; i < nPrefixes; i++) {
      addPrefix(fossils: fossils);
    }
    for (int i = 0; i < nSuffixes; i++) {
      addSuffix(fossils: fossils);
    }
  }

  NormalItem scour() {
    return NormalItem(
        this.name,
        new List(),
        new List(),
        this.implicits,
        this.tags,
        this.weaponProperties,
        this.armourProperties,
        this.itemClass,
        this.itemLevel);
  }

  RareItem exalt() {
    addRandomMod();
    return this;
  }

  RareItem chaos() {
    reroll();
    return this;
  }

  RareItem annulment() {
    if (prefixes.isEmpty && suffixes.isEmpty) {
      return this;
    }
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
    reroll(fossils: fossils);
    return this;
  }

  @override
  Item scourPrefixes() {
    // Max prefix => can't add the mod
    if (prefixes.length == 3) {
      return this;
    }
    prefixes.clear();

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
          itemLevel);
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
          itemLevel);
    } else {
      return this;
    }
  }

  @override
  Item scourSuffixes() {
    // Max suffix => can't add the mod
    if (suffixes.length == 3) {
      return this;
    }

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
          itemLevel);
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
          itemLevel);
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
      Row(children: <Widget>[
        imageButton('assets/images/scour.png', () => state.itemChanged(this.scour())),
        imageButton('assets/images/chaos.png', () => state.itemChanged(this.chaos())),
        imageButton('assets/images/exalted.png', () => state.itemChanged(this.exalt())),
        imageButton('assets/images/annulment.png', () => state.itemChanged(this.annulment())),
        imageButton('assets/images/divine.png', () => state.itemChanged(this.divine())),
      ]);
  }
}