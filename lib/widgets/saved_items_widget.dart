import 'package:flutter/material.dart';
import '../repository/crafted_items_storage.dart';
import '../crafting/item/item.dart';
import 'crafting_widget.dart';

class SavedItemsWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SavedItemsState();
  }
}

class SavedItemsState extends State<SavedItemsWidget> {
  List<Item> items = List();

  @override
  void initState() {
    items = CraftedItemsStorage.instance.loadItems();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Items"),
      ),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return Column(
      children: <Widget>[
        Expanded(child: savedItemsListBuilder()),
      ],
    );
  }

  Widget savedItemsListBuilder() {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: listItemBuilder
    );
  }

  Widget listItemBuilder(BuildContext context, int index) {
    print(items);
    return ListTile(
      title: Text(items[index].name),
      trailing: IconButton(icon: Icon(Icons.delete), onPressed: () {
        setState(() {
          CraftedItemsStorage.instance.removeItem(index);
          items = CraftedItemsStorage.instance.loadItems();
        });
      }),
      onTap:() => _navigateToCraftingWidget(items[index]),
    );
  }

  void _navigateToCraftingWidget(Item item) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CraftingWidget(item: item)));
  }
}