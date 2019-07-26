import 'package:flutter/material.dart';
import '../crafting/item.dart';
import '../crafting/base_item.dart';
import '../crafting/properties.dart';

class CraftingWidget extends StatefulWidget {
  final BaseItem baseItem;
  final List<String> extraTags;

  CraftingWidget({this.baseItem, this.extraTags});

  @override
  State<StatefulWidget> createState() {
    return CraftingWidgetState(baseItem, extraTags);
  }
}

class CraftingWidgetState extends State<CraftingWidget> {
  Item _item;

  CraftingWidgetState(BaseItem baseItem, List<String> extraTags) {
    _item = NormalItem(
        baseItem.name,
        new List(),
        baseItem.implicits,
        baseItem.tags,
        baseItem.weaponProperties,
        baseItem.armourProperties,
        baseItem.itemClass);
    _item.tags.addAll(extraTags);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
