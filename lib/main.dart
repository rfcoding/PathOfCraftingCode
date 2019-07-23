import 'package:flutter/material.dart';
import 'app.dart';
import 'repository/mod_repo.dart';

void main() {

  ModRepository.instance.initialize().then((success) {
    runApp(MyApp());
  });
}
