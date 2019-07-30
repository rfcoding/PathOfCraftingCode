import 'mod.dart' show Stat;

class StatTranslation {
  List<String> ids;
  List<Translation> translations;

  StatTranslation({this.ids, this.translations});

  factory StatTranslation.fromJson(int index, List<String> ids, List<dynamic> json) {
    List<Translation> translationList =
    json.map((e) => Translation.fromJson(index, e)).toList();
    return StatTranslation(
      ids: ids,
      translations: translationList
    );
  }

  String getTranslationFromStats(List<Stat> stats) {

    List<Stat> statsToUse = List();
    for (Stat stat in stats) {
      if (ids.contains(stat.id)) {
        statsToUse.add(stat);
      }
    }

    if (translations.length == 1) {
      return formatTranslation(translations[0], statsToUse);
    } else if (statsToUse.length == 1) {
      for (Translation translation in translations) {
        if (translation.conditionIsTrue(stats[0])) {
          return formatTranslation(translation, stats);
        }
      }
    }

    return "No translation found";
  }

  String getTranslationFromStatsWithValueRanges(List<Stat> stats) {

    List<Stat> statsToUse = List();
    for (Stat stat in stats) {
      if (ids.contains(stat.id)) {
        statsToUse.add(stat);
      }
    }

    if (translations.length == 1) {
      return formatTranslationWithValueRanges(translations[0], statsToUse);
    } else if (statsToUse.length == 1) {
      for (Translation translation in translations) {
        if (translation.conditionIsTrue(stats[0])) {
          return formatTranslationWithValueRanges(translation, stats);
        }
      }
    }

    return "No translation found";
  }

  //TODO: use this later to combine stats with same effect, e.g. inc phys damage + inc phys + acc
  TranslationValueHolder createTranslationValueHolder(Translation translation, List<Stat> stats) {
    if (stats.length == 1) {
      return TranslationValueHolder(first: stats[0].value, translation: translation);
    } else if (stats.length == 2) {
      int first;
      int second;
      for (Stat stat in stats) {
        int index = ids.indexOf(stat.id);
        if (index == 0) {
          first = stat.value;
        } else if (index == 1) {
          second = stat.value;
        }
      }
      return TranslationValueHolder(first: first, second: second, translation: translation);
    }
    return null;
  }

  String formatTranslation(Translation translation, List<Stat> stats) {
    if (stats.length == 1) {
      return translation.string.replaceFirst("{0}", translation.format.replaceFirst("#", stats[0].value.toString()));
    } else if (stats.length == 2) {
      String text = translation.string;
      for (Stat stat in stats) {
        int index = ids.indexOf(stat.id);
        text = text.replaceFirst("{$index}", translation.format.replaceFirst("#",stat.value.toString()));
      }
      return text;
    }
    return translation.string;
  }

  String formatTranslationWithValueRanges(Translation translation, List<Stat> stats) {
    if (stats.length == 1) {
      if (stats[0].min == stats[0].max) {
        return translation.string.replaceFirst("{0}", translation.format.replaceFirst("#", stats[0].value.toString()));
      }
      return translation.string.replaceFirst("{0}", translation.format.replaceFirst("#", "(${stats[0].min.toString()}-${stats[0].max.toString()})"));
    } else if (stats.length == 2) {
      String text = translation.string;
      for (Stat stat in stats) {
        int index = ids.indexOf(stat.id);
        if (stat.min == stat.max) {
          text = text.replaceFirst("{$index}", translation.format.replaceFirst("#",stat.value.toString()));
        }
        text = text.replaceFirst("{$index}", translation.format.replaceFirst("#", "(${stat.min.toString()}-${stat.max.toString()})"));
      }
      return text;
    }
    return translation.string;
  }
}

class Translation {
  String string;
  String format;
  Map<String, dynamic> condition;

  Translation({this.string, this.format, this.condition});

  factory Translation.fromJson(int index, Map<String, dynamic> json) {
    return Translation(
      string: json['string'],
      format: json['format'][index],
      condition: json['condition'][index]
    );
  }

  bool conditionIsTrue(Stat stat) {
    if (condition.isEmpty) {
      return false;
    }

    for (MapEntry<String, dynamic> comparator in condition.entries) {
      switch (comparator.key) {
        case "max":
          if (stat.value > comparator.value) {
            return false;
          }
          break;
        case "min":
          if (stat.value < comparator.value) {
            return false;
          }
          break;
        default:
          print("Key: ${comparator.key}");
          break;
      }
    }
    return true;
  }
}

class TranslationValueHolder {
  int first;
  int second;
  Translation translation;

  TranslationValueHolder({
    this.first,
    this.second,
    this.translation
  });
}
