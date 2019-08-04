import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'item.dart';
import 'normal_item.dart';
import 'rare_item.dart';
import '../mod.dart';
import '../properties.dart';
import '../fossil.dart';
import '../../widgets/crafting_widget.dart';
import '../../widgets/utils.dart';

class MagicItem extends Item {
  MagicItem(String name,
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

  factory MagicItem.fromJson(Map<String, dynamic> data) {
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

    return MagicItem(
        data['name'],
        prefixes,
        suffixes,
        implicits,
        tags,
        weaponProperties,
        armourProperties,
        data['item_class'],
        data['item_level']
    );
  }

  @override
  Color getBorderColor() {
    return Color(0xFF393E5C);
  }

  @override
  Color getBoxColor() {
    return Color(0xFF19192B);
  }

  @override
  Color getTextColor() {
    return Color(0xFF959AF6);
  }

  @override
  void reroll({List<Fossil> fossils: const[]}) {
    clearMods();
    // 1 or 2 mods, 50/50
    final int nMods = rng.nextInt(2) + 1;
    if (nMods == 2) {
      addPrefix();
      addSuffix();
    } else {
      rng.nextBool() ? addSuffix() : addPrefix();
    }
  }

  RareItem regal() {
    RareItem item = RareItem(
        this.name,
        this.prefixes,
        this.suffixes,
        this.implicits,
        this.tags,
        this.weaponProperties,
        this.armourProperties,
        this.itemClass,
        this.itemLevel);
    item.addRandomMod();
    return item;
  }

  MagicItem augment() {
    addRandomMod();
    return this;
  }

  MagicItem alteration() {
    reroll();
    return this;
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

  @override
  RareItem useFossils(List<Fossil> fossils) {
    RareItem item = RareItem(
        this.name,
        List(),
        List(),
        this.implicits,
        this.tags,
        this.weaponProperties,
        this.armourProperties,
        this.itemClass,
        this.itemLevel);
    return item.useFossils(fossils);
  }

  @override
  Item scourPrefixes() {
    return this;
  }

  @override
  Item scourSuffixes() {
    return this;
  }

  @override
  bool hasMaxPrefixes() {
    return prefixes.length >= 1;
  }
  @override
  bool hasMaxSuffixes() {
    return suffixes.length >= 1;
  }

  @override
  void addRandomMod() {
    List<Mod> mods = getMods();
    // Max mods
    if (mods.length == 2) {
      return;
    }
    int nPrefixes = prefixes.length;
    if (nPrefixes == 1) {
      addSuffix();
    } else {
      addPrefix();
    }
  }

  @override
  Widget getActionsWidget(CraftingWidgetState state) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          imageButton(
              'assets/images/scour.png', () => state.itemChanged(this.scour())),
          imageButton('assets/images/alteration.png', () =>
              state.itemChanged(this.alteration())),
          imageButton('assets/images/augmentation.png', () =>
              state.itemChanged(this.augment())),
          imageButton(
              'assets/images/regal.png', () => state.itemChanged(this.regal())),
          imageButton('assets/images/divine.png', () =>
              state.itemChanged(this.divine())),
          emptySquare(),
        ]);
  }

  @override
  String getRarity() {
    return "magic";
  }

  @override
  String getHeaderLeftImagePath() {
    return 'assets/images/header-magic-left.png';
  }

  @override
  String getHeaderMiddleImagePath() {
    return 'assets/images/header-magic-middle.png';

  }

  @override
  String getHeaderRightImagePath() {
    return 'assets/images/header-magic-right.png';
  }

  @override
  String getDividerImagePath() {
    return 'assets/images/seperator-magic.png';
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