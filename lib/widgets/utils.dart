import 'package:flutter/material.dart';

Widget imageButton(String assetPath, VoidCallback callback) {

  return InkWell(
    onTap: callback,
    child: Container(
      height: 54,
      width: 54,
      decoration: new BoxDecoration(
        border: Border.all(color: Color(0xFF2A221A), width: 1),
        image: DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.fill
        ),
      )
    ),
  );
}

Widget emptySquare() {
  return Container(
      height: 54,
      width: 54,
      decoration: new BoxDecoration(
        border: Border.all(color: Color(0xFF2A221A), width: 1),
        color: Colors.black
      )
  );
}