
class Fossil {
  List<FossilModWeight> positiveModWeights;
  List<FossilModWeight> negativeModWeights;
  List<String> addedMods;
  List<String> forcedMods;
  List<String> descriptions;
  String name;
  bool enchants;
  int corruptEssenceChance;

  Fossil({
    this.positiveModWeights,
    this.negativeModWeights,
    this.addedMods,
    this.forcedMods,
    this.descriptions,
    this.name,
    this.enchants,
    this.corruptEssenceChance,
  });

  factory Fossil.fromJson(String name, Map<String, dynamic> json) {
    var positiveModWeightsBlob = json['positive_mod_weights'] as List;
    List<FossilModWeight> positiveModWeights =
    positiveModWeightsBlob.map((s) => FossilModWeight.fromJson(s)).toList();

    var negativeModWeightsBlob = json['negative_mod_weights'] as List;
    List<FossilModWeight> negativeModWeights =
    negativeModWeightsBlob.map((s) => FossilModWeight.fromJson(s)).toList();

    return Fossil(
      positiveModWeights: positiveModWeights,
      negativeModWeights: negativeModWeights,
      addedMods: new List<String>.from(json['added_mods']),
      forcedMods: new List<String>.from(json['forced_mods']),
      descriptions: new List<String>.from(json['descriptions']),
      name: name,
      enchants: json['enchants'],
      corruptEssenceChance: json['corrupted_essence_chance']
    );
  }
}

class FossilModWeight {
  String tag;
  int weight;

  FossilModWeight({
    this.tag,
    this.weight,
  });

  factory FossilModWeight.fromJson(Map<String, dynamic> json) {
    return FossilModWeight(
      tag: json['tag'],
      weight: json['weight']
    );
  }
}