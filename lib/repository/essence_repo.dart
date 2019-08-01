import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../crafting/essence.dart';
class EssenceRepository {

  EssenceRepository._privateConstructor();

  static final EssenceRepository instance = EssenceRepository
      ._privateConstructor();

  Map<String, List<Essence>> essenceMap;

  Future<bool> initialize() async {
    essenceMap = Map();
    var data = await rootBundle.loadString('data_repo/essences.json');
    Map<String, dynamic> jsonMap = json.decode(data);
    jsonMap.forEach((key, data) {
      Essence essence = Essence.fromJson(data);
      String mapKey = essence.name.split(" ").last;
      if (essence.mods.isNotEmpty) {
        if (essenceMap[mapKey] == null) {
          essenceMap[mapKey] = List();
        }
        essenceMap[mapKey].add(essence);
      }
    });
    essenceMap.values.forEach((essenceList) {
      essenceList.sort((a, b) => a.compareTo(b));
    });
    return true;
  }
}