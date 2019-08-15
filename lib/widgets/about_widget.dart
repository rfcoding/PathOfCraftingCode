import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutWidget extends StatelessWidget {
  static const GIT_URL = 'https://github.com/rfcoding/pathofcrafting';
  static const PY_POE_URL = 'https://github.com/OmegaK2/PyPoE';
  static const RE_POE_URL = 'https://github.com/brather1ng/RePoE';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return Center(
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                child: Center(
                    child: new RichText(
                  textAlign: TextAlign.center,
                  text: new TextSpan(children: [
                    text(
                        "Path of Crafting is a crafting simulator for Path of Exile."),
                    text(
                        "\n\nThe data for the items and mods is collected by data mining the Path of Exile game files using the extractor tools "),
                    clickableText("PyPoe", () => _openPage(PY_POE_URL)),
                    text(" and "),
                    clickableText("RePoe. ", () => _openPage(RE_POE_URL)),
                    text(
                        "\n\nThe app is created and maintained by two developers who are completely independent from GGG and Path of Exile."),
                    text(
                        "\n\nIf you find any bugs or would like to read more about the project, please visit our github page using the button below."),
                    text(
                        "\n\nThank you for downloading our app and may RNGesus be with you!"),
                  ]),
                )),
              ),
            ),
          ),
          RaisedButton(
            onPressed: () => _openPage(GIT_URL),
            child: Text("TO WEBSITE", style: TextStyle(fontSize: 18),),
          ),
          SizedBox(height: 16,)
        ],
      ),
    );
  }

  void _openPage(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  TextSpan text(String text) {
    return TextSpan(
        text: text, style: TextStyle(fontSize: 16, fontFamily: 'Fontin'));
  }

  TextSpan clickableText(String text, Function onClick) {
    return TextSpan(
        recognizer: new TapGestureRecognizer()..onTap = onClick,
        text: text,
        style: TextStyle(
            fontSize: 16,
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontFamily: 'Fontin'));
  }
}
