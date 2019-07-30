import 'package:flutter/material.dart';
import 'item.dart';
import 'magic_item.dart';
import 'rare_item.dart';
import '../mod.dart';
import '../properties.dart';
import '../fossil.dart';
import '../../widgets/crafting_widget.dart';

class NormalItem extends Item {
  NormalItem(String name,
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
  void addMod() {
    // Do nothing
  }

  MagicItem transmute() {
    MagicItem item = MagicItem(
        this.name,
        new List(),
        new List(),
        this.implicits,
        this.tags,
        this.weaponProperties,
        this.armourProperties,
        this.itemClass);
    item.reroll();
    return item;
  }

  RareItem alchemy() {
    RareItem item = RareItem(
        this.name,
        List(),
        List(),
        this.implicits,
        this.tags,
        this.weaponProperties,
        this.armourProperties,
        this.itemClass);
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
        this.itemClass);
    return item.useFossils(fossils);
  }

  @override
  Widget getActionsWidget(CraftingWidgetState state) {
    return Row(children: <Widget>[
      imageButton('assets/images/transmute.png', () => state.itemChanged(this.transmute())),
      imageButton('assets/images/alchemy.png', () => state.itemChanged(this.alchemy()))
    ]);
  }
}