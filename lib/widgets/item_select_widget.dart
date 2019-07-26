import 'package:flutter/material.dart';

import '../crafting/base_item.dart';
import '../repository/item_repo.dart';
import 'crafting_widget.dart';

class ItemSelectWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ItemSelectState();
  }
}

class ItemSelectState extends State<ItemSelectWidget> {
  BaseItem _baseItem;
  String _baseItemClass = "Amulet";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select item"),
      ),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return Center(
      child: Column(
        children: <Widget>[
          //Select item class
          Text("Select item type"),
          _itemClassDropdownWidget(),
          Text("Select item"),
          _baseItemDropdownWidget(),
          Text("Selected item: $_baseItem"),
          Expanded(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                    onPressed: _startCrafting,
                    child: Text("Start Crafting!"))
            ),
          )
        ],
      ),
    );
  }

  Widget _itemClassDropdownWidget() {
    return DropdownButton<String>(
      hint: Text(_baseItemClass),
      items: ItemRepository.instance
          .getItemBaseTypes()
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String value) {
        setState(() {
          _baseItemClass = value;
        });
      },
    );
  }

  Widget _baseItemDropdownWidget() {
    return DropdownButton<BaseItem> (
      hint: Text("$_baseItem"),
      onChanged: (BaseItem value) {
        setState(() {
          _baseItem = value;
        });
      },
      items: ItemRepository.instance
          .getBaseItemsForClass(_baseItemClass)
          .map<DropdownMenuItem<BaseItem>>((BaseItem value) {
        return DropdownMenuItem<BaseItem>(
          value: value,
          child: Text(value.name),
        );
      }).toList(),
    );
  }

  void _startCrafting() {
    if (_baseItem == null) {
      print("No base item selected");
    }
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CraftingWidget(baseItem: _baseItem)));

  }
}
