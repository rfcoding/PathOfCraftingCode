import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poe_clicker/network/ninja_item.dart';
import 'package:poe_clicker/network/ninja_request.dart';
import 'package:poe_clicker/widgets/utils.dart';

class FusingWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FusingWidgetState();
  }
}

class FusingWidgetState extends State<FusingWidget> {
  static const String SOCKET = 'assets/images/whitesocket.png';
  static const String LINK_HORIZONTAL = 'assets/images/linkhorizontal.png';
  static const String LINK_VERTICAL = 'assets/images/linkvertical.png';
  static const String EMPTY = 'assets/images/empty.png';

  LinkState _linkState = LinkState();
  bool _isSpamming = false;
  bool _shouldSpam = false;
  List<NinjaSixLink> _itemBaseList;
  NinjaSixLink _selectedBase;
  NinjaItem _fusing;

  @override
  void initState() {
    NinjaRequest.getSixLinkArmours(NinjaRequest.SUPPORTED_LEAGUES[0]).then((
        sixLinks) {
      NinjaSixLink sixLink = sixLinks[0];
      setState(() {
        _itemBaseList = sixLinks;
        _selectedBase = sixLink;
      });
    });
    NinjaRequest.getCurrencyRatios(NinjaRequest.SUPPORTED_LEAGUES[0]).then((
        currencies) {
      _fusing =
          currencies.firstWhere((currency) => currency.name == "Orb of Fusing");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fusing simulator"),
      ),
      backgroundColor: Colors.black,
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return Column(
      children: <Widget>[
        statsWidget(),
        Expanded(
          child: itemWidget(_linkState),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 64,
              child: Center(child: squareImageButton(
                  'assets/images/fusing.png', "Orb of Fusing", useFusing, 64))
              ,
            ),
            spamButton()
          ],
        ),
        SizedBox(height: 16,)
      ],
    );
  }

  Widget itemWidget(LinkState linkState) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage("assets/images/kaoms.png"),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: 160,
            height: 256,
            child: Stack(children: <Widget>[
              horizontalImage(SOCKET), // Socket 1
              new Positioned(
                left: 96, child: horizontalImage(SOCKET), // Socket 2
              ),
              new Positioned(
                  right: 0, top: 96, child: horizontalImage(SOCKET) // Socket 3
              ),
              new Positioned(top: 96, child: horizontalImage(SOCKET) // Socket 4
              ),
              new Positioned(
                  top: 192, child: horizontalImage(SOCKET) // Socket 5
              ),
              new Positioned(
                  right: 0, top: 192, child: horizontalImage(SOCKET) // Socket 6
              ),
              new Positioned(
                left: 48,
                top: 16,
                child: horizontalImage(
                    linkState.linked(0) ? LINK_HORIZONTAL : EMPTY), // Link 1
              ),
              new Positioned(
                right: 16,
                top: 48,
                child: verticalImage(
                    linkState.linked(1) ? LINK_VERTICAL : EMPTY), // Link 2
              ),
              new Positioned(
                right: 48,
                top: 112,
                child: horizontalImage(
                    linkState.linked(2) ? LINK_HORIZONTAL : EMPTY), // Link 3
              ),
              new Positioned(
                left: 16,
                top: 144,
                child: verticalImage(
                    linkState.linked(3) ? LINK_VERTICAL : EMPTY), // Link 4
              ),
              new Positioned(
                right: 48,
                top: 208,
                child: horizontalImage(
                    linkState.linked(4) ? LINK_HORIZONTAL : EMPTY), // Link 5
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget statsWidget() {
    return Center(
      child: Column(
        children: <Widget>[
          selectedBaseWidget(),
          profitWidget(),
          Text("Six Links: ${_linkState.numberOfSixLinks}"),
          Text("Fusings Used: ${_linkState.fusingsUsed}"),
        ],
      ),
    );
  }

  Widget selectedBaseWidget() {
    if (_selectedBase == null) {
      return Text("Loading item base values");
    }
    return Center(
      child: baseSelectDropDown(),
    );
  }

  Widget baseSelectDropDown() {
    return DropdownButton<NinjaSixLink>(
      isDense: true,
      hint: Text("${_selectedBase.name}"),
      onChanged: (NinjaSixLink value) {
        setState(() {
          _selectedBase = value;
        });
      },
      items: _itemBaseList.map((item) {
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
    if (_selectedBase == null || _fusing == null) {
      return Text("Calculating profit...");
    }
    double cost = _fusing.chaosValue * _linkState.fusingsUsed;
    double income = _selectedBase.chaosProfit * _linkState.numberOfSixLinks;
    double profit = income - cost;
    return Text("Profit: ${profit.toStringAsFixed(1)} Chaos",
      style: TextStyle(color: profit > 0 ? Colors.green : Colors.red),);
  }

  void useFusing() {
    setState(() {
      _linkState.reRoll();
    });
  }

  Widget spamButton() {
    if (_isSpamming) {
      return Container(
          height: 64,
          child: Center(child: squareImageButton(
              'assets/images/scour.png', "Stop spamming", () => stopSpamming(),
              64))
      );
    }
    return Container(
        height: 64,
        child: Center(child: squareImageButton(
            'assets/images/chaos.png', "Start spamming", () => startSpamming(),
            64))
    );
  }

  void stopSpamming() {
    setState(() {
      _shouldSpam = false;
    });
  }

  void startSpamming() {
    _shouldSpam = true;
    spam();
  }

  void spam() async {
    if (_isSpamming) {
      return;
    }
    _isSpamming = true;
    while (_shouldSpam) {
      useFusing();
      await Future.delayed(Duration(milliseconds: 2));
    }
    setState(() {
      _isSpamming = false;
    });
  }

  Widget horizontalImage(String imagePath) {
    return Image(width: 64, image: AssetImage(imagePath), fit: BoxFit.fitWidth);
  }

  Widget verticalImage(String imagePath) {
    return Image(
        height: 64, image: AssetImage(imagePath), fit: BoxFit.fitHeight);
  }
}

class LinkState {
  /*
      from socket 1	17818	34818	26766	19672	826	100
      from socket 2	3178	6210	4774	3509	147
      from socket 3	6834	13353	10265	7544
      from socket 4	8934	17457	13420
      from socket 5	15820	30913
   */
  static const List<List<int>> PROBABILITIES = [
    [17818, 34818, 26766, 19672, 826, 100],
    [3178, 6210, 4774, 3509, 147],
    [6834, 13353, 10265, 7544],
    [8934, 17457, 13420],
    [15820, 30913]
  ];
  static const List<int> SUMS = [100000, 17818, 37996, 39811, 46733];
  List<bool> sockets = [false, false, false, false, false];
  Random rng = new Random();
  int fusingsUsed = -1;
  int numberOfSixLinks = 0;

  LinkState() {
    reRoll();
  }

  bool linked(int link) {
    return sockets[link];
  }

  bool isSixLinked() {
    return sockets[0] && sockets[1] && sockets[2] && sockets[3] && sockets[4];
  }

  void reRollSimple() {
    sockets[0] = rng.nextBool();
    sockets[1] = rng.nextBool();
    sockets[2] = rng.nextBool();
    sockets[3] = rng.nextBool();
    sockets[4] = rng.nextBool();
  }

  void reRoll() {
    fusingsUsed ++;
    List<bool> oldSockets = List.from(sockets);
    _rollSockets();
    /*while (socketsEqual(oldSockets)) {
      _rollSockets();
    }*/

    if (isSixLinked()) {
      numberOfSixLinks++;
    }
  }

  void _rollSockets() {
    sockets = [false, false, false, false, false];

    int currentSocket = 0;
    while (currentSocket < 5) {
      int roll = _rollDice(currentSocket);
      currentSocket = _addLinks(currentSocket, roll);
      currentSocket++;
    }
  }

  int _rollDice(int socket) {
    if (socket > 4 || socket < 0) {
      throw ArgumentError("Socket has to be between 1 and 5");
    }
    List<int> weights = PROBABILITIES[socket];
    int sum = SUMS[socket];
    int roll = rng.nextInt(sum);
    int acc = 0;
    for (int i = 0; i < weights.length; i++) {
      int weight = weights[i];
      acc += weight;
      if (acc >= roll) {
        return i;
      }
    }
    throw StateError("Should not be here");
  }

  int _addLinks(int currentSocket, int socketsToLink) {
    for (int i = 0; i < socketsToLink; i++) {
      sockets[currentSocket + i] = true;
    }
    return currentSocket + socketsToLink;
  }

  bool socketsEqual(List<bool> other) {
    if (sockets == null || other == null || sockets.length != other.length) {
      return false;
    }
    for (int i = 0; i < sockets.length; i++) {
      if (sockets[i] != other[i]) {
        return false;
      }
    }
    return true;
  }
}
