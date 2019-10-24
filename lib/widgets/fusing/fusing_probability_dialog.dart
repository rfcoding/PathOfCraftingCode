

import 'package:flutter/material.dart';
import 'package:poe_clicker/network/ninja_item.dart';
import 'package:poe_clicker/statistics/fusing_profit_probability.dart';
import '../utils.dart';
import 'fusing_widget.dart';

class FusingProbabilityDialog extends StatefulWidget{

  final LinkState linkState;
  final List<NinjaSixLink> itemBaseList;
  final NinjaSixLink _selectedBase;
  final NinjaItem fusing;

  static Future<NinjaSixLink> showProbabilityDialog(
      BuildContext context,
      LinkState linkState,
      List<NinjaSixLink> itemBaseList,
      NinjaSixLink selectedBase,
      NinjaItem fusing) async {
    NinjaSixLink result = await showDialog(
        context: context,
        builder: (BuildContext context) =>
            Dialog(child: FusingProbabilityDialog(
                linkState,
                itemBaseList,
                selectedBase,
                fusing)));
    return result != null ? result : selectedBase;
  }

  FusingProbabilityDialog(this.linkState, this.itemBaseList, this._selectedBase, this.fusing);

  @override
  State<StatefulWidget> createState() {
    return FusingProbabilityDialogState(_selectedBase);
  }
}

class FusingProbabilityDialogState extends State<FusingProbabilityDialog> {

  NinjaSixLink selectedBase;
  FusingProfitProbability _fusingProfitProbability = FusingProfitProbability();

  FusingProbabilityDialogState(this.selectedBase);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            statsWidget()
          ]
      ), onWillPop: () {
      Navigator.of(context).pop(selectedBase);
      return Future.value(false);
    },
    );
  }

  Widget statsWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          selectBaseWidget(),
          currentStateStats(),
          SizedBox(height: 8,),
          chanceToProfitWidget(),
          SizedBox(height: 8,),
          RaisedButton(child: Text("Close"), onPressed: () => Navigator.of(context).pop(selectedBase),)
        ],
      ),
    );
  }

  Widget selectBaseWidget() {
    return Center(
      child: baseSelectDropDown(),
    );
  }

  Widget currentStateStats() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          text("Fusings Used: ${widget.linkState.fusingsUsed}"),
          text("Six Links: ${widget.linkState.numberOfSixLinks}"),
          text("Probability: ${_fusingProfitProbability.numberOfLinksProbabilityInPercent(
              widget.linkState.fusingsUsed,
              widget.linkState.numberOfSixLinks)
              .toStringAsFixed(4)}%"),
          profitWidget(),
        ],
      ),
    );
  }

  Widget baseSelectDropDown() {
    return DropdownButton<NinjaSixLink>(
      isExpanded: true,
      hint: Text("${selectedBase.toString()}"),
      onChanged: (NinjaSixLink value) {
        setState(() {
          selectedBase = value;
        });
      },
      items: widget.itemBaseList.map((item) {
        return DropdownMenuItem<NinjaSixLink>(
            value: item,
            child: dropDownMenuItem(item)

        );
      }).toList(),
    );
  }

  Widget dropDownMenuItem(NinjaSixLink item) {
    return RichText(
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
            children: <TextSpan>[
              coloredText(item.name, Color(0xFFB29155), 20),
              coloredText("\nProfit / 6L: ${item.chaosProfit.toStringAsFixed(0)} Chaos", Colors.white, 16)
            ]));
  }

  Widget profitWidget() {
    double cost = widget.fusing.chaosValue * widget.linkState.fusingsUsed;
    double income = selectedBase.chaosProfit * widget.linkState.numberOfSixLinks;
    double profit = income - cost;
    return Text("Profit: ${profit.toStringAsFixed(1)} Chaos",
      style: TextStyle(color: profit > 0 ? Colors.green : Colors.red, fontSize: 16),);
  }

  Widget chanceToProfitWidget() {
    int fusingsUsed = widget.linkState.fusingsUsed;
    double cost = widget.fusing.chaosValue * fusingsUsed;
    int sixLinksNeeded = (cost / selectedBase.chaosProfit).ceil();

    TableRow legend = TableRow(children: [
      TableCell(child: Text("# of 6L"),),
      TableCell(child: Text("Probability"),),
      TableCell(child: Text("Profit"),),
    ]);

    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: text("Probabilities to make profit with ${widget.linkState.fusingsUsed} fusings: "),
        ),
        SizedBox(height: 4,),
        Center(
          child: Table(
            border: TableBorder.all(color: Colors.white,),
            children: [
              legend,
              row(fusingsUsed, sixLinksNeeded, cost),
              row(fusingsUsed, sixLinksNeeded + 1, cost),
              row(fusingsUsed, sixLinksNeeded + 2, cost),
            ],
          ),
        ),
      ],
    );

  }

  TableRow row(int fusingsUsed, int sixLinksNeeded, double cost) {
    double winProbability = 100 * _fusingProfitProbability.profitProbability(fusingsUsed, sixLinksNeeded);
    double profit = sixLinksNeeded * selectedBase.chaosProfit - cost;

    return TableRow(
      children: [
        TableCell(child: Text("$sixLinksNeeded")),
        TableCell(child: Text("${winProbability.toStringAsFixed(4)}%"),),
        TableCell(child: Text("${profit.toStringAsFixed(1)} C"))
      ]
    );
  }

  Widget text(String text) {
    return Text(text, style: TextStyle(fontSize: 16),);
  }

}