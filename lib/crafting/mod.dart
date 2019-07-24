import 'dart:math';
import '../repository/translation_repo.dart';

class Mod {
  String id;
  String name;
  List<SpawnWeight> spawnWeights;
  List<Stat> stats;
  bool isEssenceOnly;
  String domain;
  String generationType;

  Mod({
    this.id,
    this.name,
    this.spawnWeights,
    this.stats,
    this.isEssenceOnly,
    this.domain,
    this.generationType,
  });

  factory Mod.fromJson(String key, Map<String, dynamic> json) {
    var spawnWeights = json['spawn_weights'] as List;
    List<SpawnWeight> spawnWeightList =
        spawnWeights.map((s) => SpawnWeight.fromJson(s)).toList();

    var stats = json['stats'] as List;
    List<Stat> statList = stats.map((s) => Stat.fromJson(s)).toList();
    return Mod(
        id: key,
        name: json['name'],
        spawnWeights: spawnWeightList,
        stats: statList,
        isEssenceOnly: json['is_essence_only'],
        domain: json['domain'],
        generationType: json['generation_type']);
  }

  @override
  String toString() {
    return TranslationRepository.instance.getTranslationFromStat(stats[0]);
  }

  List<String> getStatStrings() {
    return TranslationRepository.instance.getTranslationFromStats(stats);
  }

  String debugString() {
    return "Name: $name, id: $id";
  }
}

class SpawnWeight {
  int weight;
  String tag;

  SpawnWeight({this.weight, this.tag});

  factory SpawnWeight.fromJson(Map<String, dynamic> json) {
    return SpawnWeight(weight: json['weight'], tag: json['tag']);
  }
}

class Stat {
  String id;
  int max;
  int min;
  int value;

  Stat({this.id, this.max, this.min, this.value});

  factory Stat.fromJson(Map<String, dynamic> json) {
    Stat stat = Stat(id: json['id'], max: json['max'], min: json['min'], value: json['min']);
    stat.rollValue();
    return stat;
  }

  void rollValue() {
    int range = max - min;
    if (range == null || range < 1) {
      value = max;
      return;
    }
    var rng = new Random();
    try {
      value = rng.nextInt(range) + min;
    } on RangeError {
      print("Range: $range");
      value = max;
    }
  }
}
