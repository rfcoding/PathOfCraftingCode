import 'package:flutter/material.dart';
import '../crafting/base_item.dart';
import '../crafting/fossil.dart';
import '../crafting/item/item.dart';
import '../crafting/item/normal_item.dart';
import '../crafting/mod.dart';
import 'fossil_select_dialog_widget.dart';
import 'crafting_bench_options_widget.dart';

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
          craftingOptionsWidget(),
          //)
        ],
      ),
    );
  }

  Widget craftingOptionsWidget() {
    return Row(
      children: <Widget>[
        RaisedButton(
          child: Text("Use"),
          onPressed: () => itemChanged(_item.useFossils(_selectedFossils)),
        ),
        RaisedButton(
            child: Text("Select Fossils"),
            onPressed: () =>
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
        Expanded(
          child: Align(
            child: masterCraftingWidget(),
            alignment: Alignment.centerRight,
          ),
        )
      ],
    );
  }

  Widget masterCraftingWidget() {
    return Row(
      children: <Widget>[
        RaisedButton(
          child: Text("Meta"),
          onPressed: showMasterCraftingDialog,
        ),
        RaisedButton(
          child: Text("Bench"),
          onPressed: _navigateToCraftingBench,
        )
      ],
    );
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
        builder: (BuildContext context) => CraftingBenchOptionsWidget(
          item: _item
        )
    )).then((result) {
      Mod mod = result as Mod;
      if (mod != null) {
        _item.tryAddMasterMod(mod);
      }
    });
  }

  void itemChanged(Item item) {
    setState(() {
      _item = item;
    });
  }
}
