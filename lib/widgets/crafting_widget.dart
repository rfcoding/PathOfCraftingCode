import 'package:flutter/material.dart';
import '../crafting/base_item.dart';
import '../crafting/fossil.dart';
import '../crafting/item/item.dart';
import '../crafting/item/normal_item.dart';
import '../crafting/mod.dart';
import '../repository/crafted_items_storage.dart';
import 'fossil_select_dialog_widget.dart';
import 'crafting_bench_options_widget.dart';
import 'essence_widget.dart';
import 'utils.dart';

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
          widget.baseItem.itemLevel);
      _item.tags.addAll(widget.extraTags);
    } else {
      _item = widget.item;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Crafting Lobby"),

      ),
      drawer: _getDrawer(),
      body: Column(

        children: <Widget>[
          Expanded(child: _item.getItemWidget(_showAdvancedMods)),
          _item.getActionsWidget(this),
          craftingOptionsWidget(),
          //)
        ],
      ),
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
            onTap: saveItem,
          )
        ],
      ),
    );
  }
  Widget craftingOptionsWidget() {
    return Row(
      children: <Widget>[
        imageButton(
            'assets/images/resonator.png',
                () => itemChanged(_item.useFossils(_selectedFossils))
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
      ],
    );
  }

  void saveItem() {
    CraftedItemsStorage.instance.saveItem(_item).then((success) {
      String message = success ? 'Item saved' : 'Failed to save item';
      print(message);
    });
  }

  void showMasterCraftingDialog() async {
    await showDialog(
        context: context,
        builder: masterCraftingDialogBuilder
    );
  }

  Widget masterCraftingDialogBuilder(BuildContext context) {
    return SimpleDialog(
      title: const Text("Master Crafting"),
      children: <Widget>[
        masterCraftingOption(context, "Suffixes cannot be changed -> Scour",() => itemChanged(_item.scourPrefixes())),
        masterCraftingOption(context, "Prefixes cannot be changed -> Scour", () => itemChanged(_item.scourSuffixes())),
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

  void _navigateToEssenceCraftWidget() {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) =>
          EssenceCraftingWidget(item: _item)
    )).then((result) {
      if (result is Mod) {
        itemChanged(_item.applyEssenceMod(result));
      }
    });
  }

  void itemChanged(Item item) {
    setState(() {
      _item = item;
    });
  }
}
