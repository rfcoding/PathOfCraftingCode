import 'package:flutter/material.dart';
import '../crafting/base_item.dart';
import '../crafting/fossil.dart';
import '../crafting/item/item.dart';
import '../crafting/item/normal_item.dart';
import '../crafting/item/spending_report.dart';
import '../crafting/mod.dart';
import '../repository/crafted_items_storage.dart';
import 'fossil_select_dialog_widget.dart';
import 'crafting_bench_options_widget.dart';
import 'essence_widget.dart';
import 'utils.dart';
import 'spending_widget.dart';
import '../crafting/essence.dart';

class CraftingWidget extends StatefulWidget {
  final BaseItem baseItem;
  final List<String> extraTags;
  final Item item;

  CraftingWidget({this.baseItem, this.extraTags, this.item});

  @override
  State<StatefulWidget> createState() {
    return CraftingWidgetState();
  }
}

class CraftingWidgetState extends State<CraftingWidget> {
  Item _item;
  List<Fossil> _selectedFossils = List();
  bool _showAdvancedMods = false;
  final _saveFormKey = GlobalKey<FormState>();


  @override
  void initState() {
    if (widget.item == null) {
      _item = NormalItem(
          widget.baseItem.name,
          List(),
          List(),
          List<Mod>.from(widget.baseItem.implicits),
          List<String>.from(widget.baseItem.tags),
          widget.baseItem.weaponProperties,
          widget.baseItem.armourProperties,
          widget.baseItem.itemClass,
          widget.baseItem.itemLevel,
          SpendingReport());
      _item.tags.addAll(widget.extraTags);
    } else {
      _item = widget.item;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Crafting Lobby"),

        ),
        drawer: _getDrawer(),
        body: Column(
          children: <Widget>[
            Expanded(child: _item.getItemWidget(_showAdvancedMods)),
            inventoryWidget()
          ],
        ),
      ),
      onWillPop: () => _showConfirmDialog(),
    );
  }

  Widget _getDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          CheckboxListTile(
              title: Text('Advanced mods', style: TextStyle(fontSize: 20),),
              subtitle: Text('Enable to show more information about each mod'),
              value: _showAdvancedMods,
              activeColor: Theme.of(context).buttonColor,
              onChanged: (selected) {
                setState(() {
                  _showAdvancedMods = selected;
                });
              }),
          ListTile(
            title: Text("Save Item", style: TextStyle(fontSize: 20)),
            onTap: showSaveItemDialog,
          ),
          ListTile(
            title: Text("Spending Report", style: TextStyle(fontSize: 20)),
            onTap: _navigateToSpendingReportWidget,
          )
        ],
      ),
    );
  }

  Widget inventoryWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: Container(
        decoration: new BoxDecoration(
            border: Border.all(color: Color(0xFF433937), width: 3)),
        child: Column(
          children: <Widget>[
            _item.getActionsWidget(this),
            craftingOptionsWidget(),
          ],
        ),
      ),
    );
  }

  Widget craftingOptionsWidget() {
    return Builder(
      builder: (BuildContext context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            imageButton(
                'assets/images/resonator.png',
                    () {
                  if (_selectedFossils.length == 0) {
                    _showToast("No fossils selected", context);
                  } else {
                    itemChanged(_item.useFossils(_selectedFossils));
                  }
                }
            ),
            imageButton(
                'assets/images/fossil.png',
                    () =>
                    FossilSelectDialog.getFossilSelectionDialog(
                        context,
                        _selectedFossils
                            .map((selectedFossil) => selectedFossil.name)
                            .toList())
                        .then((fossils) {
                      setState(() {
                        _selectedFossils = fossils;
                      });
                    })
            ),
            imageButton(
                'assets/images/crafting.png',
                    () => _navigateToCraftingBench()
            ),
            imageButton(
                'assets/images/essence.png',
                    () => _navigateToEssenceCraftWidget()
            ),
            emptySquare(),
            emptySquare(),
          ],
        );
      }
    );
  }

  void saveItem() {
    if (_saveFormKey.currentState.validate()) {
      _saveFormKey.currentState.save();

      CraftedItemsStorage.instance.saveItem(_item).then((success) {
        String message = success ? 'Item saved' : 'Failed to save item';
        print(message);
      });
    }
  }

  void showSaveItemDialog() async {
    await showDialog(
        context: context,
        builder: saveItemDialogBuilder
    );
  }

  Widget saveItemDialogBuilder(BuildContext context) {
    return SimpleDialog(
      title: const Text("Save Item"),
      children: <Widget>[
        Form(
          key: _saveFormKey,
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: new InputDecoration(labelText: "Item name", hintText: "Enter item name"),
                    keyboardType: TextInputType.text,
                    onSaved: (input) {
                      _item.name = input;
                    },
                    initialValue: _item.name,
                    validator: (text) {
                      if (text.isEmpty) {
                        return "No name selected";
                      }
                      return null;
                    },
                    autovalidate: true,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(child: Text("Cancel"), onPressed: () {
                      Navigator.of(context).pop();
                    }),
                    RaisedButton(child: Text("Save"), onPressed: () {
                      Navigator.of(context).pop();
                      saveItem();
                    })
                  ],
                ),
              ],
            ),
          ),
        ),
      ],);
  }

  Widget masterCraftingOption(BuildContext context, String text, Function func) {
    return SimpleDialogOption(
      child: Text(text),
      onPressed: () {
        func();
        Navigator.of(context).pop();
      },
    );
  }

  void _navigateToCraftingBench() {
    Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context) =>
            CraftingBenchOptionsWidget(
                item: _item
            )
    )).then((result) {
      if (result is Mod) {
        itemChanged(_item.tryAddMasterMod(result));
      }
      if (result is RemoveMods) {
        itemChanged(_item.removeMasterMods());
      }
    });
  }

  void _navigateToSpendingReportWidget() {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) =>
          SpendingWidget(spendingReport: _item.spendingReport,)
    ));
  }

  void _navigateToEssenceCraftWidget() {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) =>
          EssenceCraftingWidget(item: _item)
    )).then((result) {
      if (result is Essence) {
        itemChanged(_item.applyEssence(result));
      }
    });
  }

  Future<bool> _showConfirmDialog() {
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Leave?"),
        content: new Text('Do you really want to vendor this item?'),
        actions: <Widget>[
          FlatButton(color: Colors.amber[800], textTheme: ButtonTextTheme.accent, child: Text("No"), onPressed: () => Navigator.of(context).pop(false),),
          FlatButton(color: Colors.amber[800], textTheme: ButtonTextTheme.accent, child: Text("Yes"), onPressed: () => Navigator.of(context).pop(true),),
        ],
      );
    });
  }

  void _showToast(String text, BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text), duration: Duration(milliseconds: 500),));
  }

  void itemChanged(Item item) {
    setState(() {
      _item = item;
    });
  }
}
