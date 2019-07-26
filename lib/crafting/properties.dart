
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
}

class ArmourProperties {
  int evasion;
  int energyShield;
  int armour;

  ArmourProperties({
    this.evasion,
    this.energyShield,
    this.armour
  });

  factory ArmourProperties.fromJson(json) {
    return ArmourProperties(
      evasion: json['evasion'],
      energyShield: json['energy_shield'],
      armour: json['armour'],
    );
  }
}