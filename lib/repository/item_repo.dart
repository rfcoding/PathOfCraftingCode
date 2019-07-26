import 'dart:async' show Future;
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import '../crafting/base_item.dart';

class ItemRepository {
  ItemRepository._privateConstructor();
  static final ItemRepository instance = ItemRepository._privateConstructor();

  Map<String, List<BaseItem>> itemClassMap;

  Future<bool> initialize() async {
    itemClassMap = Map();
    bool success = await loadBaseItemsFromJson();
    return success;
  }

  Future<bool> loadBaseItemsFromJson() async {
    var data = await rootBundle.loadString('data_repo/base_items.json');
    Map<String, dynamic> jsonMap = json.decode(data);
    jsonMap.forEach((key, data) {
      BaseItem item = BaseItem.fromJson(data);
      String itemClass = item.itemClass;
      if (itemClassMap[itemClass] == null) {
        itemClassMap[itemClass] = List();
      }
      if (data["domain"] == "item" && data["release_state"] == "released") {
        itemClassMap[itemClass].add(item);
      }
    });
    return true;
  }

  List<String> getItemBaseTypes() {
    return itemClassMap.keys.toList();
  }

  List<BaseItem> getBaseItemsForClass(String itemClass) {
    return itemClassMap[itemClass];
  }
}