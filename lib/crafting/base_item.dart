import 'properties.dart';

class BaseItem {

  String name;
  String itemClass;
  List<String> tags;
  WeaponProperties weaponProperties;
  ArmourProperties armourProperties;

  BaseItem({
    this.name,
    this.itemClass,
    this.tags,
    this.weaponProperties,
    this.armourProperties,
  });

  factory BaseItem.fromJson(Map<String, dynamic> json) {
    List<String> tags = new List<String>.from(json['tags']);
    //Garbage
    tags.remove("default");
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