import 'package:flutter/material.dart';
import 'package:loguin_sistema_coop/src/models/user_model.dart';
import 'package:loguin_sistema_coop/src/services/service.dart';
import 'package:loguin_sistema_coop/src/widgets/create_custom_field.dart';
import 'package:loguin_sistema_coop/src/utils/utils.dart' as utils;

class TransferPage extends StatefulWidget {
  const TransferPage({Key key}) : super(key: key);

  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  UserModel user = new UserModel();
  final userService = new UserService();
  bool state = false;
  final formkey = new GlobalKey<FormState>();
  final scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldkey,
      backgroundColor: Colors.green[100],
      appBar: _createAppBar(),
      body: _createBody(size),
    );
  }

  SingleChildScrollView _createBody(Size size) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            _createAccountBalance(size),
            _createForm(size),
          ],
        ),
      ),
    );
  }

  Container _createForm(Size size) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      width: size.width * 0.90,
      height: size.height * 0.60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.green[300],
      ),
      child: _createFormFields(size),
    );
  }

  Widget _createFormFields(Size size) {
    return Form(
      key: formkey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: size.width * 0.80,
            child: CreateCustomField(
                typeField: 1,
                user: user,
                icon: Icons.arrow_forward,
                text: 'Número de Cuenta',
                type: TextInputType.number),
          ),
          Container(
            width: size.width * 0.80,
            child: CreateCustomField(
                user: user,
                typeField: 2,
                icon: Icons.attach_money,
                text: 'Monto',
                type: TextInputType.text),
          ),
          _createNewEntity(size),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _createButton(size, 'Cancelar', Colors.redAccent, () {
                Navigator.pop(context);
              }),
              _createButton(size, 'Transferir', Colors.green, _submit),
            ],
          ),
        ],
      ),
    );
  }

  _submit() async {
    if (!formkey.currentState.validate()) return;

    formkey.currentState.save();
    if (state) {
      if (user.entity == null) {
        return utils.mostrarSnackBar(
            'Debe seleccionar un Banco', Colors.red, scaffoldkey);
      } else {
        bool ok = await userService.transfer(
            user.transferTo, user.value, user.entity);
        if (ok) {
          await new Future.delayed(Duration(milliseconds: 1500));
          await utils.mostrarSnackBar(
              'Transacción exitosa!', Colors.green, scaffoldkey);
          await new Future.delayed(Duration(seconds: 2));
          Navigator.pop(context);
        } else {
          return utils.mostrarSnackBar(
              'Ah ocurrido un error en el Servidor!!! Por favor intente más tarde!',
              Colors.red,
              scaffoldkey);
        }
      }
    } else {
      bool ok = await userService.transfer(user.transferTo, user.value, 0);
      if (ok) {
        await new Future.delayed(Duration(milliseconds: 1500));
        await utils.mostrarSnackBar(
            'Transacción exitosa!', Colors.green, scaffoldkey);
        await new Future.delayed(Duration(seconds: 2));
        Navigator.pop(context);
      } else {
        return utils.mostrarSnackBar(
            'La cuenta no existe!', Colors.red, scaffoldkey);
      }
    }
  }

  Container _createButton(
      Size size, String title, Color color, Function onPressed) {
    return Container(
      width: size.width * 0.35,
      height: 50,
      child: RaisedButton(
        color: color,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: onPressed,
      ),
    );
  }

  Container _createNewEntity(Size size) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.80,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.green[300],
                    value: state,
                    onChanged: (value) {
                      setState(() {
                        state = value;
                      });
                    }),
              ),
              Text('Otra Entidad Bancaria', style: TextStyle(fontSize: 15)),
            ],
          ),
          SizedBox(height: 10),
          (!state) ? Container() : _selectBank(size),
        ],
      ),
    );
  }

  Row _selectBank(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FutureBuilder(
          future: userService.getBanks(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              if (snapshot.data == null) {
                return Container();
              } else {
                final banks = snapshot.data;
                List<String> items = [];
                banks.forEach((bank) {
                  items.add(bank['idBanco'].toString() +
                      '-' +
                      bank['nombre'].toString());
                });
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  ),
                  width: size.width * 0.80,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: 'Seleccione un banco',
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(20.0),
                        borderSide: new BorderSide(style: BorderStyle.solid),
                      ),
                    ),
                    items: items.map<DropdownMenuItem<String>>((String value) {
                      final arreglo = value.split("-");

                      return DropdownMenuItem<String>(
                        child: Text(value),
                        value: arreglo[0],
                      );
                    }).toList(),
                    onChanged: (value) {
                      user.entity = int.parse(value);
                    },
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }

  Widget _createAccountBalance(Size size) {
    final userService = new UserService();
    return Container(
      height: size.height * 0.20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Saldo de Cuenta',
            style: TextStyle(
                color: Colors.green, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Center(
            child: FutureBuilder(
              future: userService.userBalanceAccount(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Container(
                  width: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white),
                  child: TextField(
                    enabled: false,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintStyle:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      hintText: '\$${snapshot.data[1]}',
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _createAppBar() {
    return AppBar(
      backgroundColor: Colors.green[300],
      centerTitle: true,
      title: Text('Transferencias'),
    );
  }
}
