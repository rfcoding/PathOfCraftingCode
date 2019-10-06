

import 'package:flutter/material.dart';
import 'package:poe_clicker/statistics/fusing_profit_probability.dart';
import 'utils.dart';
import '../network/ninja_item.dart';
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
    print(result.name);
    return result != null ? result : selectedBase;
  }

  FusingProbabilityDialog(this.linkState, this.itemBaseList, this._selectedBase, this.fusing);

  @override
  State<StatefulWidget> createState() {
    return FusingProbabilityDialogState(_selectedBase);
  }
}

class FusingProbabilityDialogState extends State<FusingProbabilityDialog> {
  final _formKey = GlobalKey<FormState>();

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
    return Center(
      child: Column(
        children: <Widget>[
          selectBaseWidget(),
          Text("Fusings Used: ${widget.linkState.fusingsUsed}"),
          Text("Six Links: ${widget.linkState.numberOfSixLinks}"),
          profitWidget(),
          chanceToProfitWidget(),
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

  Widget baseSelectDropDown() {
    return DropdownButton<NinjaSixLink>(
      hint: Text("${selectedBase.name}"),
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
      style: TextStyle(color: profit > 0 ? Colors.green : Colors.red),);
  }

  Widget chanceToProfitWidget() {
    double cost = widget.fusing.chaosValue * widget.linkState.fusingsUsed;
    int sixLinksNeeded = (cost / selectedBase.chaosProfit).ceil();
    print("Six links needed: $sixLinksNeeded");
    double winProbability = _fusingProfitProbability.profitProbability(widget.linkState.fusingsUsed, sixLinksNeeded);
    return Text("Chance to profit: ${winProbability.toStringAsFixed(2)}");
  }

}