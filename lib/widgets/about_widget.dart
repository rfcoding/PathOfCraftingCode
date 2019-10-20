import 'package:flutter/material.dart';
import 'utils.dart';

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
                    whiteText(
                        "Path of Crafting is a crafting simulator for Path of Exile.", 16),
                    whiteText(
                        "\n\nThe data for the items and mods is collected by data mining the Path of Exile game files using the extractor tools ", 16),
                    clickableText("PyPoe", () => openPage(PY_POE_URL)),
                    whiteText(" and ", 16),
                    clickableText("RePoe. ", () => openPage(RE_POE_URL)),
                    whiteText(
                        "\n\nThe app is created and maintained by two developers who are completely independent from GGG and Path of Exile.", 16),
                    whiteText(
                        "\n\nIf you find any bugs or would like to read more about the project, please visit our github page using the button below.", 16),
                    whiteText(
                        "\n\nThank you for downloading our app and may RNGesus be with you!", 16),
                  ]),
                )),
              ),
            ),
          ),
          RaisedButton(
            onPressed: () => openPage(GIT_URL),
            child: Text("TO WEBSITE", style: TextStyle(fontSize: 18),),
          ),
          SizedBox(height: 16,)
        ],
      ),
    );
  }
}
