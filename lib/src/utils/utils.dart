import 'package:flutter/material.dart';

mostrarSnackBar(
    String texto, Color color, GlobalKey<ScaffoldState> scaffoldKey) {
  // print('entro');
  final snackbar = SnackBar(
    content: Text(
      texto,
      textAlign: TextAlign.center,
    ),
    duration: Duration(milliseconds: 2000),
    backgroundColor: color,
  );
  scaffoldKey.currentState.showSnackBar(snackbar);
}
