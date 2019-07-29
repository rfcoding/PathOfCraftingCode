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
                return CheckboxListTile(
                    title: Text(widget.selectableItems[index].fossil.name),
                    value: widget.selectableItems[index].selected,
                    onChanged: (selected) {
                      setState(() {
                        widget.selectableItems[index].selected = selected;
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
