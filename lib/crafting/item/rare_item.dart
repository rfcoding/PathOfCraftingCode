import 'package:flutter/material.dart';
import 'dart:math';
import 'item.dart';
import 'normal_item.dart';
import 'magic_item.dart';
import '../mod.dart';
import '../properties.dart';
import '../fossil.dart';
import '../../widgets/crafting_widget.dart';

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
    int nPrefixes = rng.nextInt(3) + 1;
    int nSuffixes = max((rng.nextInt(3) + 1), 4 - nPrefixes);
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
        this.itemClass);
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
    if (prefixes.isEmpty) {
      suffixes.removeAt(rng.nextInt(suffixes.length));
    } else if (suffixes.isEmpty) {
      prefixes.removeAt(rng.nextInt(prefixes.length));
    } else {
      if (rng.nextBool()) {
        prefixes.removeAt(rng.nextInt(prefixes.length));
      } else {
        suffixes.removeAt(rng.nextInt(suffixes.length));
      }
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
        name, List(), List(), implicits, tags, weaponProperties, armourProperties, itemClass );
    } else if (suffixes.length == 1) {
      return MagicItem(
          name, List(), suffixes, implicits, tags, weaponProperties, armourProperties, itemClass );
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
          name, List(), List(), implicits, tags, weaponProperties, armourProperties, itemClass );
    } else if (prefixes.length == 1) {
      return MagicItem(
          name, prefixes, List(), implicits, tags, weaponProperties, armourProperties, itemClass );
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