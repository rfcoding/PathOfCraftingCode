import 'dart:math';
import 'package:flutter/material.dart';
import 'mod.dart';
import '../repository/mod_repo.dart';
import 'crafting_widget.dart';

abstract class Item {
  String name;
  List<Mod> mods;
  List<String> tags;
  Properties properties;
  String itemClass;
  Random rng = new Random();

  Item(String name,
    List<Mod> mods,
    List<String> tags,
    Properties properties,
    String itemClass) {
    this.name = name;
    this.mods = mods;
    this.tags = tags;
    this.properties = properties;
    this.itemClass = itemClass;
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

  Widget getActionsWidget(CraftingWidgetState state);

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
            name,
            style: TextStyle(color: getTextColor(), fontSize: 30),
          ),
        ));
  }

  Widget getStatWidget() {
    List<String> statStrings = List();
    //TODO: split implementation for item types, e.g. weapon, armour etc
    // Added damage STAT = local_minimum_added_physical_damage &
    // local_maximum_added_physical_damage
    // Attack speed STAT = local_attack_speed_+%
    // Inc phys damage STAT = local_physical_damage_+%
    int addedMinimumPhysicalDamage = properties.physicalDamageMin;
    int addedMaximumPhysicalDamage = properties.physicalDamageMax;
    int increasedPhysicalDamage = 130;
    int increasedAttackSpeed = 100;
    int increasedCriticalStrikeChange = 100;

    for (Stat stat in mods.map((mod) => mod.stats).expand((stat) => stat)) {
      switch (stat.id) {
        case "local_minimum_added_physical_damage":
          addedMinimumPhysicalDamage += stat.value;
          break;
        case "local_maximum_added_physical_damage":
          addedMaximumPhysicalDamage += stat.value;
          break;
        case "local_attack_speed_+%":
          increasedAttackSpeed += stat.value;
          break;
        case "local_physical_damage_+%":
          increasedPhysicalDamage += stat.value;
          break;
        case "local_critical_strike_chance_+%":
          increasedCriticalStrikeChange += stat.value;
          break;
        default:
          break;
      }
    }

    String addedMinPhysString = "${(addedMinimumPhysicalDamage * increasedPhysicalDamage / 100).toStringAsFixed(0)}";
    String addedMaxPhysString = "${(addedMaximumPhysicalDamage * increasedPhysicalDamage / 100).toStringAsFixed(0)}";
    String attacksPerSecondString = "${( (increasedAttackSpeed/100) * (1000/properties.attackTime)).toStringAsFixed(2)}";
    String criticalStrikeChanceString = "${((properties.criticalStrikeChance/100) * (increasedCriticalStrikeChange / 100)).toStringAsFixed(2)}";
    statStrings.add(itemClass);
    statStrings.add("Quality 30%");
    statStrings.add("Physical Damage: $addedMinPhysString-$addedMaxPhysString");
    statStrings.add("Critical Strike Chance: $criticalStrikeChanceString%");
    statStrings.add("Attacks per second: $attacksPerSecondString");
    statStrings.add("Weapon Range: ${properties.range}");
    List<Widget> children = statStrings.map(itemDescriptionRow).toList();
    return Column(children: children);
  }

  void reroll();
  void addMod();
  void addPrefix() {
    Mod prefix = ModRepository.instance.getPrefix(this);
    print("Adding Prefix: ${prefix.debugString()}");
    mods.add(prefix);
  }

  void addSuffix() {
    Mod suffix = ModRepository.instance.getSuffix(this);
    print("Adding Suffix: ${suffix.debugString()}");
    mods.add(suffix);
  }
  Color getTextColor();
  Color getBorderColor();
  Color getBoxColor();
}

class NormalItem extends Item {
  NormalItem(
      String name,
      List<Mod> mods,
      List<String> tags,
      Properties properties,
      String itemClass)
      : super(name, mods, tags, properties, itemClass);


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

  @override
  void addMod() {
    // TODO: implement addMod
  }

