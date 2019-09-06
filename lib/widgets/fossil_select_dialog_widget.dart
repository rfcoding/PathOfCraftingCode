import 'package:flutter/material.dart';

import '../crafting/fossil.dart';
import '../repository/fossil_repo.dart';

class FossilSelectDialog {
  static Future<List<Fossil>> getFossilSelectionDialog(
      BuildContext context, List<String> selected) async {
    List<SelectableItem> selectableItems = FossilRepository.instance
        .getFossils()
        .map((fossil) => SelectableItem(
            fossil: fossil, selected: selected.contains(fossil.name)))
        .toList();
    List<SelectableItem> result = await showDialog(
        context: context,
        builder: (BuildContext context) =>
            fossilDialog(context, selectableItems));
    if(result == null) {
      return null;
    }
    return result
        .where((item) => item.selected)
        .map((item) => item.fossil)
        .toList();
  }

  static Dialog fossilDialog(
      BuildContext context, List<SelectableItem> selectableItems) {
    return Dialog(child: DialogContent(selectableItems: selectableItems));
  }
}

class DialogContent extends StatefulWidget {
  final List<SelectableItem> selectableItems;

  DialogContent({this.selectableItems});

  @override
  State<StatefulWidget> createState() {
    return DialogContentState();
  }
}

class DialogContentState extends State<DialogContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.selectableItems.length,
              itemBuilder: (BuildContext context, int index) {
                Fossil fossil = widget.selectableItems[index].fossil;
                int selectedCount = widget.selectableItems.where((item) => item.selected).length;
                return CheckboxListTile(
                    title: Text(fossil.name, style: TextStyle(fontSize: 20, color: Color(0xFFB29155)),),
                    subtitle: Text(fossil.descriptions.map((name) => "• " + name).join("\n")),
                    value: widget.selectableItems[index].selected,
                    activeColor: Theme.of(context).buttonColor,
                    onChanged: (selected) {
                      setState(() {
                        if (!selected || selectedCount < 4) {
                          widget.selectableItems[index].selected = selected;
                        }
                      });
                    });
              }),
        ),
        RaisedButton(
          child: Text("Done"),
          onPressed: () => Navigator.of(context).pop(widget.selectableItems),
        )
      ],
    );
  }
}

class SelectableItem {
  Fossil fossil;
  bool selected;

  SelectableItem({this.fossil, this.selected: false});
}
