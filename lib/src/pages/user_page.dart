import 'package:flutter/material.dart';
import 'package:loguin_sistema_coop/src/preferences/preferences.dart';
import 'package:loguin_sistema_coop/src/services/service.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userService = UserService();
    final size = MediaQuery.of(context).size;
    final _prefs = new Preferences();
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: _createAppBar(context),
      body: _createBody(size, _prefs, userService),
    );
  }

  Container _createBody(
      Size size, Preferences _prefs, UserService userService) {
    return Container(
      width: double.infinity,
      height: size.height * 0.85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            child: Icon(Icons.person, size: 84, color: Colors.white),
            radius: 60,
            backgroundColor: Colors.green[400],
          ),
          FutureBuilder(
            future: userService.userBalanceAccount(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                print(snapshot.data);
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: size.height * 0.40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _createRow('Nombre:', _prefs.nombre),
                      SizedBox(height: 25),
                      _createRow('Correo:', _prefs.correo),
                      SizedBox(height: 25),
                      _createRow('Cuenta:', snapshot.data[0].toString()),
                      SizedBox(height: 25),
                      _createRow('Saldo:', snapshot.data[1].toString()),
                      SizedBox(height: 25),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Row _createRow(String label, String text) {
    TextStyle labelStyle = TextStyle(fontSize: 17, fontWeight: FontWeight.bold);
    TextStyle infoStyle = TextStyle(fontSize: 16);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          width: 120,
          child: Text(label, style: labelStyle),
        ),
        Container(
          width: 180,
          child: Text(text, style: infoStyle),
        ),
      ],
    );
  }

  AppBar _createAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green[400],
      centerTitle: true,
      title: Text('Perfil'),
    );
  }
}
