import 'package:flutter/material.dart';
import 'item.dart';

class CraftingWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CraftingWidgetState();
  }
}

class CraftingWidgetState extends State<CraftingWidget> {
  //TODO: replace with JSON
  Item _item = RareItem(
      "Exquisite Blade",
      new List(),
      [
        "sword",
        "two_hand_weapon",
        "twohand",
        "weapon",
        "2h_sword_elder"
      ],
      Properties(
          attackTime: 741,
          criticalStrikeChance: 600,
          physicalDamageMax: 94,
          physicalDamageMin: 56,
          range: 13),
      "Two Hand Sword");

  @override
  void initState() {
    _item.reroll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crafting Lobby"),
      ),
      body: Column(
        children: <Widget>[
          _item.getItemWidget(),

          Expanded(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: _item.getActionsWidget(this)
            ),
          ),
          //)
        ],
      ),
    );
  }

  void itemChanged(Item item) {
    setState(() {
      _item = item;
    });
  }
}
