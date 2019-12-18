import 'package:flutter/material.dart';
import 'package:poe_clicker/crafting/item_class.dart';

import '../../crafting/base_item.dart';
import '../../repository/item_repo.dart';
import '../craft/crafting_widget.dart';

class ItemSelectWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ItemSelectState();
  }
}

class ItemSelectState extends State<ItemSelectWidget> {
  final _formKey = GlobalKey<FormState>();

  BaseItem _baseItem;
  ItemClass _baseItemClass;
  String _influenceType = "None";
  int itemLevel;

  @override
  void initState() {
    _baseItemClass = ItemRepository.instance.getItemClasses()[0];
    _baseItem = ItemRepository.instance.getBaseItemsForClass(_baseItemClass.id)[0];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select item to craft"),
      ),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Center(
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
              Text("Influence type", style: TextStyle(fontSize: 16)),
              _influenceBase(),
              SizedBox(height: 24),
              Text("ItemLevel", style: TextStyle(fontSize: 16)),
              _itemLevelForm(),
              SizedBox(height: 24),
              RaisedButton(
                onPressed: _startCrafting,
                child: Text("Start Crafting!")),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemClassDropdownWidget() {
    return DropdownButton<ItemClass>(
      hint: Text(_baseItemClass.name),
      items: ItemRepository.instance
          .getItemClasses()
          .map<DropdownMenuItem<ItemClass>>((ItemClass value) {
        return DropdownMenuItem<ItemClass>(
          value: value,
          child: Text(value.name),
        );
      }).toList(),
      onChanged: (ItemClass value) {
        setState(() {
          _baseItemClass = value;
          _baseItem = ItemRepository.instance.getBaseItemsForClass(_baseItemClass.id)[0];
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
          .getBaseItemsForClass(_baseItemClass.id)
          .map<DropdownMenuItem<BaseItem>>((BaseItem value) {
        return DropdownMenuItem<BaseItem>(
          value: value,
          child: Text(value.name),
        );
      }).toList(),
    );
  }

  List<String> _getInfluenceOptions() {
    if(_baseItem == null) {
      return List();
    }
    
    final itemClass = ItemRepository.instance.itemClassMap[_baseItem.itemClass];
    if(itemClass.elderTag == null && itemClass.shaperTag == null) return List();

    var result = ['None'];
    if(itemClass.elderTag != null && itemClass.shaperTag != null) {
      result.addAll([
        "Crusader",
        "Elder",
        "Hunter",
        "Redeemer",
        "Shaper",
        "Warlord"
      ]);
    }

    return result;
  }

  Widget _influenceBase() {
    final options = _getInfluenceOptions();
    if(options.isEmpty){
      return Text("Not possible for this item", style: Theme.of(context).textTheme.caption);
    }
    return DropdownButton<String> (
      hint: Text("$_influenceType"),
      onChanged: (String value) {
        setState(() {
          _influenceType = value;
        });
      },
      items: options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _itemLevelForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 144.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        onSaved: (input) {
          itemLevel = int.parse(input);
        },
        initialValue: '100',
        validator: (text) {
          if (text.isEmpty) {
            return "No itemlevel selected";
          }
          int value = int.parse(text);
          return value > 0 && value <= 100 ? null : "Itemlevel not between 1 and 100";
        },
        autovalidate: true,
      ),
    );
  }

  void _startCrafting() {
    if (_baseItem == null) {
      print("No base item selected");
    }
    List<String> extraTags = List();
    List<String> possibleShaperOrElderOptions = _getInfluenceOptions();
    switch (_influenceType) {
      case 'Shaper':
        if(possibleShaperOrElderOptions.contains('Shaper')) {
          extraTags.add(ItemRepository.instance.getShaperTagForItemClass(_baseItem.itemClass));
        }
        break;
      case 'Elder':
        if(possibleShaperOrElderOptions.contains('Elder')) {
          extraTags.add(ItemRepository.instance.getElderTagForItemClass(_baseItem.itemClass));
        }
        break;
      case 'Crusader':
        //Basilisk
        if(possibleShaperOrElderOptions.contains('Crusader')) {
          extraTags.add(ItemRepository.instance.getCrusaderTagForItemClass(_baseItem.itemClass));
        }
        break;
      case 'Hunter':
        //Crusader
        if(possibleShaperOrElderOptions.contains('Hunter')) {
          extraTags.add(ItemRepository.instance.getHunterTagForItemClass(_baseItem.itemClass));
        }
        break;
      case 'Redeemer':
        //Eyrie
        if(possibleShaperOrElderOptions.contains('Redeemer')) {
          extraTags.add(ItemRepository.instance.getRedeemerTagForItemClass(_baseItem.itemClass));
        }
        break;
      case 'Warlord':
        //Conqueror
        if(possibleShaperOrElderOptions.contains('Warlord')) {
          extraTags.add(ItemRepository.instance.getWarlordTagForItemClass(_baseItem.itemClass));
        }
        break;
      case 'None':
      default:
        break;
    }
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _baseItem.itemLevel = itemLevel;

      Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) =>
              CraftingWidget(
                  baseItem: _baseItem,
                  extraTags: extraTags
              )
      ));
    }
  }
}
