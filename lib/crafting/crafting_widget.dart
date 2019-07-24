import 'package:flutter/material.dart';
import 'item.dart';

class CraftingWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CraftingWidgetState();
  }
}

class _CraftingWidgetState extends State<CraftingWidget> {
  Item _item = new Item("Thicket Bow");

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
          Container(
              height: 50,
              color: Colors.amber,
              child: Center(
                child: Text(
                  _item.toString(),
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              )),
          Expanded(
            //child: SizedBox(
             // height: 200,
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 50,
                    color: Colors.amber,
                    child: Center(
                        child: Text(
                          '${_item.getMods()[index].getStatStrings()[0]}',
                          style: TextStyle(color: Colors.black),
                        )),
                  );
                },
                itemCount: _item.getMods().length,
                padding: const EdgeInsets.all(8.0),
              ),
            ),
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
