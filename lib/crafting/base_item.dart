
class BaseItem {

  String name;
  String itemClass;
  List<String> tags;

  BaseItem({
    this.name,
    this.itemClass,
    this.tags,
  });

  factory BaseItem.fromJson(Map<String, dynamic> json) {
    return BaseItem(
      name: json['name'],
      itemClass: json['item_class'],
      tags: new List<String>.from(json['tags']),
    );
  }
}