import 'dart:math';
import 'package:flutter/material.dart';
import '../mod.dart';
import '../../repository/mod_repo.dart';
import '../../widgets/crafting_widget.dart';
import '../properties.dart';
import '../fossil.dart';
import 'rare_item.dart';

abstract class Item {
  String name;
  List<Mod> prefixes;
  List<Mod> suffixes;
  List<Mod> implicits;
  List<String> tags;
  WeaponProperties weaponProperties;
  ArmourProperties armourProperties;
  String itemClass;

  Random rng = new Random();
  Color statTextColor = Color(0xFF677F7F);
  Color modColor = Color(0xFF959AF6);
  double modFontSize = 16;

  Item(String name,
      List<Mod> prefixes,
      List<Mod> suffixes,
      List<Mod> implicits,
      List<String> tags,
      WeaponProperties weaponProperties,
      ArmourProperties armourProperties,
      String itemClass) {
    this.name = name;
    this.prefixes = prefixes;
    this.suffixes = suffixes;
    this.tags = tags;
    this.weaponProperties = weaponProperties;
    this.armourProperties = armourProperties;
    this.itemClass = itemClass;
    this.implicits = implicits;
  }

  List<Mod> getMods() {
    List<Mod> mods = List();
    mods.addAll(prefixes);
    mods.addAll(suffixes);
    return mods;
  }

  void clearMods() {
    prefixes.clear();
    suffixes.clear();
  }

  Item divine() {
    for (Mod mod in prefixes) {
      mod.rerollStatValues();
    }
    for (Mod mod in suffixes) {
      mod.rerollStatValues();
    }
    return this;
  }

  void addPrefix({List<Fossil> fossils: const []}) {
    Mod prefix = ModRepository.instance.getPrefix(this, fossils);
    print("Adding Prefix: ${prefix.debugString()}");
    prefix.rerollStatValues();
    prefixes.add(prefix);
  }

  void addSuffix({List<Fossil> fossils: const []}) {
    Mod suffix = ModRepository.instance.getSuffix(this, fossils);
    print("Adding Suffix: ${suffix.debugString()}");
    suffix.rerollStatValues();
    suffixes.add(suffix);
  }

  void reroll({List<Fossil> fossils: const[]});

  void addRandomMod();

  RareItem useFossils(List<Fossil> fossils);

  Item scourSuffixes();
  Item scourPrefixes();

  @override
  String toString() {
    return name;
  }

  List<String> getStatStrings() {
    return getMods()
        .map((mod) => mod.getStatStrings())
        .expand((string) => string)
        .toList();
  }

  List<String> getImplicitStrings() {
    return implicits
        .where((mod) => mod != null)
        .map((mod) => mod.getStatStrings())
        .expand((string) => string)
        .toList();
  }

