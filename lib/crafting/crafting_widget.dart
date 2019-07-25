import 'package:flutter/material.dart';
import 'item.dart';

class CraftingWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CraftingWidgetState();
  }
}

class _CraftingWidgetState extends State<CraftingWidget> {
  Item _item = new RareItem();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crafting Lobby"),
      ),
      body: Column(
        children: <Widget>[
          _item.getItemWidget(),
          RaisedButton(
            child: Text("Reroll"),
            onPressed: () {
              setState(() {
                _item.reroll();
              });
            },
          )
          //)
        ],
      ),
    );
  }
}
