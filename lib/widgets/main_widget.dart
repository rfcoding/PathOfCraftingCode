import 'package:flutter/material.dart';

import '../repository/fossil_repo.dart';
import '../repository/mod_repo.dart';
import '../repository/item_repo.dart';
import '../repository/translation_repo.dart';
import '../widgets/item_select_widget.dart';

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
          .then((ignore) => FossilRepository.instance.initialize()),
      TranslationRepository.instance.initialize()})
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
        title: Text("PoE Crafting"),
      ),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    if (!_isInitialized) {
      return Center(child: Text("Loading..."));
    }
    return Center(
      child: RaisedButton(
        onPressed: _navigateToItemSelectWidget,
        child: Text("Craft!"),
      ),
    );
  }

  void _navigateToItemSelectWidget() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ItemSelectWidget()));
  }
}