import 'package:flutter/material.dart';
import 'package:loguin_sistema_coop/src/models/user_model.dart';

class CreateCustomField extends StatelessWidget {
  final bool obscure;
  final IconData icon;
  final String text;
  final TextInputType type;
  final bool enabled;
  final UserModel user;
  final int typeField;

  const CreateCustomField(
      {Key key,
      this.type,
      this.obscure = false,
      @required this.icon,
      @required this.text,
      @required this.typeField,
      this.enabled = true,
      @required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: TextFormField(
        enabled: enabled,
        textAlign: TextAlign.center,
        obscureText: obscure,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          icon: CircleAvatar(
            backgroundColor: Colors.green[100],
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          hintStyle: TextStyle(color: Colors.black),
          hintText: text,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        keyboardType: type,
        validator: (value) {
          if (obscure) {
            if (value.length < 5) {
              return 'La contraseña debe ser al menos de 5 digitos';
            } else {
              return null;
            }
          } else {
            if (typeField == 1 || typeField == 2) {
              if (value.length < 1) {
                return 'Debe llenar estos campos';
              } else {
                return null;
              }
            } else {
              Pattern pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = new RegExp(pattern);
              if (regExp.hasMatch(value)) {
                return null;
              } else {
                return 'El email es invalido';
              }
            }
          }
        },
        onSaved: (value) {
          if (obscure) {
            user.password = value;
          } else {
            if (typeField == 1) {
              user.transferTo = value;
            } else if (typeField == 2) {
              user.value = value;
            } else {
              user.email = value;
            }
          }
        },
      ),
    );
  }
}
