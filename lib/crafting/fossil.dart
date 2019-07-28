
class Fossil {
  static const NAME_MAP = {
    'Abyss' : 'Hollow',
    'AttackMods' : 'Serrated',
    'BleedPoison' : 'Corroded',
    'CasterMods' : 'Aetheric',
    'Chaos' : 'Aberrant',
    'Cold' : 'Frigid',
    'CorruptEssence' : 'Glyphic',
    'Defences' : 'Dense',
    'Elemental' : 'Prismatic',
    'Enchant' : 'Enchanted',
    'Fire' : 'Scorched',
    'GemLevel' : 'Faceted',
    'Life' : 'Pristine',
    'Lightning' : 'Metallic',
    'LuckyModRolls' : 'Sanctified',
    'Mana' : 'Lucent',
    'MinionsAuras' : 'Bound',
    'Mirror' : 'Fractured',
    'Physical' : 'Jagged',
    'Random' : 'Tangled',
    'SellPrice' : 'Gilded',
    'Sockets' : 'Encrusted',
    'Speed' : 'Shuddering',
    'Vaal' : 'Bloodstained',
  };

  List<FossilModWeight> positiveModWeights;
  List<FossilModWeight> negativeModWeights;
  List<String> addedMods;
  String name;

  Fossil({
    this.positiveModWeights,
    this.negativeModWeights,
    this.addedMods,
    this.name,
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
      name: name,
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