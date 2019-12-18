class ItemClass {
  String id;
  String elderTag;
  String shaperTag;
  String crusaderTag;
  String hunterTag;
  String redeemerTag;
  String warlordTag;
  String name;

  ItemClass({this.id, this.elderTag, this.shaperTag, this.crusaderTag, this.hunterTag, this.redeemerTag, this.warlordTag, this.name});

  factory ItemClass.fromJson(String id, Map<String, dynamic> json) {
    return ItemClass(
      id: id,
      elderTag: json['elder_tag'],
      shaperTag: json['shaper_tag'],
        crusaderTag: json['crusader_tag'],
        hunterTag: json['hunter_tag'],
        redeemerTag: json['redeemer_tag'],
        warlordTag: json['warlord_tag'],
      name: json['name']
    );
  }
}
