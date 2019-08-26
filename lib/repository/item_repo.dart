import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../crafting/base_item.dart';
import '../crafting/item_class.dart';

class ItemRepository {
  ItemRepository._privateConstructor();
  static final ItemRepository instance = ItemRepository._privateConstructor();

  Map<String, List<BaseItem>> itemClassToBaseItemMap;
  Map<String, ItemClass> itemClassMap;
  Map<String, BaseItem> baseItemMap;

  Future<bool> initialize() async {
    itemClassToBaseItemMap = Map();
    itemClassMap = Map();
    baseItemMap = Map();
    List<bool> answer = await Future.wait({loadBaseItemsFromJson(), loadItemClassesFromJson()});
    bool success = answer.reduce((value, element) => value && element);
    for (List<BaseItem> baseItems in itemClassToBaseItemMap.values) {
      baseItems.sort((a, b) => a.compareTo(b));
    }
    return success;
  }

  Future<bool> loadBaseItemsFromJson() async {
    var data = await rootBundle.loadString('data_repo/base_items.json');
    Map<String, dynamic> jsonMap = json.decode(data);
    jsonMap.forEach((key, data) {
      BaseItem item = BaseItem.fromJson(data);
      baseItemMap[key] = item;
      String itemClass = item.itemClass;

      if (shouldLoadDomain(data["domain"]) && data["release_state"] == "released") {
        if (itemClassToBaseItemMap[itemClass] == null) {
          itemClassToBaseItemMap[itemClass] = List();
        }
        itemClassToBaseItemMap[itemClass].add(item);
      }
    });
    return true;
  }

  bool shouldLoadDomain(String domain) {
    return domain == "item" || domain == "misc" || domain == "abyss_jewel";
  }

  Future<bool> loadItemClassesFromJson() async {
    var data = await rootBundle.loadString('data_repo/item_classes.json');
    Map<String, dynamic> jsonMap = json.decode(data);
    jsonMap.forEach((key, data) {
      ItemClass itemClass = ItemClass.fromJson(data);
      itemClassMap[key] = itemClass;
    });
    return true;
  }

  List<String> getItemBaseTypes() {
    return itemClassToBaseItemMap.keys.toList();
  }

  List<BaseItem> getBaseItemsForClass(String itemClass) {
    return itemClassToBaseItemMap[itemClass];
  }

  String getElderTagForItemClass(String id) {
    ItemClass itemClass = itemClassMap[id];
    if (itemClass == null) {
      throw ArgumentError("No such item class");
    }
    return itemClass.elderTag;
  }

  String getShaperTagForItemClass(String id) {
    ItemClass itemClass = itemClassMap[id];
    if (itemClass == null) {
      throw ArgumentError("No such item class");
    }
    return itemClass.shaperTag;
  }
}