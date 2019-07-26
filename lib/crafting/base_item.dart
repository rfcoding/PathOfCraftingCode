import 'properties.dart';
import '../crafting/mod.dart';
import '../repository/mod_repo.dart';

class BaseItem {

  String name;
  String itemClass;
  List<String> tags;
  List<Mod> implicits;
  WeaponProperties weaponProperties;
  ArmourProperties armourProperties;

  BaseItem({
    this.name,
    this.itemClass,
    this.tags,
    this.weaponProperties,
    this.armourProperties,
    this.implicits,
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
      armourProperties: armourProperties
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return name;
  }
}