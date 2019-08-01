import 'dart:math';
import 'dart:convert';
import '../repository/translation_repo.dart';

class Mod implements Comparable<Mod> {
  String id;
  String name;
  List<SpawnWeight> spawnWeights;
  List<Stat> stats;
  bool isEssenceOnly;
  String domain;
  String generationType;
  String group;
  String type;
  int requiredLevel;
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
    this.requiredLevel,
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
        requiredLevel: json['required_level'],
        tags: tags);
  }

  factory Mod.fromSavedJson(Map<String, dynamic> data) {
    var key = data['id'];
    List<String> tags = new List<String>.from(json.decode(data['tags']));
    return Mod.fromJson(key, data, tags);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "spawn_weights": SpawnWeight.encodeToJson(spawnWeights),
      "stats": Stat.encodeToJson(stats),
      "is_essence_only": isEssenceOnly,
      "domain": domain,
      "generation_type": generationType,
      "group": group,
      "type": type,
      "required_level": requiredLevel,
      "tags": json.encode(tags)
    };
  }

  static List encodeToJson(List<Mod> mods) {
    List jsonList = List();
    mods.forEach((mod) => jsonList.add(mod.toJson()));
    return jsonList;
  }

  List<String> getStatStrings() {
    return TranslationRepository.instance.getTranslationFromStats(stats);
  }

  List<String> getStatStringWithValueRanges() {
    return TranslationRepository.instance.getTranslationFromStatsWithValueRanges(stats);
  }

  String debugString() {
    return "Name: $name, id: $id";
  }

  void rerollStatValues() {
    for (Stat stat in stats) {
      stat.rollValue();
    }
  }

  @override
  int compareTo(Mod other) {
    if (domain == "crafted") {
      return 1;
    }
    if (other.domain == "crafted") {
      return -1;
    }
    return (generationType + group).compareTo(other.generationType + group);
  }
}

class SpawnWeight {
  int weight;
  String tag;

  SpawnWeight({this.weight, this.tag});

  factory SpawnWeight.fromJson(Map<String, dynamic> json) {
    return SpawnWeight(weight: json['weight'], tag: json['tag']);
  }

  Map<String, dynamic> toJson() {
    return {
      "weight": weight,
      "tag": tag
    };
  }

  static List encodeToJson(List<SpawnWeight> spawnWeights) {
    List jsonList = List();
    spawnWeights.forEach((spawnWeight) => jsonList.add(spawnWeight.toJson()));
    return jsonList;
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

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "max": max,
      "min": min,
      "value": value
    };
  }

  static List encodeToJson(List<Stat> stats) {
    List jsonList = List();
    stats.forEach((stat) => jsonList.add(stat.toJson()));
    return jsonList;
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

class RemoveMods {}
