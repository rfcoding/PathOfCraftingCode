import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poe_clicker/crafting/mod.dart';
import 'package:poe_clicker/repository/mod_repo.dart';

class ModSelectWidget extends StatefulWidget {
  final List<ModWeightHolder> modWeights;

  ModSelectWidget({this.modWeights});

  @override
  State<StatefulWidget> createState() {
    return ModSelectWidgetState();
  }
}

class ModSelectWidgetState extends State<ModSelectWidget> {
  TextEditingController controller = TextEditingController();
  String filter;

  Map<String, List<ModWeightHolder>> modWeightGroupMap = Map();
  List<ModWeightHolder> modsWeights;
  int totalWeight = 0;

  @override
  void initState() {
    modsWeights =
        widget.modWeights.where((modWeight) => modWeight.weight > 0).toList();
    modsWeights.sort((a, b) => a.mod.compareTo(b.mod));
    for (ModWeightHolder modWeight in modsWeights) {
      totalWeight += modWeight.weight;
      if (modWeightGroupMap[modWeight.mod.type] == null) {
        modWeightGroupMap[modWeight.mod.type] = List();
      }
      modWeightGroupMap[modWeight.mod.type].add(modWeight);
    }
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
        title: Text("Possible mods"),
      ),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: new InputDecoration(labelText: "Filter"),
          controller: controller,
        ),
      ),
      ListTile(
        trailing: Text("Chance to roll"),
        title: Text("Mod description"),
      ),
      Expanded(
        child: NotificationListener(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification) {
              FocusScope.of(context).requestFocus(new FocusNode());
            }
            return false;
          },
          child: ListView.builder(

            itemBuilder: _buildListItem,
            itemCount: modsWeights.length,
          ),
        ),
      )
    ],);
  }

  Widget _buildListItem(BuildContext context, int index) {
    final ModWeightHolder modWeightHolder = modsWeights[index];
    final Mod mod = modWeightHolder.mod;
    final String title = mod.getStatStringWithValueRanges().join("\n");
    final String subtitle = "T${ModRepository.instance.getModTier(mod)} ${mod.name}";
    if (filter != null &&
        filter.isNotEmpty &&
        !subtitle.toLowerCase().contains(filter) &&
        !title.toLowerCase().contains(filter)) {
      return Container();
    }
    double percentage = 100 * modWeightHolder.weight / totalWeight;
    return ListTile(
        title: Text(title, style: TextStyle(color: Color(0xFFB29155))),
        subtitle:
            Text(subtitle),
        trailing: Text("${percentage.toStringAsFixed(3)}%"),
        onTap: () => Navigator.of(context).pop(mod));
  }
}