  MagicItem transmute() {
    MagicItem item = MagicItem(this.name, new List(), this.tags, this.properties, this.itemClass);
    item.reroll();
    return item;
  }

  RareItem alchemy() {
    RareItem item = RareItem(this.name, new List(), this.tags, this.properties, this.itemClass);
    item.reroll();
    return item;
  }

  @override
  Widget getActionsWidget(CraftingWidgetState state) {
    return Row(children: <Widget>[
      RaisedButton(
        child: Text("Trans"),
        onPressed: () {
          state.itemChanged(this.transmute());
        },
      ),
      RaisedButton(
        child: Text("Alch"),
        onPressed: () {
          state.itemChanged(this.alchemy());
        },
      ),
    ],
    );
  }
}

class MagicItem extends Item {
  MagicItem(
      String name,
      List<Mod> mods,
      List<String> tags,
      Properties properties,
      String itemClass)
      : super(name, mods, tags, properties, itemClass);

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
    for (int i = 0; i < nPrefixes; i++) {
      addPrefix();
    }
    for (int i = 0; i < nSuffixes; i++) {
      addSuffix();
    }
  }

  RareItem regal() {
    RareItem item = RareItem(this.name, this.mods, this.tags, this.properties, this.itemClass);
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
    return NormalItem(this.name, new List(), this.tags, this.properties, this.itemClass);
  }

  @override
  void addMod() {
    // Max mods
    if (mods.length == 2) {
      return;
    }
    int nPrefixes = mods.where((mod) => mod.generationType == "prefix").toList().length;
    if (nPrefixes == 1) {
      addSuffix();
    } else {
      addPrefix();
    }
  }

  @override
  Widget getActionsWidget(CraftingWidgetState state) {
    return Row(children: <Widget>[
      RaisedButton(
        child: Text("Scour"),
        onPressed: () {
          state.itemChanged(this.scour());
        },
      ),
      RaisedButton(
        child: Text("Alt"),
        onPressed: () {
          state.itemChanged(this.alteration());
        },
      ),
      RaisedButton(
        child: Text("Aug"),
        onPressed: () {
          state.itemChanged(this.augment());
        },
      ),
      RaisedButton(
        child: Text("Regal"),
        onPressed: () {
          state.itemChanged(this.regal());
        },
      ),
    ],

    );
  }
}

class RareItem extends Item {
  Color textColor = Color(0xFFFFFC8A);
  Color boxColor = Color(0xFF201C1C);
  Color borderColor = Color(0xFF89672B);

  RareItem(
      String name,
      List<Mod> mods,
      List<String> tags,
      Properties properties,
      String itemClass)
      : super(name, mods, tags, properties, itemClass);

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
    for (int i = 0; i < nPrefixes; i++) {
      addPrefix();
    }
    for (int i = 0; i < nSuffixes; i++) {
      addSuffix();
    }
  }

  NormalItem scour() {
    return NormalItem(this.name, new List(), this.tags, this.properties, this.itemClass);
  }

  RareItem exalt() {
    addMod();
    return this;
  }

  RareItem chaos() {
    reroll();
    return this;
  }

  @override
  void addMod() {
    // Max mods
    if (mods.length == 6) {
      return;
    }
    int nPrefixes = mods.where((mod) => mod.generationType == "prefix").toList().length;
    int nSuffixes = mods.where((mod) => mod.generationType == "suffix").toList().length;
    if (nPrefixes == 3) {
      addSuffix();
    } else if (nSuffixes == 3){
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
    return Row(children: <Widget>[
      RaisedButton(
        child: Text("Scour"),
        onPressed: () {
          state.itemChanged(this.scour());
        },
      ),
      RaisedButton(
        child: Text("Chaos"),
        onPressed: () {
          state.itemChanged(this.chaos());
        },
      ),
      RaisedButton(
        child: Text("Exalt"),
        onPressed: () {
          state.itemChanged(this.exalt());
        },
      )
    ],

    );
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
