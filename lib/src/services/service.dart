import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:loguin_sistema_coop/src/preferences/preferences.dart';

class UserService {
  final _URL = 'http://192.168.1.9:8080/SistemaCooperativa/ws/usuarios';

  UserService() {}

  Future<bool> userLogin(String email, String password) async {
    final url = '${_URL}/login';
    dynamic jsonn = {"correo": email, "contrasenia": password};
    final response = await http.post(url,
        body: jsonEncode(jsonn),
        headers: <String, String>{"Content-Type": "application/json"});
    final Map<String, dynamic> decodedData = json.decode(response.body);

    if (decodedData['codigo'] == '200') {
      final _prefs = new Preferences();
      //se recibe el nombre del usuario que se loguea
      // print(decodedData['resultado']['nombre']);
      _prefs.nombre = (decodedData['resultado']['nombre']).toString();
      _prefs.correo = (decodedData['resultado']['correo']).toString();
      _prefs.id = (decodedData['resultado']['usarioId']).toString();

      return true;
    } else {
      return false;
    }
  }

  Future<List> userBalanceAccount() async {
    final _prefs = new Preferences();
    final url = '${_URL}/obtener_saldo_cuenta/${_prefs.id}';

    final response = await http.get(url,
        headers: <String, String>{"Content-Type": "application/json"});

    final Map<String, dynamic> decodedData = json.decode(response.body);
    final lista = [];
    String numeroCuenta = decodedData['resultado']['numeroCuenta'];
    double saldo = decodedData['resultado']['saldoActual'];
    lista.add(numeroCuenta);
    lista.add(saldo);
    return lista;
    // print(json.decode(response.body));
  }

  Future<List> getUserCredits() async {
    final _prefs = new Preferences();
    final url = '${_URL}/obtener_creditos/${_prefs.id}';
    final response = await http.get(url,
        headers: <String, String>{"Content-Type": "application/json"});
    final Map<String, dynamic> decodedData = json.decode(response.body);
    final lista = [];
    decodedData['resultado'].forEach((credito) {
      lista.add(credito);
    });
    return lista;
  }

  Future<List> getDuesCredits() async {
    final _prefs = new Preferences();
    final url = '${_URL}/obtener_cuotas_vencidas/${_prefs.id}';
    final response = await http.get(url,
        headers: <String, String>{"Content-Type": "application/json"});
    final Map<String, dynamic> decodedData = json.decode(response.body);
    final lista = [];
    decodedData['resultado'].forEach((couta) {
      lista.add(couta);
    });
    return lista;
  }

  Future<bool> transfer(String destino, String valor, int banco) async {
    final url = '${_URL}/guardar_transferencia';
    final _prefs = new Preferences();
    dynamic jsonn = {
      "idUsario": _prefs.id,
      "numeroCuentaDestino": destino,
      "valor": valor,
      "idBanco": banco
    };
    final response = await http.post(url,
        body: jsonEncode(jsonn),
        headers: <String, String>{"Content-Type": "application/json"});
    final Map<String, dynamic> decodedData = json.decode(response.body);

    if (decodedData['codigo'] == '200') {
      return true;
    } else {
      return false;
    }
  }

  Future<List> getBanks() async {
    final url = '${_URL}/obtener_bancos';
    final response = await http.get(url,
        headers: <String, String>{"Content-Type": "application/json"});
    final Map<String, dynamic> decodedData = json.decode(response.body);
    final lista = [];
    decodedData['resultado'].forEach((bank) {
      lista.add(bank);
    });
    return lista;
  }
}
