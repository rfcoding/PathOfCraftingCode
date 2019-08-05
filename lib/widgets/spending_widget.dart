import 'package:flutter/material.dart';
import '../crafting/item/spending_report.dart';

class SpendingWidget extends StatefulWidget {

  final SpendingReport spendingReport;

  SpendingWidget({this.spendingReport});

  @override
  State<StatefulWidget> createState() {
    return SpendingWidgetState();
  }
}

class SpendingWidgetState extends State<SpendingWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Crafting Bench Options"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: widget.spendingReport.getWidget()),
            RaisedButton(child: Text("Close"), onPressed: () => Navigator.of(context).pop(),)
          ],
        )
    );
  }

}