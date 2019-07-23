class Mod {
  String id;
  String name;
  int value;
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
    return name;
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

  Stat({this.id, this.max, this.min});

  factory Stat.fromJson(Map<String, dynamic> json) {
    return Stat(id: json['id'], max: json['max'], min: json['min']);
  }
}
