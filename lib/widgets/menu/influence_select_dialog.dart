import 'package:flutter/material.dart';

class InfluenceSelectDialog {

  static Future<List<String>> showInfluenceSelectDialog(BuildContext context,
      List<String> selected, List<String> items) async {
    List<SelectableItem> selectableItems = items.map((name) =>
        SelectableItem(name: name, selected: selected.contains(name))).toList();
    List<SelectableItem> result =  await showDialog(
        context: context,
        builder: (BuildContext context) =>
            influenceDialog(context, selectableItems));
    if (result == null) {
      return null;
    }

    return result.where((item) => item.selected)
        .map((item) => item.name)
        .toList();
  }

  static Dialog influenceDialog(BuildContext context,
      List<SelectableItem> selectableItems) {
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
                SelectableItem item = widget.selectableItems[index];
                int selectedCount = widget.selectableItems
                    .where((item) => item.selected)
                    .length;
                return CheckboxListTile(
                    title: Text(item.name),
                    value: item.selected,
                    onChanged: (selected) {
                      setState(() {
                        if (!selected || selectedCount < 2) {
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
  String name;
  bool selected;

  SelectableItem({this.name, this.selected});
}