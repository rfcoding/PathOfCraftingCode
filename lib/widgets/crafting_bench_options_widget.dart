import 'package:flutter/material.dart';
import 'package:poe_clicker/crafting/currency_type.dart';
import '../repository/crafting_bench_repo.dart';
import '../crafting/item/item.dart';
import '../crafting/mod.dart';

class CraftingBenchOptionsWidget extends StatefulWidget {
  final Item item;

  CraftingBenchOptionsWidget({
    @required this.item,
  });

  @override
  State<StatefulWidget> createState() {
    return CraftingBenchOptionState();
  }

}

class CraftingBenchOptionState extends State<CraftingBenchOptionsWidget> {
  TextEditingController controller = TextEditingController();
  Map<String, List<CraftingBenchOption>> craftingBenchOptions;
  String filter;

  @override
  void initState() {
    craftingBenchOptions =
        CraftingBenchRepository.instance.getCraftingOptionsForItem(widget.item);
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
          title: Text("Crafting Bench Options"),
        ),
        body: getBody()
    );
  }

  Widget getBody() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: new InputDecoration(
                labelText: "Filter"
            ),
            controller: controller,
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: craftingBenchOptions.keys.length,
              itemBuilder: buildExpandableListItem
          ),
        ),
        SizedBox(height: 8,),
        RaisedButton(
          child: Text("Remove Crafted Modifiers"),
          onPressed: () => Navigator.of(context).pop(RemoveMods()),
        ),
        SizedBox(height: 8,)
      ],
    );
  }

  Widget buildExpandableListItem(BuildContext context, int index) {
    final String key = craftingBenchOptions.keys.toList()[index];
    String displayName = craftingBenchOptions[key].last.benchDisplayName;

    if (filter != null &&
        filter.isNotEmpty &&
        !displayName.toLowerCase().contains(filter.toLowerCase())) {
      return Container();
    }

    return ExpansionTile(
      backgroundColor: Color(0xFF231E18),
      title: Text(displayName, style: TextStyle(color: Color(0xFFB29155)),),
      children: <Widget>[
        Column(children: buildExpandedList(craftingBenchOptions[key]),)
      ],
    );
  }

  List<Widget> buildExpandedList(List<CraftingBenchOption> craftingBenchOptions) {
    List<Widget> columnContent = List();
    for (int i = 0; i < craftingBenchOptions.length; i++) {
      CraftingBenchOption option = craftingBenchOptions[i];
      columnContent.add(
        ListTile(
          title: Text(option.benchDisplayName),
          trailing: option.costs.length > 0 
            ? _buildCostWidget(option.costs[0]) 
            : Text(i.toString()), 
          onTap: () => Navigator.of(context).pop(option),
        )
      );
    }
    return columnContent;
  }

  Widget _buildCostWidget(CraftingBenchOptionCost cost) {
    final imagePath = CurrencyType.idToImagePath[cost.itemId];
      
      if(imagePath == null){
        print("no image path for currency ${cost.itemId}");
        return Container();
      }

      return Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("${cost.count}x"), 
                Image(image: AssetImage(imagePath), width: 20, height: 20,),
                ],);
  }
}