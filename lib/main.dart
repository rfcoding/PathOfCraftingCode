import 'package:flutter/material.dart';
import 'app.dart';
import 'repository/mod_repo.dart';
import 'repository/translation_repo.dart';

void main() {

  Future.wait({ModRepository.instance.initialize(), TranslationRepository.instance.initialize()}).then((success) {
    runApp(MyApp());
  });
  /*ModRepository.instance.initialize().then((success) {
    runApp(MyApp());
  });*/
}
