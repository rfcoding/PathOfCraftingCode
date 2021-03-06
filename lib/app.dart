import 'package:flutter/material.dart';
import 'widgets/menu/main_widget.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "PoE clicker",
      home: MainWidget(),
      theme: ThemeData(
        fontFamily: 'Fontin',
        brightness: Brightness.dark,
        primaryColorDark: Colors.white,
        accentColor: Colors.black,
        buttonColor: Colors.amber[800],
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.amber[800],
          textTheme: ButtonTextTheme.accent
        )


      ),
    );
  }

}
