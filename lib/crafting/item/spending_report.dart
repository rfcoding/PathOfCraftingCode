import 'package:flutter/material.dart';
import 'package:poe_clicker/crafting/beast_craft.dart';
import 'dart:convert';
import '../fossil.dart';
import '../essence.dart';
import '../currency_type.dart';

class SpendingReport {
  Map<String, int> currencyMap;
  Map<String, int> fossilMap;
  Map<String, int> essenceMap;
  Map<String, int> beastMap;

  SpendingReport({
    this.currencyMap,
    this.fossilMap,
    this.essenceMap,
    this.beastMap,
  });

  factory SpendingReport.fromJson(Map<String, dynamic> data) {
    Map<String, int> currencyMap = Map();
    if (data['currency'] != null) {
      var currencyRaw = jsonDecode(data['currency']) as Map;
      if (currencyRaw != null) {
        currencyMap = currencyRaw.map((key, value) => MapEntry<String, int>(key, value));
      }
    }

    Map<String, int> fossilsMap = Map();
    if (data['fossils'] != null) {
      var fossilsRaw = jsonDecode(data['fossils']) as Map;
      if (fossilsRaw != null) {
        fossilsMap = fossilsRaw.map((key, value) => MapEntry<String, int>(key, value));
      }
    }

    Map<String, int> essenceMap = Map();
    if (data['essence'] != null) {
      var essencesRaw = jsonDecode(data['essence']) as Map;
      if (essencesRaw != null) {
        essenceMap = essencesRaw.map((key, value) => MapEntry<String, int>(key, value));
      }
    }

    Map<String, int> beastMap = Map();
    if(data['beast'] != null) {
      var beastsRaw = jsonDecode(data['beast']) as Map;
      if(beastsRaw != null) {
        beastMap = beastsRaw.map((key, value) => MapEntry<String, int>(key, value));
      }
    }

    return SpendingReport(
      currencyMap: currencyMap,
      fossilMap: fossilsMap,
      essenceMap: essenceMap,
      beastMap: beastMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "currency": json.encode(currencyMap),
      "fossils": json.encode(fossilMap),
      "essence": json.encode(essenceMap),
      "beast": json.encode(beastMap),
    };
  }

  void addSpending(String currency, int amount) {
    if (currencyMap == null) {
      currencyMap = Map();
    }
    if (currencyMap[currency] == null) {
      currencyMap[currency] = 0;
    }
    currencyMap[currency] += amount;
  }
  
  void spendFossils(List<Fossil> fossils) {
    if (fossilMap == null) {
      fossilMap = Map();
    }
    for (Fossil fossil in fossils) {
      if (fossilMap[fossil.name] == null) {
        fossilMap[fossil.name] = 0;
      }
      fossilMap[fossil.name] += 1;
    }
  }

  void spendEssence(Essence essence) {
    if (essenceMap == null) {
      essenceMap = Map();
    }
    if (essenceMap[essence.name] == null) {
      essenceMap[essence.name] = 0;
    }
    essenceMap[essence.name] += 1;
  }

  void spendBeast(BeastCraftCost cost){
    if(cost == null) {
      return;
    }
    if(beastMap == null) {
      beastMap = Map();
    }
    if(beastMap[cost.name] == null) {
      beastMap[cost.name] = 0;
    }
    beastMap[cost.name] += cost.count;
  }

  Widget getWidget() {
    List<Widget> listTiles = List();
    listTiles.add(expansionTileFromMap("Currency", currencyMap != null ? currencyMap : Map()));
    listTiles.add(expansionTileFromMap("Fossils", fossilMap != null ? fossilMap : Map()));
    listTiles.add(expansionTileFromMap("Essence", essenceMap != null ? essenceMap : Map()));
    listTiles.add(expansionTileFromMap("Beasts", beastMap != null ? beastMap : Map()));
    return ListView(children: listTiles);
  }

  Widget expansionTileFromMap(String title, Map<String, int> entries) {
    List<Widget> children = List();
    for (MapEntry<String, int> entry in entries.entries) {
      children.add(listTile(entry.key, entry.value));
    }
    return ExpansionTile(
      title: Text(title, style: TextStyle(fontSize: 20),),
      children: <Widget>[
        Column(children: children),
      ],
    );
  }

  Widget listTile(String title, int spending) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 20),),
      trailing: Text(spending.toString(), style: TextStyle(fontSize: 20))
    );
  }
}