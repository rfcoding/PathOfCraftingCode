import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poe_clicker/crafting/crafting_orb.dart';
import 'package:poe_clicker/crafting/item/item.dart';
import 'package:poe_clicker/crafting/item/rare_item.dart';

import '../utils.dart';
import 'crafting_widget.dart';

class ExaltDialog {
  static Future<CraftingOrb> showExaltDialog(
      BuildContext context, RareItem item, CraftingWidgetState state) async {
    CraftingOrb result = await showDialog(
        context: context,
        builder: (BuildContext context) => exaltDialog(context, item, state));

    return result;
  }

  static Dialog exaltDialog(
      BuildContext context, RareItem item, CraftingWidgetState state) {
    return Dialog(
        backgroundColor: Color(0xFF000000),
        child: Column(
          mainAxisSize: MainAxisSize.min ,
          children: <Widget>[
            Text("Select Exalted Orb"),
            SizedBox(height: 8),
            Container(
              decoration: new BoxDecoration(
                  border: Border.all(color: Color(0xFF433937), width: 3)),
              child: Row(
                children: <Widget>[
                  imageButton(
                      "assets/images/exalted.png",
                      "Exalted Orb",
                      () => applyCraftAndClose(
                          context,
                          () => state.craftingUsedOnItem(
                              item.exalt(), ExaltedOrb()))),
                  imageButton(
                      "assets/images/crusader-exalt.png",
                      "Crusader's Exalted Orb",
                      () => applyCraftAndClose(
                          context,
                          () => state.craftingUsedOnItem(
                              item.crusaderExalt(), ExaltedOrb()))),
                  imageButton(
                      "assets/images/hunter-exalt.png",
                      "Hunter's Exalted Orb",
                      () => applyCraftAndClose(
                          context,
                          () => state.craftingUsedOnItem(
                              item.hunterExalt(), ExaltedOrb()))),
                  imageButton(
                      "assets/images/redeemer-exalt.png",
                      "Redeemer's Exalted Orb",
                      () => applyCraftAndClose(
                          context,
                          () => state.craftingUsedOnItem(
                              item.redeemerExalt(), ExaltedOrb()))),
                  imageButton(
                      "assets/images/warlord-exalt.png",
                      "Warlord's Exalted Orb",
                      () => applyCraftAndClose(
                          context,
                          () => state.craftingUsedOnItem(
                              item.warlordExalt(), ExaltedOrb()))),
                ],
              ),
            ),
          ],
        ));
  }

  static void applyCraftAndClose(BuildContext context, Function function) {
    function();
    Navigator.of(context).pop();
  }
}
