import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../crafting/fossil.dart';

class FossilRepository {

  FossilRepository._privateConstructor();
  static final FossilRepository instance = FossilRepository._privateConstructor();

  List<Fossil> _fossils;

  Future<bool> initialize() async {
    _fossils = List();
    await loadFossilsFromJson();
    return true;
  }

  Future<bool> loadFossilsFromJson() async {
    var data = await rootBundle.loadString('data_repo/fossils.json');
    Map<String, dynamic> jsonMap = json.decode(data);
    jsonMap.forEach((key, data) {
      String name = key.split('/').last.replaceFirst("CurrencyDelveCrafting", "");
      Fossil fossil = Fossil.fromJson(name, data);
      _fossils.add(fossil);
    });
    return true;
  }

  Fossil getFossilByName(String name) {
    return _fossils.firstWhere((fossil) => fossil.name == name);
  }
}