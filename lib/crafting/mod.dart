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
  String group;
  String type;
  List<String> tags;

  Mod({
    this.id,
    this.name,
    this.spawnWeights,
    this.stats,
    this.isEssenceOnly,
    this.domain,
    this.generationType,
    this.group,
    this.type,
    this.tags
  });

  factory Mod.fromJson(String key, Map<String, dynamic> json, List<String> tags) {
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
        generationType: json['generation_type'],
        group: json['group'],
        type: json['type'],
        tags: tags);
  }

  List<String> getStatStrings() {
    return TranslationRepository.instance.getTranslationFromStats(stats);
  }

  String debugString() {
    return "Name: $name, id: $id";
  }

  void rerollStatValues() {
    for (Stat stat in stats) {
      stat.rollValue();
    }
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
      value = rng.nextInt(range + 1) + min;
    } on RangeError {
      print("Range: $range");
      value = max;
    }
  }
}
