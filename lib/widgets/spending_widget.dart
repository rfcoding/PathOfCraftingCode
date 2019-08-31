import 'package:flutter/material.dart';
import 'package:poe_clicker/crafting/currency_type.dart';
import 'package:poe_clicker/network/ninja_item.dart';
import 'package:poe_clicker/network/ninja_request.dart';
import 'package:poe_clicker/repository/item_repo.dart';
import '../crafting/item/spending_report.dart';
import 'utils.dart';

class SpendingWidget extends StatefulWidget {
  final SpendingReport spendingReport;

  SpendingWidget({this.spendingReport});

  @override
  State<StatefulWidget> createState() {
    return SpendingWidgetState();
  }
}

class SpendingWidgetState extends State<SpendingWidget> {
  List<NinjaItem> _ninjaItems;
  double _total = 0;
  String _totalString = "Loading...";
  String _league = NinjaRequest.SUPPORTED_LEAGUES[0];
  String _warningMessage;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() {
    reset();

    Future.wait({
      NinjaRequest.getCurrencyRatios(_league),
      NinjaRequest.getEssenceRatios(_league),
      NinjaRequest.getFossilRatios(_league),
      NinjaRequest.getResonatorRatios(_league),
      NinjaRequest.getBeastRatios(_league)
    }).catchError((error) {
      print("Error loading currencies $error");
      setState(() {
        _totalString = "Error";
      });
    }).then((currencyLists) {
      _ninjaItems = currencyLists.expand((list) => list).toList();
      calculateCurrencyTotals();
      setState(() {
        _totalString = "${_total.toStringAsFixed(2)} chaos";
      });
    });
  }

  void reset() {
    _total = 0;
    _totalString = "Loading...";
    _warningMessage = null;
  }

  void calculateCurrencyTotals() {
    widget.spendingReport.currencyMap.entries.forEach(calculateTotalForCurrency);
    widget.spendingReport.essenceMap.entries.forEach(calculateTotalForItem);
    widget.spendingReport.fossilMap.entries.forEach(calculateTotalForItem);
    widget.spendingReport.resonatorMap.entries.forEach(calculateTotalForItem);
    widget.spendingReport.beastMap.entries.forEach(calculateTotalForItem);
  }

  void calculateTotalForCurrency(MapEntry<String, int> currencyEntry) {
    String currencyName = currencyEntry.key;
    int currencyAmount = currencyEntry.value;
    String currencyNinjaName = ItemRepository
        .instance.baseItemMap[CurrencyType.currencyToId[currencyName]].name;
    if (_ninjaItems.any((item) => item.name == currencyNinjaName)) {
      NinjaItem currency = _ninjaItems.firstWhere((item) => item.name == currencyNinjaName);
      _total += currencyAmount * currency.chaosValue;
    } else {
      _warningMessage = "Could not retrieve values for all currencies";
    }
  }

  void calculateTotalForItem(MapEntry<String, int> itemEntry) {
      String currencyName = itemEntry.key;
      int currencyAmount = itemEntry.value;
      if (_ninjaItems.any((item) => item.name == currencyName)) {
        NinjaItem item = _ninjaItems.firstWhere((item) => item.name == currencyName);
        _total += currencyAmount * item.chaosValue;
      } else {
        _warningMessage = "Could not retrieve values for all currencies";
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Currence Used"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: widget.spendingReport.getListWidget()),
            getLeagueSelectWidget(),
            getTotalSpendingWidget(),
            getNinjaPraiseWidget(),
            SizedBox(height: 8,)
          ],
        ));
  }

  Widget getTotalSpendingWidget() {
    return ListTile(
      leading: maybeGetWarningIcon(),
      title: Text("Total cost estimate:"),
      trailing: Text(_totalString),
    );
  }

  Widget maybeGetWarningIcon() {
    if (_warningMessage == null) {
      return null;
    }
    return Tooltip(
        message: _warningMessage,
        child: Icon(
          Icons.warning,
          size: 24,
          color: Colors.yellow[800],
        ));
  }

  Widget getLeagueSelectWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          DropdownButton<String>(
            hint: Text(_league),
            items: NinjaRequest.SUPPORTED_LEAGUES
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String value) {
              setState(() {
                _league = value;
                fetchData();
              });
            },
          ),
          Expanded(
            child: Container(),
          )
        ],
      ),
    );
  }

  Widget getNinjaPraiseWidget() {
    return RichText(text: clickableText("Powered by poe.ninja", () => openPage("https://poe.ninja") ),);
  }
}
