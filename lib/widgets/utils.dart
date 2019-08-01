import 'package:flutter/material.dart';

Widget imageButton(String assetPath, VoidCallback callback) {
  return InkWell(
    onTap: callback,
    child: Container(
        padding: EdgeInsets.all(8.0),
        child: Image.asset(assetPath, height: 36, width: 36,)
    ),
  );
}