import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loguin_sistema_coop/src/models/user_model.dart';
import 'package:loguin_sistema_coop/src/preferences/preferences.dart';
import 'package:loguin_sistema_coop/src/services/service.dart';
import 'package:loguin_sistema_coop/src/widgets/create_custom_field.dart';
import 'package:loguin_sistema_coop/src/utils/utils.dart' as utils;
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  final scaffoldkey = GlobalKey<ScaffoldState>();
  final user = new UserModel();
  String dispositivo = Platform.isIOS ? 'iPhone' : 'Android';
  String ubicacion = 'Cuenca';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldkey,
      backgroundColor: Colors.green[100],
      body: _createBody(size, context),
    );
  }

  SafeArea _createBody(Size size, BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _createHeader(size),
              _createForm(size, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createForm(Size size, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      // color: Colors.purple,
      width: size.width * 0.80,
      child: Form(
        key: formkey,
        child: Column(
          children: [
            CreateCustomField(
              icon: Icons.email,
              text: 'email',
              type: TextInputType.emailAddress,
              user: user,
            ),
            SizedBox(height: 10),
            CreateCustomField(
              icon: Icons.vpn_key,
              text: 'password',
              type: TextInputType.text,
              obscure: true,
              user: user,
            ),
            SizedBox(height: 10),
            _cretateButtonForgetPassword(),
            _createButtonSubmit(size, context),
          ],
        ),
      ),
    );
  }

  Widget _createButtonSubmit(Size size, BuildContext context) {
    return Container(
      width: size.width * 0.80,
      child: RaisedButton(
        color: Colors.green[300],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Text('INGRESAR', style: TextStyle(color: Colors.white)),
        onPressed: _submit,
      ),
    );
  }

  _submit() async {
    final userService = UserService();
    if (!formkey.currentState.validate()) return;

    formkey.currentState.save();
    bool isLogin = await userService.userLogin(user.email, user.password);
    if (isLogin) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      return utils.mostrarSnackBar(
          'No existe el usuario o la contraseña no es válida',
          Colors.red,
          scaffoldkey);
    }
  }
}

Row _cretateButtonForgetPassword() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        child: FlatButton(
          child: Text('Olvidó su contraseña?'),
          onPressed: () {
            print('click');
          },
        ),
      ),
    ],
  );
}

Center _createHeader(Size size) {
  return Center(
    child: Container(
      width: size.width * 0.80,
      height: size.height * 0.30,
      // color: Colors.red,
      child: Image.asset('assets/imaLogo.png'),
    ),
  );
}
