import 'package:flutter/material.dart';

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
  });

  factory SpendingReport.fromJson(Map<String, dynamic> json) {
    return SpendingReport(
      exalt: json['exalt'],
      divine: json['divine'],
      annulment: json['annulment'],
      chaos: json['chaos'],
      regal: json['regal'],
      alteration: json['alteration'],
      alchemy: json['alchemy'],
      transmute: json['transmute'],
      scour: json['scour'],
      augmentation: json['augmentation'],
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
      "augmentation": augmentation
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
    listTiles.add(listTile("Scour", scour));
    listTiles.add(listTile("Augmentation", augmentation));
    return ListView(children: listTiles);
  }

  Widget listTile(String title, int spending) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 20),),
      trailing: Text(spending.toString(), style: TextStyle(fontSize: 20))
    );
  }
}