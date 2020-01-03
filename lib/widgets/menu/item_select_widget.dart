import 'package:flutter/material.dart';
import 'package:poe_clicker/crafting/item_class.dart';
import 'package:poe_clicker/widgets/menu/influence_select_dialog.dart';

import '../../crafting/base_item.dart';
import '../../repository/item_repo.dart';
import '../craft/crafting_widget.dart';
import '../utils.dart';

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
  List<String> _selectedInfluences = List();
  int itemLevel;

  @override
  void initState() {
    _baseItemClass = ItemRepository.instance.getItemClasses()[0];
    _baseItem =
        ItemRepository.instance.getBaseItemsForClass(_baseItemClass.id)[0];
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
              Text("Influence types", style: TextStyle(fontSize: 16)),
              _influenceBase(),
              SizedBox(height: 24),
              Text("ItemLevel", style: TextStyle(fontSize: 16)),
              _itemLevelForm(),
              SizedBox(height: 24),
              RaisedButton(
                  onPressed: _startCrafting, child: Text("Start Crafting!")),
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
          _baseItem = ItemRepository.instance
              .getBaseItemsForClass(_baseItemClass.id)[0];
        });
      },
    );
  }

  Widget _baseItemDropdownWidget() {
    return DropdownButton<BaseItem>(
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
    if (_baseItem == null) {
      return List();
    }

    final itemClass = ItemRepository.instance.itemClassMap[_baseItem.itemClass];
    if (itemClass.elderTag == null && itemClass.shaperTag == null)
      return List();

    List<String> result = List();
    if (itemClass.elderTag != null && itemClass.shaperTag != null) {
      result.addAll(
          ["Crusader", "Elder", "Hunter", "Redeemer", "Shaper", "Warlord"]);
    }

    return result;
  }

  Widget _influenceBase() {
    final options = _getInfluenceOptions();
    if (options.isEmpty) {
      return Text("Not possible for this item",
          style: Theme.of(context).textTheme.caption);
    }
    return Column(
      children: <Widget>[
        SizedBox(height: 4),
        Text(_selectedInfluences.isEmpty
            ? "[None]"
            : _selectedInfluences.toString()),
        SizedBox(height: 8),
        RichText(
            text: clickableText("Select", () => _showInfluenceDialog(options))),

      ],
    );
  }

  void _showInfluenceDialog(List<String> options) {
    InfluenceSelectDialog.showInfluenceSelectDialog(
            context, _selectedInfluences, options)
        .then((influences) {
      if (influences != null) {
        setState(() {
          _selectedInfluences = influences;
        });
      }
    });
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
          return value > 0 && value <= 100
              ? null
              : "Itemlevel not between 1 and 100";
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
    if (_selectedInfluences.isNotEmpty) {
      for (String influence in _selectedInfluences) {
        String influenceTag = mapNameToInfluenceForItemClass(influence);
        print("Influence: $influence tag: $influenceTag");
        if (influenceTag != null) {
          extraTags.add(influenceTag);
        }
      }
    }
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _baseItem.itemLevel = itemLevel;

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  CraftingWidget(baseItem: _baseItem, extraTags: extraTags)));
    }
  }

  String mapNameToInfluenceForItemClass(String influenceName) {
    List<String> possibleShaperOrElderOptions = _getInfluenceOptions();
    switch (influenceName) {
      case 'Shaper':
        if (possibleShaperOrElderOptions.contains('Shaper')) {
          return ItemRepository.instance
              .getShaperTagForItemClass(_baseItem.itemClass);
        }
        break;
      case 'Elder':
        if (possibleShaperOrElderOptions.contains('Elder')) {
          return ItemRepository.instance
              .getElderTagForItemClass(_baseItem.itemClass);
        }
        break;
      case 'Crusader':
        //Basilisk
        if (possibleShaperOrElderOptions.contains('Crusader')) {
          return ItemRepository.instance
              .getCrusaderTagForItemClass(_baseItem.itemClass);
        }
        break;
      case 'Hunter':
        //Crusader
        if (possibleShaperOrElderOptions.contains('Hunter')) {
          return ItemRepository.instance
              .getHunterTagForItemClass(_baseItem.itemClass);
        }
        break;
      case 'Redeemer':
        //Eyrie
        if (possibleShaperOrElderOptions.contains('Redeemer')) {
          return ItemRepository.instance
              .getRedeemerTagForItemClass(_baseItem.itemClass);
        }
        break;
      case 'Warlord':
        //Conqueror
        if (possibleShaperOrElderOptions.contains('Warlord')) {
          return ItemRepository.instance
              .getWarlordTagForItemClass(_baseItem.itemClass);
        }
        break;
      case 'None':
      default:
        return null;
        break;
    }
    return null;
  }
}
