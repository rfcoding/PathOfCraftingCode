import 'package:flutter/material.dart';
import 'package:poe_clicker/crafting/beast_craft.dart';
import '../crafting/item/item.dart';

class BeastWidget extends StatefulWidget {
  final Item item;

  BeastWidget(this.item);

  @override
  _BeastWidgetState createState() => _BeastWidgetState();
}

class _BeastWidgetState extends State<BeastWidget> {
  TextEditingController controller = TextEditingController();
  List<BeastCraft> craftingOptions;
  String filter;

  @override
  void initState() {
    craftingOptions = BeastCraft.getBeastCraftsForItem(widget.item);
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Beast Crafting Options"),
        ),
        body: getBody());
  }

  Widget getBody() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: new InputDecoration(labelText: "Filter"),
            controller: controller,
          ),
        ),
        Expanded(
          child: ListView.builder(itemCount: craftingOptions.length, itemBuilder: buildListItem),
        ),
        SizedBox(
          height: 8,
        ),
        RaisedButton(
          child: Text("Close"),
          onPressed: () => Navigator.of(context).pop(null),
        ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }

  Widget buildListItem(BuildContext context, int index) {
    final craftingOption = craftingOptions[index];
    if (filter != null &&
        filter.isNotEmpty &&
        !craftingOption.displayName.toLowerCase().contains(filter.toLowerCase())) {
      return Container();
    }
    return ListTile(
      title: Text(craftingOption.displayName),
      subtitle: Text(craftingOption.subheader),
      trailing: _buildCostWidget(craftingOption.cost),
      onTap: () => Navigator.of(context).pop(craftingOption),
    );
  }

  Widget _buildCostWidget(BeastCraftCost cost) {
    //final imagePath = CurrencyType.idToImagePath[cost.itemId];

    //assert(imagePath != null, cost.itemId);
    if (cost == null) {
      return Text("Free");
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("${cost.count}x"),
        //Image(image: AssetImage(imagePath), width: 20, height: 20,),
      ],
    );
  }
}
