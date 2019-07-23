class Mod {
  String id;
  String name;
  int value;
  List<dynamic> spawnWeights;
  bool isEssenceOnly;
  String domain;
  String generationType;

  Mod({
    this.id,
    this.name,
    this.spawnWeights,
    this.isEssenceOnly,
    this.domain,
    this.generationType,
  });

  factory Mod.fromJson(String key, Map<String, dynamic> json) {
    return Mod(
        id: key,
        name: json['name'],
        spawnWeights: json['spawn_weights'],
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
