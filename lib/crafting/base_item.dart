import 'properties.dart';
import '../crafting/mod.dart';
import '../repository/mod_repo.dart';

class BaseItem implements Comparable<BaseItem> {

  String name;
  String itemClass;
  List<String> tags;
  List<Mod> implicits;
  WeaponProperties weaponProperties;
  ArmourProperties armourProperties;
  Requirements requirements;
  int itemLevel;
  String domain;
  
  BaseItem({
    this.name,
    this.itemClass,
    this.tags,
    this.weaponProperties,
    this.armourProperties,
    this.implicits,
    this.requirements,
    this.domain,
  });

  factory BaseItem.fromJson(Map<String, dynamic> json) {
    List<String> tags = new List<String>.from(json['tags']);
    //Garbage
    tags.remove("default");
    List<String> implicits = new List<String>.from(json['implicits']);
    List<Mod> implicitMods = implicits.map((id) => ModRepository.instance.getModById(id)).toList();
    WeaponProperties weaponProperties;
    ArmourProperties armourProperties;
    if (tags.contains("weapon")) {
      weaponProperties = WeaponProperties.fromJson(json['properties']);
    } else if (tags.contains("armour")) {
      armourProperties = ArmourProperties.fromJson(json['properties']);
    }
    return BaseItem(
      name: json['name'],
      itemClass: json['item_class'],
      tags: tags,
      implicits: implicitMods,
      weaponProperties: weaponProperties,
      armourProperties: armourProperties,
      requirements: Requirements.fromJson(json['requirements']),
      domain: json['domain'],
    );
  }

  @override
  String toString() {
    return name;
  }

  @override
  int compareTo(BaseItem other) {
    if (requirements == null || other.requirements == null) {
      return 0;
    }
    int reqCompare = requirements.reqString().compareTo(other.requirements.reqString());
    if (reqCompare != 0) {
      return reqCompare;
    } else {
      return other.requirements.level.compareTo(this.requirements.level);
    }
  }
}

class Requirements {
  int dexterity;
  int intelligence;
  int strength;
  int level;
  
  Requirements({
    this.dexterity,
    this.intelligence,
    this.strength,
    this.level
  });
  
  factory Requirements.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return Requirements(
      dexterity: json['dexterity'],
      intelligence: json['intelligence'],
      strength: json['strength'],
      level: json['level']
    );
  }

  String reqString() {
    String req = "";
    if (strength > 0) {
      req += "str";
    }
    if (intelligence > 0) {
      req += "int";
    }
    if (dexterity > 0) {
      req += "dex";
    }
    return req;
  }
}