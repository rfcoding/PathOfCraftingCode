import 'package:flutter/material.dart';

import '../repository/fossil_repo.dart';
import '../repository/mod_repo.dart';
import '../repository/item_repo.dart';
import '../repository/translation_repo.dart';
import '../repository/crafting_bench_repo.dart';
import '../repository/crafted_items_storage.dart';
import '../repository/essence_repo.dart';
import 'fusing_widget.dart';
import 'item_select_widget.dart';
import 'saved_items_widget.dart';
import 'about_widget.dart';

class MainWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return MainWidgetState();
  }
}

class MainWidgetState extends State<MainWidget> {
  bool _isInitialized = false;

  @override
  void initState() {
    Future.wait({
      ModRepository.instance.initialize()
          .then((ignore) => ItemRepository.instance.initialize())
          .then((ignore) => FossilRepository.instance.initialize())
          .then((ignore) => CraftingBenchRepository.instance.initialize()),
      TranslationRepository.instance.initialize(),
      CraftedItemsStorage.instance.initialize(),
      EssenceRepository.instance.initialize()})
        .then((success) {
        setState(() {
          _isInitialized = success.reduce((value, element) => value && element);
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Path of Crafting"),
      ),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    if (!_isInitialized) {
      return Center(child: Text("Loading..."));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: Image(image: AssetImage("assets/icon/icon.png"),),
        ),
        Center(
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: _navigateToItemSelectWidget,
                  child: Text("Craft New Item"),
                ),
                SizedBox(height: 8),
                RaisedButton(
                  onPressed: _navigateToSavedItemsWidget,
                  child: Text("Load Item"),
                ),
                SizedBox(height: 8,),
                RaisedButton(
                  onPressed: _navigateToFusingSimulator,
                  child: Text("Fusing Simulator"),
                ),
                SizedBox(height: 8,),
                RaisedButton(
                  onPressed: _navigateToAboutWidget,
                  child: Text("About"),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToItemSelectWidget() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ItemSelectWidget()));
  }

  void _navigateToSavedItemsWidget() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SavedItemsWidget()));
  }
  
  void _navigateToAboutWidget() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AboutWidget()));
  }

  void _navigateToFusingSimulator() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FusingWidget()));
  }
}