  bool alreadyHasModGroup(Mod mod) {
    for (Mod ownMod in getMods()) {
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
      getImplicitWidget(),
      divider(),
      getModListWidget(),
    ]);
  }

  Widget divider() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 0),
          child: Divider(height: 8, color: getBorderColor()),
        )
      )
    );
  }

  Widget getActionsWidget(CraftingWidgetState state);

  Widget getModListWidget() {
    List<Widget> children = getStatStrings().map(statRow).toList();
    return Column(children: children);
  }

  Widget statRow(String text) {
    return itemRow(Text(
      text,
      style: TextStyle(color: modColor, fontSize: modFontSize),
      textAlign: TextAlign.center,
    ));
  }

  Widget itemModRow(String text) {
    return itemRow(Text(
      text,
      style: TextStyle(color: statTextColor, fontSize: modFontSize),
      textAlign: TextAlign.center,
    ));
  }

  Widget itemRow(Widget child) {
    return Container(
      color: Colors.black,
      child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: child,
          )),
    );
  }

  Widget getTitleWidget() {
    return Container(
        height: 36,
        decoration: new BoxDecoration(
            color: getBoxColor(),
            border: new Border.all(color: getBorderColor(), width: 3)
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(color: getTextColor(), fontSize: 24),
          ),
        ));
  }

  Widget imageButton(String assetPath, VoidCallback callback) {
    return InkWell(
      onTap: callback,
      child: Container(
          padding: EdgeInsets.all(8.0),
          child: Image.asset(assetPath, height: 36, width: 36,)
      ),
    );
  }

  Widget getStatWidget() {
    if (weaponProperties != null) {
      return weaponStatWidget();
    } else if (armourProperties != null) {
      return armourStatWidget();
    } else {
      return Column();
    }
  }

  TextSpan commaSpan() {
    return TextSpan(text: ", ", style: TextStyle(color: statTextColor, fontSize: modFontSize));
  }

  TextSpan coloredText(String text, Color color) {
    return TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: modFontSize));
  }

  RichText statWithColoredChildren(String text, List<TextSpan> children) {
    return RichText(
        text: TextSpan(text: text,
            style: TextStyle(color: statTextColor, fontSize: modFontSize),
            children: children));
  }

  Widget getImplicitWidget() {
    if (implicits == null || implicits.isEmpty) {
      return Column();
    }
    List<Widget> children = getImplicitStrings().map(statRow).toList();
    return Column(children: children);
  }

  Widget weaponStatWidget() {
    List<Widget> statWidgets = List();
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

    List<Mod> allMods = List();
    allMods.addAll(getMods());
    allMods.addAll(implicits);
    for (Stat stat in allMods.map((mod) => mod.stats).expand((stat) => stat)) {
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

    addedMinimumPhysicalDamage =  (addedMinimumPhysicalDamage * increasedPhysicalDamage / 100).floor();
    addedMaximumPhysicalDamage = (addedMaximumPhysicalDamage * increasedPhysicalDamage / 100).floor();
    double attacksPerSecond = (increasedAttackSpeed/100) * (1000/weaponProperties.attackTime);
    var pDPS = (addedMinimumPhysicalDamage + addedMaximumPhysicalDamage) / 2 * attacksPerSecond;
    var eDPS = (
        addedMinimumFireDamage + addedMaximumFireDamage +
        addedMinimumColdDamage + addedMaximumColdDamage +
        addedMinimumLightningDamage + addedMaximumLightningDamage)
        / 2 * attacksPerSecond;
    var cDPS = (addedMinimumChaosDamage + addedMaximumChaosDamage) / 2 * attacksPerSecond;
    var DPS = pDPS + eDPS + cDPS;
    String addedMinimumPhysString = "${addedMinimumPhysicalDamage.toStringAsFixed(0)}";
    String addedMaximumPhysString = "${addedMaximumPhysicalDamage.toStringAsFixed(0)}";
    String attacksPerSecondString = "${attacksPerSecond.toStringAsFixed(2)}";
    String criticalStrikeChanceString = "${((weaponProperties.criticalStrikeChance/100) * (increasedCriticalStrikeChange / 100)).toStringAsFixed(2)}";
    statWidgets.add(itemModRow(itemClass));
    statWidgets.add(itemRow(statWithColoredChildren("Quality: ", [coloredText("+30%", modColor)])));
    statWidgets.add(itemRow(statWithColoredChildren("Physical Damage: ", [coloredText("$addedMinimumPhysString-$addedMaximumPhysString", modColor)])));
    List<TextSpan> elementalDamageSpans = List();
    if (addedMinimumFireDamage > 0) {
      elementalDamageSpans.add(coloredText("$addedMinimumFireDamage-$addedMaximumFireDamage", Colors.red));
    }
    if (addedMinimumColdDamage > 0) {
      if (elementalDamageSpans.isNotEmpty) {
        elementalDamageSpans.add(commaSpan());
      }
      elementalDamageSpans.add(coloredText("$addedMinimumColdDamage-$addedMaximumColdDamage", Colors.cyan));
    }
    if (addedMinimumLightningDamage > 0) {
      if (elementalDamageSpans.isNotEmpty) {
        elementalDamageSpans.add(commaSpan());
      }
      elementalDamageSpans.add(coloredText("$addedMinimumLightningDamage-$addedMaximumLightningDamage", Colors.yellow));
    }
    if (elementalDamageSpans.isNotEmpty) {
      statWidgets.add(itemRow(statWithColoredChildren("Elemental Damage: ", elementalDamageSpans)));
    }
    if (addedMinimumChaosDamage > 0) {
      statWidgets.add(itemRow(statWithColoredChildren("Chaos Damage: ", [
        coloredText("$addedMinimumChaosDamage-$addedMaximumChaosDamage",
            Colors.pink[300])
      ])));
    }

    statWidgets.add(itemRow(statWithColoredChildren("Critical Strike Chance: ", [coloredText("$criticalStrikeChanceString%", increasedCriticalStrikeChange > 100 ? modColor : statTextColor)])));
    statWidgets.add(itemRow(statWithColoredChildren("Attacks per Second: ", [coloredText("$attacksPerSecondString", increasedAttackSpeed > 100 ? modColor : statTextColor)])));

    statWidgets.add(dpsWidget(pDPS, eDPS, DPS));
    return Column(children: statWidgets);
  }

  Widget dpsWidget(double pDps, double eDps, double dps) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text("DPS: ${dps.toStringAsFixed(1)}", style: TextStyle(color: statTextColor, fontSize: 16)),
        Text("pDPS: ${pDps.toStringAsFixed(1)}", style: TextStyle(color: statTextColor, fontSize: 16)),
        Text("eDPS: ${eDps.toStringAsFixed(1)}", style: TextStyle(color: statTextColor, fontSize: 16)),
      ],
    );
  }

  Widget armourStatWidget() {
    List<String> statStrings = List();
    int baseArmour = armourProperties.armour;
    int baseEvasion = armourProperties.evasion;
    int baseEnergyShield = armourProperties.energyShield;
    int armourMultiplier = 130;
    int evasionMultiplier = 130;
    int energyShieldMultiplier = 130;

    List<Mod> allMods = List();
    allMods.addAll(getMods());
    allMods.addAll(implicits);
    for (Stat stat in allMods.map((mod) => mod.stats).expand((stat) => stat)) {
      switch (stat.id) {
        case "local_base_evasion_rating":
          baseEvasion += stat.value;
          break;
        case "local_evasion_rating_+%":
          evasionMultiplier += stat.value;
          break;
        case "local_energy_shield":
          baseEnergyShield += stat.value;
          break;
        case "local_energy_shield_+%":
          energyShieldMultiplier += stat.value;
          break;
        case "local_base_physical_damage_reduction_rating":
          baseArmour += stat.value;
          break;
        case "local_physical_damage_reduction_rating_+%":
          armourMultiplier += stat.value;
          break;
        default:
          break;
      }
    }

    statStrings.add(itemClass);
    statStrings.add("Quality 30%");

    if (baseArmour != null) {
      var totalArmour = baseArmour * armourMultiplier / 100;
      if (totalArmour > 0) {
        statStrings.add("Armour: ${totalArmour.toStringAsFixed(0)}");
      }
    }

    if (baseEvasion != null) {
      var totalEvasion = baseEvasion * evasionMultiplier / 100;
      if (totalEvasion > 0) {
        statStrings.add("Evasion: ${totalEvasion.toStringAsFixed(0)}");
      }
    }

    if (baseEnergyShield != null) {
      var totalEnergyShield = baseEnergyShield * energyShieldMultiplier / 100;
      if (totalEnergyShield > 0) {
        statStrings.add("Energy Shield: ${totalEnergyShield.toStringAsFixed(0)}");
      }
    }

    List<Widget> children = statStrings.map(itemModRow).toList();
    return Column(children: children);
  }

  Color getTextColor();
  Color getBorderColor();
  Color getBoxColor();
}
