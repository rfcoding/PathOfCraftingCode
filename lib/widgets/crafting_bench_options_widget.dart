import 'package:flutter/material.dart';
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
  Map<String, List<CraftingBenchOption>> craftingBenchOptions;

  @override
  void initState() {
      craftingBenchOptions =
          CraftingBenchRepository.instance.getCraftingOptionsForItem(widget.item);
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
    return ExpansionTile(
      title: Text(key),
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
          title: Text(option.mod.getStatStringWithValueRanges().join("\n")),
          trailing: Text(i.toString()),
          onTap: () => Navigator.of(context).pop(option.mod),
        )
      );
    }
    return columnContent;
  }
}