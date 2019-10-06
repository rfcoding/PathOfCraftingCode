

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
          text("Fusings Used: ${widget.linkState.fusingsUsed}"),
          text("Six Links: ${widget.linkState.numberOfSixLinks}"),
          profitWidget(),
          chanceToProfitWidget(),
          RaisedButton(child: Text("Close"), onPressed: () => Navigator.of(context).pop(selectedBase),)
        ],
      ),
    );
  }

  Widget selectBaseWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: baseSelectDropDown(),
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
    double cost = widget.fusing.chaosValue * widget.linkState.fusingsUsed;
    int sixLinksNeeded = (cost / selectedBase.chaosProfit).ceil();
    print("Six links needed: $sixLinksNeeded");
    double winProbability = _fusingProfitProbability.profitProbability(widget.linkState.fusingsUsed, sixLinksNeeded);
    return text("Chance to profit: ${(100 * winProbability).toStringAsFixed(2)}%");
  }

  Widget text(String text) {
    return Text(text, style: TextStyle(fontSize: 16),);
  }

}