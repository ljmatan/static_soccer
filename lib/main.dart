import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:static_soccer/logic/cache/prefs.dart';
import 'package:static_soccer/views/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Prefs.init();

  runApp(StaticSoccer());
}

class StaticSoccer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.green),
      home: HomePage(),
    );
  }
}
