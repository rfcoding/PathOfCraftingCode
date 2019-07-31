import 'dart:async' show Future;
import 'dart:convert';
import 'package:localstorage/localstorage.dart';
import '../crafting/item/item.dart';

class CraftedItemsStorage {
  static const STORAGE_KEY = 'saved_items';
  static const ITEMS_KEY = 'items';
  CraftedItemsStorage._privateConstructor();
  static final CraftedItemsStorage instance = CraftedItemsStorage._privateConstructor();

  LocalStorage localStorage;
  bool _initialized = false;

  Future<bool> initialize() async {
    localStorage = LocalStorage(STORAGE_KEY);
    localStorage.clear();
    await localStorage.setItem(ITEMS_KEY, List());
    _initialized = true;
    return _initialized;
  }

  List<Item> loadItems() {
    var list = localStorage.getItem(ITEMS_KEY) as List;
    if (list != null) {
      List<Item> items = list.map((json) => Item.fromJson(json)).where((item) => item != null).toList();
      return items;
    }
    return List();
  }

  Future<bool> saveItem(Item item) async {
    assert(_initialized);
    List<Item> items = loadItems();
    items.add(item);
    List data = Item.encodeToJson(items);
    await localStorage.setItem(ITEMS_KEY, data);
    return true;
  }

  Future<void> removeItem(int index) async {
    List<Item> items = loadItems();
    items.removeAt(index);
    return await localStorage.setItem(ITEMS_KEY, Item.encodeToJson(items));
  }
}