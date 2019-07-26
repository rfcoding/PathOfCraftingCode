import 'package:flutter/material.dart';
import 'widgets/main_widget.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PoE clicker",
      home: MainWidget()
    );
  }

}
