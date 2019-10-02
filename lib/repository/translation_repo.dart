import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../crafting/stat_translation.dart';
import '../crafting/mod.dart' show Stat;

class TranslationRepository {
  TranslationRepository._privateConstructor();

  static final TranslationRepository instance =
      TranslationRepository._privateConstructor();

  Map<String, StatTranslation> _translations;

  Future<bool> initialize() async {
    _translations = Map();
    bool success = await loadStatTranslationJSONFromLocalStorage();
    print("Number of translations: ${_translations.length}");
    print("Translations: $_translations");
    return success;
  }

  Future<bool> loadStatTranslationJSONFromLocalStorage() async {
    var data = await rootBundle.loadString('data_repo/stat_translations.json');
    var jsonList = json.decode(data);
    for (int statIndex = 0; statIndex < jsonList.length; statIndex++) {
      var data = jsonList[statIndex];
      List<String> ids = new List<String>.from(data['ids']);
      for (int i = 0; i < ids.length; i++) {
        StatTranslation statTranslation =
            StatTranslation.fromJson(i, ids, statIndex, data["English"]);
        _translations[ids[i]] = statTranslation;
      }
    }
    return true;
  }

  List<String> getTranslationFromStats(List<Stat> stats) {
    List<StatTranslation> statTranslations = getStatTranslations(stats);

    return statTranslations
        .map((translation) => translation.getTranslationFromStats(stats))
        .where((translation) => translation != null)
        .toSet()
        .toList();
  }

  List<TranslationWithSorting> getTranslationFromStatsWithSorting(
      List<Stat> stats) {
    List<StatTranslation> statTranslations = getStatTranslations(stats);

    return statTranslations
        .map((translation) => TranslationWithSorting(
            translation: translation.getTranslationFromStats(stats),
            sorting: translation.sortingIndex))
        .where((translation) => translation.translation != null)
        .toSet()
        .toList();
  }

  List<String> getTranslationFromStatsWithValueRanges(List<Stat> stats) {
    List<StatTranslation> statTranslations = getStatTranslations(stats);

    return statTranslations
        .map((translation) =>
            translation.getTranslationFromStatsWithValueRanges(stats))
        .where((translation) => translation != null)
        .toSet()
        .toList();
  }

  List<String> getTranslationFromStatsWithValueAndRanges(List<Stat> stats) {
    List<StatTranslation> statTranslations = getStatTranslations(stats);

    return statTranslations
        .map((translation) =>
            translation.getTranslationFromStatsWithValueAndRanges(stats))
        .where((translation) => translation != null)
        .toSet()
        .toList();
  }

  List<StatTranslation> getStatTranslations(List<Stat> stats) {
    List<StatTranslation> statTranslations = List();
    for (Stat stat
        in stats.where((stat) => stat.id != "dummy_stat_display_nothing")) {
      StatTranslation statTranslation = _translations[stat.id];
      if (statTranslation != null &&
          !statTranslations.contains(statTranslation)) {
        statTranslations.add(statTranslation);
      }
    }
    return statTranslations;
  }
}
