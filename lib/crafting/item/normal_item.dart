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

  factory NormalItem.fromJson(Map<String, dynamic> data) {
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

    return NormalItem(
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
        spendingReportData != null ? SpendingReport.fromJson(spendingReportData) : null,
        data['imprint'] != null ? Item.fromJson(data['imprint']) : null,
        data['corrupted'] != null ? data['corrupted'] : false,
    );
  }

  factory NormalItem.fromItem(Item item, List<Mod> prefixes, List<Mod> suffixes) {
    return NormalItem(
        item.name,
        prefixes,
        suffixes,
        item.implicits,
        item.enchantments,
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

  MagicItem transmute() {
    this.spendingReport.addSpending(CurrencyType.transmute, 1);
    MagicItem item = MagicItem.fromItem(this, List(), List());
    item.reroll();
    return item;
  }

  RareItem alchemy() {
    this.spendingReport.addSpending(CurrencyType.alchemy, 1);
    RareItem item = RareItem.fromItem(this, List(), List());
    item.reroll();
    return item;
  }

  @override
  RareItem useFossils(List<Fossil> fossils) {
    RareItem item = RareItem.fromItem(this, List(), List());
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
  int maxNumberOfAffixes() {
    return 0;
  }

  @override
  int maxNumberOfPrefixes() {
    return 0;
  }

  @override
  int maxNumberOfSuffixes() {
    return 0;
  }

  @override
  int getNumberOfNewMods() {
    return 0;
  }

  @override
  Widget getNormalActionsWidget(CraftingWidgetState state) {
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
  Widget getDisabledActionsWidget(CraftingWidgetState state) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          disabledImageButton(
              'assets/images/transmute.png', 'Orb of Transmutation', null),
          disabledImageButton('assets/images/alchemy.png', 'Orb of Alchemy', null),
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