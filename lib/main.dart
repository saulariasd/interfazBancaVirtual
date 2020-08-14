import 'package:flutter/material.dart';
import 'package:loguin_sistema_coop/src/pages/credit_page.dart';
import 'package:loguin_sistema_coop/src/pages/home_page.dart';
import 'package:loguin_sistema_coop/src/pages/login_page.dart';
import 'package:loguin_sistema_coop/src/pages/transfer_page.dart';
import 'package:loguin_sistema_coop/src/pages/user_page.dart';
import 'package:loguin_sistema_coop/src/preferences/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final _preferences = new Preferences();
  await _preferences.initPreferences();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _prefs = new Preferences();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      routes: {
        'login': (BuildContext context) => LoginPage(),
        'home': (BuildContext context) => HomePage(),
        'transfer': (BuildContext context) => TransferPage(),
        'user': (BuildContext context) => UserPage(),
        'credit': (BuildContext context) => CreditPage(),
      },
      // initialRoute:'login',
      initialRoute: (_prefs.id == '') ? 'login' : 'home',
    );
  }
}
