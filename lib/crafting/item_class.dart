class ItemClass {
  String elderTag;
  String shaperTag;
  String name;

  ItemClass({this.elderTag, this.shaperTag, this.name});

  factory ItemClass.fromJson(Map<String, dynamic> json) {
    return ItemClass(
      elderTag: json['elder_tag'],
      shaperTag: json['shaper_tag'],
      name: json['name']
    );
  }
}
