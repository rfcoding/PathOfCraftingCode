import 'package:flutter/material.dart';
import '../crafting/base_item.dart';
import '../crafting/fossil.dart';
import '../crafting/item.dart';
import 'fossil_select_dialog_widget.dart';

class CraftingWidget extends StatefulWidget {
  final BaseItem baseItem;
  final List<String> extraTags;

  CraftingWidget({this.baseItem, this.extraTags});

  @override
  State<StatefulWidget> createState() {
    return CraftingWidgetState();
  }
}

class CraftingWidgetState extends State<CraftingWidget> {
  Item _item;
  List<Fossil> _selectedFossils = List();

  @override
  void initState() {
    _item = NormalItem(
        widget.baseItem.name,
        List(),
        List(),
        widget.baseItem.implicits,
        widget.baseItem.tags,
        widget.baseItem.weaponProperties,
        widget.baseItem.armourProperties,
        widget.baseItem.itemClass);
    _item.tags.addAll(widget.extraTags);
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
          fossilCraftingWidget(),
          //)
        ],
      ),
    );
  }

  Widget fossilCraftingWidget() {
    return Row(
      children: <Widget>[
        RaisedButton(
          child: Text("Use"),
          onPressed: () => itemChanged(_item.useFossils(_selectedFossils)),
        ),
        RaisedButton(
            child: Text("Select Fossils"),
            onPressed: () => FossilSelectDialog.getFossilSelectionDialog(
                context,
                _selectedFossils
                    .map((selectedFossil) => selectedFossil.name)
                    .toList())
                .then((fossils) {
              setState(() {
                _selectedFossils = fossils;
              });
            }))
      ],
    );
  }

  void itemChanged(Item item) {
    setState(() {
      _item = item;
    });
  }
}
