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

  String formatTranslation(Translation translation, List<Stat> stats) {
    if (stats.length == 1) {
      return translation.string.replaceFirst("{0}", translation.formatWithSign(stats[0]));
    } else if (stats.length == 2) {
      String text = translation.string;
      for (Stat stat in stats) {
        int index = ids.indexOf(stat.id);
        text = text.replaceFirst("{$index}", translation.formatWithSign(stat));
      }
      return text;
    }
    return translation.string;
  }

  String formatTranslationWithValueRanges(Translation translation, List<Stat> stats) {
    if (stats.length == 1) {
      if (stats[0].min == stats[0].max) {
        return translation.string.replaceFirst("{0}", translation.formatWithSign(stats[0]));
      }
      return translation.string.replaceFirst("{0}", translation.formatRangeWithSign(stats[0]));
    } else if (stats.length == 2) {
      String text = translation.string;
      for (Stat stat in stats) {
        int index = ids.indexOf(stat.id);
        if (stat.min == stat.max) {
          text = text.replaceFirst("{$index}", translation.formatWithSign(stat));
        }
        text = text.replaceFirst("{$index}", translation.formatRangeWithSign(stat));
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
  List<String> indexHandlers;

  Translation({this.string, this.format, this.condition, this.indexHandlers});

  factory Translation.fromJson(int index, Map<String, dynamic> json) {
    List<dynamic> indexHandlers = List<dynamic>.from(json['index_handlers']);


    return Translation(
      string: json['string'],
      format: json['format'][index],
      condition: json['condition'][index],
      indexHandlers: List.from(indexHandlers[index]),
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

  String formatWithSign(Stat stat) {
    return format.replaceFirst("+", stat.value.sign > 0 ? "+" : "-")
      .replaceFirst("#", valueAsDividedString(stat.value));
  }

  String formatRangeWithSign(Stat stat) {
    return format.replaceFirst("+", stat.value > 0 ? "+" : "-")
        .replaceFirst("#", "(${valueAsDividedString(stat.min)} – ${valueAsDividedString(stat.max)})");
  }

  String valueAsDividedString(int value) {
    int divider = 1;
    if (indexHandlers.any((value) => value.contains("per_minute_to_per_second"))) {
      divider = 60;
    } else if (indexHandlers.contains("divide_by_one_hundred")){
      divider = 100;
    }

    if (divider == 1) {
      return value.abs().toString();
    }
    return (value.abs() / divider).toStringAsFixed(2);
  }
}
