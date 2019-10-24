import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poe_clicker/network/ninja_item.dart';
import 'package:poe_clicker/network/ninja_request.dart';
import 'package:poe_clicker/widgets/utils.dart';

import 'batch_fusings_dialog.dart';
import 'fusing_probability_dialog.dart';

class FusingWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
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

  List<NinjaSixLink> _itemBaseList;
  NinjaSixLink _selectedBase;
  NinjaItem _fusing;

  @override
  void initState() {
    Future.wait({
      NinjaRequest.getSixLinkArmours(NinjaRequest.SUPPORTED_LEAGUES[0]),
      NinjaRequest.getSixLinkWeapons(NinjaRequest.SUPPORTED_LEAGUES[0])
    })
    .then((
        listsOfSixLinks) {
      List<NinjaSixLink> sixLinks = listsOfSixLinks.expand((list) => list).toList();
      sixLinks.sort((a, b) => b.chaosProfit.compareTo(a.chaosProfit));
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
      body: _getBody(context),
    );
  }

  Widget _getBody(BuildContext context) {
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
                  'assets/images/fusing.png', "Orb of Fusing",
                  onFusingButtonClicked, 64))
              ,
            ),
            batchFusingButton(context)
          ],
        ),
        SizedBox(height: 16,)
      ],
    );
  }

  void onFusingButtonClicked() {
    if (_linkState.isSixLinked()) {
      showSixLinkedDialog();
    } else {
      useFusing();
    }
  }

  Future<bool> showSixLinkedDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("You got a Six Link!"),
            content: new Text('Do you want to roll over it?'),
            actions: <Widget>[
              FlatButton(
                color: Colors.amber[800],
                textTheme: ButtonTextTheme.accent,
                child: Text("No"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                color: Colors.amber[800],
                textTheme: ButtonTextTheme.accent,
                child: Text("Yes"),
                onPressed: () =>
                {
                  useFusing(),
                  Navigator.of(context).pop()
                },
              ),
            ],
          );
        });
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
          SizedBox(height: 16,),
          Text("Fusings Used: ${_linkState.fusingsUsed}", style: TextStyle(fontSize: 16),),
          Text("Six Links: ${_linkState.numberOfSixLinks}", style: TextStyle(fontSize: 16)),
          statDialogButton()
        ],
      ),
    );
  }

  Widget statDialogButton() {
    if (_linkState == null || _itemBaseList == null || _selectedBase == null || _fusing == null) {
      return Text("Loading...", style: TextStyle(fontSize: 20),);
    }
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          children: [
            clickableText("Statistics", () =>
            showStatDialog(),
            fontSize: 20)
          ]
      ),
    );
  }

  void showStatDialog() async {
    _selectedBase = await FusingProbabilityDialog.showProbabilityDialog(
        context, _linkState, _itemBaseList, _selectedBase, _fusing);
  }

  void useFusing() {
    setState(() {
      _linkState.reRoll();
    });
  }

  Widget batchFusingButton(BuildContext context) {
    String assetPath = "assets/images/fusing.png";
    return Tooltip(
      child: InkWell(
        onTap: () {
          if (!_isSpamming) {
            _showBatchDialog();
          }
        },
        child: Container(
          height: 64,
          width: 64,
          decoration: new BoxDecoration(
            border: Border.all(color: Color(0xFF2A221A), width: 1),
          ),
          child: Stack(children: <Widget>[
            new Positioned(
              top: 16,
              child: Image(
                height: 32, width: 32, image: AssetImage(assetPath),),
            ),
            new Positioned(
              top: 16,
              left: 16,
              child: Image(
                height: 32, width: 32, image: AssetImage(assetPath),),
            ),
            new Positioned(
              top: 16,
              left: 32,
              child: Image(
                height: 32, width: 32, image: AssetImage(assetPath),),
            ),
          ]),
        ),
      ), message: "Batch fusings",
    );
  }

  void _showBatchDialog() {
    BatchFusingsDialog.showBatchFusingDialog(context).then((numberOfFusings) {
      spamFusings(numberOfFusings);
    });
  }

  void spamFusings(int numberOfFusings) async {
    if (_isSpamming) {
      return;
    }
    int fusingsRemaining = numberOfFusings;
    _isSpamming = true;
    while (fusingsRemaining > 0) {
      useFusing();
      fusingsRemaining--;
      int delay = _linkState.isSixLinked() ? 1000 : 5;
      await Future.delayed(Duration(milliseconds: delay));
    }
    _isSpamming = false;
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
  List<bool> links = [false, false, false, false, false];
  Random rng = new Random();
  int fusingsUsed = -1;
  int numberOfSixLinks = 0;

  LinkState() {
    reRoll();
  }

  bool linked(int link) {
    return links[link];
  }

  bool isSixLinked() {
    return links[0] && links[1] && links[2] && links[3] && links[4];
  }

  void reRollSimple() {
    links[0] = rng.nextBool();
    links[1] = rng.nextBool();
    links[2] = rng.nextBool();
    links[3] = rng.nextBool();
    links[4] = rng.nextBool();
  }

  void reRoll() {
    fusingsUsed ++;
    List<bool> oldLinks = List.from(links);
    _rollSockets();
    if (linksEqual(oldLinks)) {
      if (anagram()) {
        shuffleAnagram();
      } else {
        mirrorLinks();
      }
    }

    if (isSixLinked()) {
      numberOfSixLinks++;
    }
  }

  void _rollSockets() {
    links = [false, false, false, false, false];

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
      links[currentSocket + i] = true;
    }
    return currentSocket + socketsToLink;
  }

  bool anagram() {
    return links[0] == links[4] && links[1] == links[3];
  }

  void shuffleAnagram() {
    int nLinks = maxLinks();
    if (nLinks == 2) {
      links = List.of([true, true, false, false, false]);
    } else if (nLinks == 1) {
      links = List.of([true, false, false, false, false]);
    }
  }

  void mirrorLinks() {
    links = List<bool>.from([
      links[4],
      links[3],
      links[2],
      links[1],
      links[0]
    ]);
  }

  bool linksEqual(List<bool> other) {
    if (links == null || other == null || links.length != other.length) {
      return false;
    }
    for (int i = 0; i < links.length; i++) {
      if (links[i] != other[i]) {
        return false;
      }
    }
    return true;
  }

  int maxLinks() {
    int currentLinks = 0;
    int maxLinks = 0;
    for (bool link in links) {
      if (link) {
        currentLinks++;
        if (currentLinks > maxLinks) {
          maxLinks = currentLinks;
        }
      } else {
        currentLinks = 0;
      }
    }
    return maxLinks;
  }
}
