import 'dart:math';
import 'package:flutter/material.dart';
import 'mod.dart';
import '../repository/mod_repo.dart';

abstract class Item {
  String name;
  List<Mod> mods;
  List<String> tags;
  Properties properties;
  String itemClass;
  Random rng = new Random();

  Item() {
    this.name = "Exquisite Blade";
    mods = new List();
    tags = [
      "bow",
      "bow_elder",
      "ranged",
      "weapon",
    ];

    properties = Properties(
        attackTime: 741,
        criticalStrikeChance: 600,
        physicalDamageMax: 94,
        physicalDamageMin: 56,
        range: 13);
    itemClass = "Two Hand Sword";
    reroll();
  }

  List<Mod> getMods() {
    return mods;
  }

  @override
  String toString() {
    return name;
  }

  List<String> getStatStrings() {
    return mods
        .map((mod) => mod.getStatStrings())
        .expand((string) => string)
        .toList();
  }

  bool alreadyHasModGroup(Mod mod) {
    for (Mod ownMod in mods) {
      if (ownMod.group == mod.group) {
        return true;
      }
    }
    return false;
  }

  Widget getItemWidget() {
    return Column(children: <Widget>[
      getTitleWidget(),
      getStatWidget(),
      getModListWidget(),
    ]);
  }

  Widget getModListWidget() {
    List<Widget> children = getStatStrings().map(statRow).toList();
    return Column(children: children);
  }

  Widget statRow(String text) {
    return Container(
      color: Colors.black,
      child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              text,
              style: TextStyle(color: Color(0xFF959AF6), fontSize: 20),
              textAlign: TextAlign.center,
            ),
          )),
    );
  }

  Widget itemDescriptionRow(String text) {
    return Container(
      color: Colors.black,
      child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              text,
              style: TextStyle(color: Color(0xFF677F7F), fontSize: 20),
              textAlign: TextAlign.center,
            ),
          )),
    );
  }

  Widget getTitleWidget() {
    return Container(
        height: 50,
        decoration: new BoxDecoration(
            color: getBoxColor(),
            border: new Border.all(color: getBorderColor(), width: 3)
        ),
        child: Center(
          child: Text(
            name.toUpperCase(),
            style: TextStyle(color: getTextColor(), fontSize: 30),
          ),
        ));
  }

  Widget getStatWidget() {
    List<String> statStrings = List();
    statStrings.add(itemClass);
    statStrings.add("Quality 20%");
    statStrings.add("Physical Damage: ${properties.physicalDamageMin}-${properties.physicalDamageMax}");
    statStrings.add("Critical Strike Chance: ${(properties.criticalStrikeChance/100).toStringAsFixed(2)}%");
    statStrings.add("Attacks per second: ${(1000/properties.attackTime).toStringAsFixed(2)}");
    statStrings.add("Weapon Range: ${properties.range}");
    List<Widget> children = statStrings.map(itemDescriptionRow).toList();
    return Column(children: children);
  }

  void reroll();
  Color getTextColor();
  Color getBorderColor();
  Color getBoxColor();
}

class NormalItem extends Item {

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
  void reroll() {
    //Do nothing
  }
}

class MagicItem extends Item {

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
  void reroll() {
    mods.clear();
    int nPrefixes = rng.nextInt(2);
    int nSuffixes = max(rng.nextInt(2), 1 - nPrefixes);
    print("Prefixes: $nPrefixes, Suffixes: $nSuffixes");
    for (int i = 0; i < nPrefixes; i++) {
      Mod prefix = ModRepository.instance.getPrefix(this);
      print("Prefix: ${prefix.debugString()}");
      mods.add(prefix);
    }

    for (int i = 0; i < nSuffixes; i++) {
      Mod suffix = ModRepository.instance.getSuffix(this);
      print("Suffix: ${suffix.debugString()}");
      mods.add(suffix);
    }
  }

}

class RareItem extends Item {
  Color textColor = Color(0xFFFFFC8A);
  Color boxColor = Color(0xFF201C1C);
  Color borderColor = Color(0xFF89672B);

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
  void reroll() {
    mods.clear();
    int nPrefixes = rng.nextInt(3) + 1;
    int nSuffixes = max((rng.nextInt(3) + 1), 4 - nPrefixes);
    print("Prefixes: $nPrefixes, Suffixes: $nSuffixes");
    for (int i = 0; i < nPrefixes; i++) {
      Mod prefix = ModRepository.instance.getPrefix(this);
      print("Prefix: ${prefix.debugString()}");
      mods.add(prefix);
    }

    for (int i = 0; i < nSuffixes; i++) {
      Mod suffix = ModRepository.instance.getSuffix(this);
      print("Suffix: ${suffix.debugString()}");
      mods.add(suffix);
    }
  }

}

class Properties {
  int attackTime;
  int criticalStrikeChance;
  int physicalDamageMax;
  int physicalDamageMin;
  int range;

  Properties(
      {this.attackTime,
      this.criticalStrikeChance,
      this.physicalDamageMax,
      this.physicalDamageMin,
      this.range});
}
