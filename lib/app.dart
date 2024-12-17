import 'package:flutter/material.dart';

import 'core/index.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: GeneralConstants.appTitle,
      theme: ThemeData(),
    );
  }
}
