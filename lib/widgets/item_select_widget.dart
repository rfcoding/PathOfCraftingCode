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
  String _baseItemClass;
  String _shaperOrElder = "None";

  @override
  void initState() {
    _baseItemClass = ItemRepository.instance.getItemBaseTypes()[0];
    _baseItem = ItemRepository.instance.getBaseItemsForClass(_baseItemClass)[0];
    super.initState();
  }
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
          SizedBox(height: 24),
          Text("Select item type", style: TextStyle(fontSize: 16)),
          _itemClassDropdownWidget(),
          SizedBox(height: 24),
          Text("Select item", style: TextStyle(fontSize: 16)),
          _baseItemDropdownWidget(),
          SizedBox(height: 24),
          Text("Shaper or Elder", style: TextStyle(fontSize: 16)),
          _shaperOrElderBase(),
          Text("Selected item: ${_shaperOrElder != "None"? _shaperOrElder:""} $_baseItem"),
          Expanded(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                    onPressed: _startCrafting,
                    child: Text("Start Crafting!"))
            ),
          ),
          SizedBox(height: 12),
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
          _baseItem = ItemRepository.instance.getBaseItemsForClass(_baseItemClass)[0];
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

  Widget _shaperOrElderBase() {
    return DropdownButton<String> (
      hint: Text("$_shaperOrElder"),
      onChanged: (String value) {
        setState(() {
          _shaperOrElder = value;
        });
      },
      items: ['Shaper', 'Elder', 'None']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  void _startCrafting() {
    if (_baseItem == null) {
      print("No base item selected");
    }
    List<String> extraTags = List();
    switch (_shaperOrElder) {
      case 'Shaper':
        extraTags.add(ItemRepository.instance.getShaperTagForItemClass(_baseItem.itemClass));
        break;
      case 'Elder':
        extraTags.add(ItemRepository.instance.getElderTagForItemClass(_baseItem.itemClass));
        break;
      case 'None':
      default:
        break;
    }
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CraftingWidget(baseItem: _baseItem, extraTags: extraTags)));

  }
}
