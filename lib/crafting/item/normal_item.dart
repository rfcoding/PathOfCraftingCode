import 'package:flutter/material.dart';
import 'item.dart';
import 'dart:convert';
import 'magic_item.dart';
import 'rare_item.dart';
import '../mod.dart';
import '../properties.dart';
import '../fossil.dart';
import '../currency_type.dart';
import '../../widgets/crafting_widget.dart';
import '../../widgets/utils.dart';
import 'spending_report.dart';

class NormalItem extends Item {
  NormalItem(String name,
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

  factory NormalItem.fromJson(Map<String, dynamic> data) {
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

    return NormalItem(
        data['name'],
        prefixes,
        suffixes,
        implicits,
        tags,
        weaponProperties,
        armourProperties,
        data['item_class'],
        data['item_level'],
        spendingReportData != null ? SpendingReport.fromJson(spendingReportData) : null
    );
  }
  @override
  Color getBorderColor() {
    return Color(0xFF696563);
  }

  @override
  Color getBoxColor() {
    return Color(0xFF303030);
  }

  @override
  Color getTextColor() {
    return Color(0xFFC8C8C8);
  }

  @override
  void reroll({List<Fossil> fossils: const[]}) {
    //Do nothing
  }

  @override
  void addRandomMod() {
    // Do nothing
  }

  MagicItem transmute() {
    this.spendingReport.addSpending(CurrencyType.transmute, 1);
    MagicItem item = MagicItem(
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
    item.reroll();
    return item;
  }

  RareItem alchemy() {
    this.spendingReport.addSpending(CurrencyType.alchemy, 1);
    RareItem item = RareItem(
        this.name,
        List(),
        List(),
        this.implicits,
        this.tags,
        this.weaponProperties,
        this.armourProperties,
        this.itemClass,
        this.itemLevel,
        this.spendingReport);
    item.reroll();
    return item;
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
        this.itemLevel,
        this.spendingReport);
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
    return true;
  }
  @override
  bool hasMaxSuffixes() {
    return true;
  }

  @override
  Widget getActionsWidget(CraftingWidgetState state) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          imageButton(
              'assets/images/transmute.png', 'Orb of Transmutation', () =>
              state.itemChanged(this.transmute())),
          imageButton('assets/images/alchemy.png', 'Orb of Alchemy', () =>
              state.itemChanged(this.alchemy())),
          emptySquare(),
          emptySquare(),
          emptySquare(),
          emptySquare(),
        ]);
  }

  @override
  String getRarity() {
    return "normal";
  }

  @override
  String getHeaderLeftImagePath() {
    return 'assets/images/header-normal-left.png';
  }

  @override
  String getHeaderMiddleImagePath() {
    return 'assets/images/header-normal-middle.png';

  }

  @override
  String getHeaderRightImagePath() {
    return 'assets/images/header-normal-right.png';
  }

  @override
  String getDividerImagePath() {
    return 'assets/images/seperator-normal.png';
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