import 'dart:async' show Future;
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import '../crafting/essence.dart';
class EssenceRepository {

  EssenceRepository._privateConstructor();

  static final EssenceRepository instance = EssenceRepository
      ._privateConstructor();

  Random rng = Random();
  Map<String, List<Essence>> essenceMap;

  final List<String> corruptedEssenceIds = List.of([
    "Metadata/Items/Currency/CurrencyEssenceHysteria1",
    "Metadata/Items/Currency/CurrencyEssenceInsanity1",
    "Metadata/Items/Currency/CurrencyEssenceDelirium1",
    "Metadata/Items/Currency/CurrencyEssenceHorror1"
  ]);

  List<Essence> corruptedEssences = List();

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
      if (corruptedEssenceIds.contains(key)) {
        corruptedEssences.add(essence);
      }
    });
    essenceMap.values.forEach((essenceList) {
      essenceList.sort((a, b) => a.compareTo(b));
    });
    return true;
  }

  Essence getRandomCorruptedEssence() {
    int index = rng.nextInt(corruptedEssences.length);
    return corruptedEssences[index];
  }
}