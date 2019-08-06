import 'dart:math';
import 'dart:convert';
import '../repository/translation_repo.dart';
import 'stat_translation.dart';

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

  factory Mod.copy(Mod mod) {
    List<Stat> newStats = List();
    mod.stats.forEach((stat) => newStats.add(Stat.copy(stat)));
    List<SpawnWeight> newSpawnWeights = List();
    mod.spawnWeights.forEach((spawnWeight) => newSpawnWeights.add(SpawnWeight.copy(spawnWeight)));
    return Mod(
        id: mod.id,
        name: mod.name,
        spawnWeights: newSpawnWeights,
        stats: newStats,
        isEssenceOnly: mod.isEssenceOnly,
        domain: mod.domain,
        generationType: mod.generationType,
        group: mod.group,
        type: mod.type,
        requiredLevel: mod.requiredLevel,
        tags: List.from(mod.tags),
    );
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

  List<TranslationWithSorting> getStatStringsWithSorting() {
    return TranslationRepository.instance.getTranslationFromStatsWithSorting(stats);
  }

  List<String> getStatStringWithValueRanges() {
    return TranslationRepository.instance.getTranslationFromStatsWithValueRanges(stats);
  }

  String debugString() {
    return "Name: $name, id: $id";
  }

  @override
  String toString() {
    return name;
  }

  void rerollStatValues() {
    for (Stat stat in stats) {
      stat.rollValue();
    }
  }

  String getGroupTagString() {
    return id.replaceAll(RegExp(r"[0-9]|[_]"), "");
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

  factory SpawnWeight.copy(SpawnWeight spawnWeight) {
    return SpawnWeight(weight: spawnWeight.weight, tag: spawnWeight.tag);
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
    Stat stat = Stat(id: json['id'], max: json['max'], min: json['min'], value: json['value']);
    if (stat.value == null) {
      stat.rollValue();
    }
    return stat;
  }

  factory Stat.copy(Stat stat) {
    return Stat(
      id: stat.id,
      max: stat.max,
      min: stat.min,
      value: stat.value
    );
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
