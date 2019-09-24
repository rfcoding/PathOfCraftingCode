import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget imageButton(String assetPath, String tooltip, VoidCallback callback) {
  return Expanded(
    flex: 1,
    child: Tooltip(
      child: InkWell(
        onTap: callback,
        child: Container(
          decoration: new BoxDecoration(
            border: Border.all(color: Color(0xFF2A221A), width: 1),
          ),
          child: Image(image: AssetImage(assetPath),),
        ),
      ), message: tooltip,
    ),
  );
}

Widget disabledImageButton(String assetPath, String tooltip, VoidCallback callback) {
  return Expanded(
    flex: 1,
    child: Tooltip(
      child: InkWell(
        onTap: callback,
        child: Container(
          decoration: new BoxDecoration(
            border: Border.all(color: Color(0xFF2A221A), width: 1),
          ),
          child: Image(image: AssetImage(assetPath), color: Color(0xA00E0E0E), colorBlendMode: BlendMode.srcATop,),
        ),
      ), message: tooltip,
    ),
  );
}

Widget squareImageButton(String assetPath, String tooltip, VoidCallback callback, double size) {
  return Tooltip(
    child: InkWell(
      onTap: callback,
      child: Container(
        height: size,
        width: size,
        decoration: new BoxDecoration(
          border: Border.all(color: Color(0xFF2A221A), width: 1),
        ),
        child: Image(image: AssetImage(assetPath), ),
      ),
    ), message: tooltip,
  );
}

Widget iconButton(String assetPath, String tooltip, VoidCallback callback) {
  return Expanded(
    flex: 1,
    child: Tooltip(
      child: InkWell(
        onTap: callback,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(
                border: Border.all(color: Color(0xFF2A221A), width: 1),
              ),
              child: Image(image: AssetImage(assetPath), ),
            ),
            Icon(Icons.repeat, color: Colors.amber[800],)
          ] ,
        ),
      ), message: tooltip,
    ),
  );
}

Widget emptySquare() {
  return Expanded(
    flex: 1,
    child: Container(
        decoration: new BoxDecoration(
          border: Border.all(color: Color(0xFF2A221A), width: 1),
          color: Colors.black
        ),
        child: Image(image: AssetImage('assets/images/empty.png'), ),
    ),
  );
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

void openPage(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
