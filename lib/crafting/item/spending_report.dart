import 'package:flutter/material.dart';
import 'dart:convert';
import '../fossil.dart';
import '../essence.dart';

class SpendingReport {
  int exalt;
  int divine;
  int annulment;
  int chaos;
  int regal;
  int alchemy;
  int scour;
  int alteration;
  int augmentation;
  int transmute;
  Map<String, int> fossilMap;
  Map<String, int> essenceMap;

  SpendingReport({
    this.exalt: 0,
    this.divine: 0,
    this.annulment: 0,
    this.chaos: 0,
    this.regal: 0,
    this.alteration: 0,
    this.alchemy: 0,
    this.transmute: 0,
    this.scour: 0,
    this.augmentation: 0,
    this.fossilMap,
    this.essenceMap,
  });

  factory SpendingReport.fromJson(Map<String, dynamic> data) {
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

    return SpendingReport(
      exalt: data['exalt'],
      divine: data['divine'],
      annulment: data['annulment'],
      chaos: data['chaos'],
      regal: data['regal'],
      alteration: data['alteration'],
      alchemy: data['alchemy'],
      transmute: data['transmute'],
      scour: data['scour'],
      augmentation: data['augmentation'],
      fossilMap: fossilsMap,
      essenceMap: essenceMap
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "exalt": exalt,
      "divine": divine,
      "annulment": annulment,
      "chaos": chaos,
      "regal": regal,
      "alteration": alteration,
      "alchemy": alchemy,
      "transmute": transmute,
      "scour": scour,
      "augmentation": augmentation,
      "fossils": json.encode(fossilMap),
      "essence": json.encode(essenceMap),
    };
  }

  void addSpending({
    exalt: 0,
    divine: 0,
    annulment: 0,
    chaos: 0,
    regal: 0,
    alteration: 0,
    alchemy: 0,
    transmute: 0,
    scour: 0,
    augmentation: 0
  }) {
    this.exalt += exalt;
    this.divine += divine;
    this.annulment += annulment;
    this.chaos += chaos;
    this.regal += regal;
    this.alteration += alteration;
    this.alchemy += alchemy;
    this.transmute += transmute;
    this.scour += scour;
    this.augmentation += augmentation;
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

  Widget getWidget() {
    List<Widget> listTiles = List();
    listTiles.add(listTile("Exalt", exalt));
    listTiles.add(listTile("Divine", divine));
    listTiles.add(listTile("Annulment", annulment));
    listTiles.add(listTile("Chaos", chaos));
    listTiles.add(listTile("Regal", regal));
    listTiles.add(listTile("Alteration", alteration));
    listTiles.add(listTile("Alchemy", alchemy));
    listTiles.add(listTile("Transmute", transmute));
    listTiles.add(listTile("Scouring", scour));
    listTiles.add(listTile("Augmentation", augmentation));
    if (fossilMap != null && fossilMap.isNotEmpty) {
      listTiles.add(expansionTileFromMap("Fossils", fossilMap));
    }
    if (essenceMap != null && essenceMap.isNotEmpty) {
      listTiles.add(expansionTileFromMap("Essence", essenceMap));
    }
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