
class WeaponProperties {
  int attackTime;
  int criticalStrikeChance;
  int physicalDamageMax;
  int physicalDamageMin;
  int range;

  WeaponProperties(
      {this.attackTime,
        this.criticalStrikeChance,
        this.physicalDamageMax,
        this.physicalDamageMin,
        this.range});

  factory WeaponProperties.fromJson(json) {
    return WeaponProperties(
      attackTime: json['attack_time'],
      criticalStrikeChance: json['critical_strike_chance'],
      physicalDamageMax: json['physical_damage_max'],
      physicalDamageMin: json['physical_damage_min'],
      range: json['range'],
    );
  }

  /*
  int attackTime;
  int criticalStrikeChance;
  int physicalDamageMax;
  int physicalDamageMin;
  int range;
   */
  Map<String, dynamic> toJson() {
    return {
      "attack_time": attackTime,
      "critical_strike_chance": criticalStrikeChance,
      "physical_damage_min": physicalDamageMin,
      "physical_damage_max": physicalDamageMax,
      "range": range
    };
  }
}

class ArmourProperties {
  int evasion;
  int energyShield;
  int armour;
  int block;

  ArmourProperties({
    this.evasion,
    this.energyShield,
    this.armour,
    this.block,
  });

  factory ArmourProperties.fromJson(json) {
    return ArmourProperties(
      evasion: json['evasion'],
      energyShield: json['energy_shield'],
      armour: json['armour'],
      block: json['block'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "evasion": evasion,
      "energy_shield": energyShield,
      "armour": armour,
      "block": block,
    };
  }
}