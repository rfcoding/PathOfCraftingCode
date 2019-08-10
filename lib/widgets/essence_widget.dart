import 'package:flutter/material.dart';
import '../crafting/item/item.dart';
import '../crafting/essence.dart';
import '../crafting/mod.dart';
import '../repository/essence_repo.dart';
import '../repository/mod_repo.dart';

class EssenceCraftingWidget extends StatefulWidget {
  final Item item;

  EssenceCraftingWidget({
    @required this.item
  });

  @override
  State<StatefulWidget> createState() {
    return EssenceCraftingState();
  }
}

class EssenceCraftingState extends State<EssenceCraftingWidget> {
  Map<String, List<Essence>> essenceMap;

  @override
  void initState() {
    essenceMap = EssenceRepository.instance.essenceMap;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Essence"),
      ),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return ListView.builder(
        itemBuilder: _buildExpandableListItem,
        itemCount: essenceMap.keys.length
    );
  }

  Widget _buildExpandableListItem(BuildContext context, int index) {
    final String key = essenceMap.keys.toList()[index];
    return ExpansionTile(
      backgroundColor: Color(0xFF231E18),
      title: Text(key, style: TextStyle(color: Color(0xFFB29155))),
      children: <Widget>[
        Column(
          children: _buildExpandedList(essenceMap[key]),
        )
      ],
    );
  }

  List<Widget> _buildExpandedList(List<Essence> essences) {
    List<Widget> listContent = List();
    for (int i = 0; i < essences.length; i++) {
      Essence essence = essences[i];
      String essenceModId = essence.mods[widget.item.itemClass];
      assert(essenceModId != null);
      Mod mod = ModRepository.instance.getModById(essenceModId);
      String subtitle = mod.getStatStringWithValueRanges().join('\n');
      listContent.add(
        ListTile(
          title: Text(essence.name),
          subtitle: Text(subtitle),
          onTap:() =>  _returnWithSelectedEssence(essence),)
      );
    }
    return listContent;
  }

  void _returnWithSelectedEssence(Essence essence) {
    Navigator.of(context).pop(essence);
  }
}