import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static final Preferences _instancia = new Preferences._internal();

  factory Preferences() {
    return _instancia;
  }

  Preferences._internal();

  SharedPreferences _prefs;

  initPreferences() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  get nombre {
    return _prefs.getString('nombre') ?? '';
  }

  set nombre(String nombre) {
    _prefs.setString('nombre', nombre);
  }

  get correo {
    return _prefs.getString('correo') ?? '';
  }

  set correo(String correo) {
    _prefs.setString('correo', correo);
  }

  get id {
    return _prefs.getString('id') ?? '';
  }

  set id(String id) {
    _prefs.setString('id', id);
  }
}
