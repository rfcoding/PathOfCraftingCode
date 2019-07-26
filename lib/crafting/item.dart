import 'dart:math';
import 'package:flutter/material.dart';
import 'mod.dart';
import '../repository/mod_repo.dart';
import '../widgets/crafting_widget.dart';
import 'properties.dart';

abstract class Item {
  String name;
  List<Mod> mods;
  List<String> tags;
  WeaponProperties weaponProperties;
  String itemClass;
  Random rng = new Random();

  Item(String name,
    List<Mod> mods,
    List<String> tags,
    WeaponProperties properties,
    String itemClass) {
    this.name = name;
    this.mods = mods;
    this.tags = tags;
    this.weaponProperties = properties;
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
    int addedMinimumPhysicalDamage = weaponProperties.physicalDamageMin;
    int addedMaximumPhysicalDamage = weaponProperties.physicalDamageMax;
    int addedMinimumColdDamage = 0;
    int addedMaximumColdDamage = 0;
    int addedMinimumFireDamage = 0;
    int addedMaximumFireDamage = 0;
    int addedMinimumLightningDamage = 0;
    int addedMaximumLightningDamage = 0;
    int addedMinimumChaosDamage = 0;
    int addedMaximumChaosDamage = 0;
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
        case "local_minimum_added_fire_damage":
          addedMinimumFireDamage += stat.value;
          break;
        case "local_maximum_added_fire_damage":
          addedMaximumFireDamage += stat.value;
          break;
        case "local_minimum_added_cold_damage":
          addedMinimumColdDamage += stat.value;
          break;
        case "local_maximum_added_cold_damage":
          addedMaximumColdDamage += stat.value;
          break;
        case "local_minimum_added_lightning_damage":
          addedMinimumLightningDamage += stat.value;
          break;
        case "local_maximum_added_lightning_damage":
          addedMaximumLightningDamage += stat.value;
          break;
        case "local_minimum_added_chaos_damage":
          addedMinimumChaosDamage += stat.value;
          break;
        case "local_maximum_added_chaos_damage":
          addedMaximumChaosDamage += stat.value;
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

    String addedMinimumPhysString = "${(addedMinimumPhysicalDamage * increasedPhysicalDamage / 100).toStringAsFixed(0)}";
    String addedMaximumPhysString = "${(addedMaximumPhysicalDamage * increasedPhysicalDamage / 100).toStringAsFixed(0)}";
    String attacksPerSecondString = "${( (increasedAttackSpeed/100) * (1000/weaponProperties.attackTime)).toStringAsFixed(2)}";
    String criticalStrikeChanceString = "${((weaponProperties.criticalStrikeChance/100) * (increasedCriticalStrikeChange / 100)).toStringAsFixed(2)}";
    statStrings.add(itemClass);
    statStrings.add("Quality 30%");
    statStrings.add("Physical Damage: $addedMinimumPhysString-$addedMaximumPhysString");
    if (addedMinimumFireDamage > 0) {
      statStrings.add("Fire Damage: $addedMinimumFireDamage-$addedMaximumFireDamage");
    }
    if (addedMinimumColdDamage > 0) {
      statStrings.add("Cold Damage: $addedMinimumColdDamage-$addedMaximumColdDamage");
    }
    if (addedMinimumLightningDamage > 0) {
      statStrings.add("Lightning Damage: $addedMinimumLightningDamage-$addedMaximumLightningDamage");
    }
    if (addedMinimumChaosDamage > 0) {
      statStrings.add("Chaos Damage: $addedMinimumChaosDamage-$addedMaximumChaosDamage");
    }

    statStrings.add("Critical Strike Chance: $criticalStrikeChanceString%");
    statStrings.add("Attacks per second: $attacksPerSecondString");
    statStrings.add("Weapon Range: ${weaponProperties.range}");
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
      WeaponProperties properties,
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
    MagicItem item = MagicItem(this.name, new List(), this.tags, this.weaponProperties, this.itemClass);
    item.reroll();
    return item;
  }

  RareItem alchemy() {
    RareItem item = RareItem(this.name, new List(), this.tags, this.weaponProperties, this.itemClass);
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
      WeaponProperties properties,
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
    RareItem item = RareItem(this.name, this.mods, this.tags, this.weaponProperties, this.itemClass);
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
    return NormalItem(this.name, new List(), this.tags, this.weaponProperties, this.itemClass);
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
      WeaponProperties properties,
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
    return NormalItem(this.name, new List(), this.tags, this.weaponProperties, this.itemClass);
  }

  RareItem exalt() {
    addMod();
    return this;
  }

  RareItem chaos() {
    reroll();
    return this;
  }

  RareItem annulment() {
    if (mods.isEmpty) {
      return this;
    }
    int annulIndex = rng.nextInt(mods.length);
    mods.removeAt(annulIndex);
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
      ),
      RaisedButton(
        child: Text("Annul"),
        onPressed: () {
          state.itemChanged(this.annulment());
        },
      )
    ],

    );
  }
}
