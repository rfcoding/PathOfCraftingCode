import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poe_clicker/crafting/fossil.dart';
import 'package:poe_clicker/crafting/item/item.dart';
import 'package:poe_clicker/crafting/item/rare_item.dart';
import 'package:poe_clicker/crafting/mod.dart';
import 'package:poe_clicker/repository/mod_repo.dart';

import 'craft/fossil_select_dialog_widget.dart';
import 'mod_select_widget.dart';

class ItemLabWidget extends StatefulWidget {
  final Item item;

  ItemLabWidget({@required this.item});

  @override
  State<StatefulWidget> createState() {
    return ItemLabWidgetState();
  }
}

class ItemLabWidgetState extends State<ItemLabWidget> {
  Item _item;
  Item _original;
  bool _advancedMods;
  List<Fossil> _selectedFossils = List();

  @override
  void initState() {
    _item = Item.copy(RareItem.fromItem(
        widget.item, widget.item.prefixes, widget.item.suffixes));
    _original = Item.copy(RareItem.fromItem(
        widget.item, widget.item.prefixes, widget.item.suffixes));
    _advancedMods = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Mod probabilities"),
      ),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: _item.getItemWidget(_advancedMods, () {
            setState(() {
              _advancedMods = !_advancedMods;
            });
          }),
        ),
        _buttonWidget()
      ],
    );
  }

  Widget _buttonWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(flex: 1, child: _prefixButton()),
              SizedBox(
                width: 8,
              ),
              Expanded(flex: 1, child: _suffixButton()),
              SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 1,
                child: RaisedButton(
                  child: Text("DIVINE"),
                  onPressed: _divine,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: RaisedButton(
                  child: Text("SELECT FOSSILS"),
                  onPressed: _selectFossils,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 1,
                child: RaisedButton(
                  child: Text("RESET ITEM"),
                  onPressed: _reset,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _prefixButton() {
    var onPressed =
        _item.hasMaxPrefixes() ? null : _showPossiblePrefixesWithWeights;
    return RaisedButton(
      child: Text("PREFIXES"),
      onPressed: onPressed,
    );
  }

  Widget _suffixButton() {
    var onPressed =
        _item.hasMaxSuffixes() ? null : _showPossibleSuffixesWithWeights;
    return RaisedButton(
      child: Text("SUFFIXES"),
      onPressed: onPressed,
    );
  }

  void _showPossiblePrefixesWithWeights() {
    List<Mod> possibleMods =
        ModRepository.instance.getPossiblePrefixes(_item, _selectedFossils);
    _showPossibleModsWithWeights(possibleMods);
  }

  void _showPossibleSuffixesWithWeights() {
    List<Mod> possibleMods =
        ModRepository.instance.getPossibleSuffixes(_item, _selectedFossils);
    _showPossibleModsWithWeights(possibleMods);
  }

  void _showPossibleModsWithWeights(List<Mod> mods) {
    Map<String, ModWeightHolder> modWeightMap =
        ModRepository.instance.getModWeights(mods, _item, _selectedFossils);
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    ModSelectWidget(modWeights: modWeightMap.values.toList())))
        .then((mod) {
      if (mod != null) {
        setState(() {
          _item.addMod(mod);
        });
      }
    });
  }

  void _selectFossils() {
    FossilSelectDialog.getFossilSelectionDialog(
            context,
            _selectedFossils
                .map((selectedFossil) => selectedFossil.name)
                .toList())
        .then((fossils) {
      setState(() {
        if (fossils != null) {
          _selectedFossils = fossils;
        }
      });
    });
  }

  void _reset() {
    setState(() {
      _item = Item.copy(_original);
    });
  }

  void _divine() {
    setState(() {
      _item.divine();
    });
  }
}
