import 'package:flutter/material.dart';
import '../crafting/item.dart';
import '../crafting/base_item.dart';
import '../crafting/properties.dart';

class CraftingWidget extends StatefulWidget {
  final BaseItem baseItem;

  CraftingWidget({this.baseItem});

  @override
  State<StatefulWidget> createState() {
    return CraftingWidgetState(baseItem);
  }
}

class CraftingWidgetState extends State<CraftingWidget> {
  Item _item;

  CraftingWidgetState(BaseItem baseItem) {
    _item = NormalItem(
        baseItem.name,
        new List(),
        baseItem.tags,
        baseItem.weaponProperties,
        baseItem.itemClass);
  }

  @override
  void initState() {
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
                child: _item.getActionsWidget(this)),
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
