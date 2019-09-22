class ItemClass {
  String id;
  String elderTag;
  String shaperTag;
  String name;

  ItemClass({this.id, this.elderTag, this.shaperTag, this.name});

  factory ItemClass.fromJson(String id, Map<String, dynamic> json) {
    return ItemClass(
      id: id,
      elderTag: json['elder_tag'],
      shaperTag: json['shaper_tag'],
      name: json['name']
    );
  }
}
