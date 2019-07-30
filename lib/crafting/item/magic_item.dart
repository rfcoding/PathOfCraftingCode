import 'package:flutter/material.dart';
import 'dart:math';
import 'item.dart';
import 'normal_item.dart';
import 'rare_item.dart';
import '../mod.dart';
import '../properties.dart';
import '../fossil.dart';
import '../../widgets/crafting_widget.dart';

class MagicItem extends Item {
  MagicItem(String name,
      List<Mod> prefixes,
      List<Mod> suffixes,
      List<Mod> implicits,
      List<String> tags,
      WeaponProperties weaponProperties,
      ArmourProperties armourProperties,
      String itemClass)
      : super(
      name,
      prefixes,
      suffixes,
      implicits,
      tags,
      weaponProperties,
      armourProperties,
      itemClass);

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
    int nPrefixes = rng.nextInt(2);
    int nSuffixes = max(rng.nextInt(2), 1 - nPrefixes);
    for (int i = 0; i < nPrefixes; i++) {
      addPrefix();
    }
    for (int i = 0; i < nSuffixes; i++) {
      addSuffix();
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
        this.itemClass);
    item.addMod();
    return item;
  }

  MagicItem augment() {
    addMod();
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
        this.itemClass);
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
        this.itemClass);
    return item.useFossils(fossils);
  }

  @override
  void addMod() {
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
    return Row(children: <Widget>[
      imageButton('assets/images/scour.png', () => state.itemChanged(this.scour())),
      imageButton('assets/images/alteration.png', () => state.itemChanged(this.alteration())),
      imageButton('assets/images/augmentation.png', () => state.itemChanged(this.augment())),
      imageButton('assets/images/regal.png', () => state.itemChanged(this.regal())),
      imageButton('assets/images/divine.png', () => state.itemChanged(this.divine())),
    ]);
  }
}