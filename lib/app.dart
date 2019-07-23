import 'package:flutter/material.dart';
import 'crafting/crafting_widget.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PoE clicker",
      home: CraftingWidget() 
    );
  }

}
