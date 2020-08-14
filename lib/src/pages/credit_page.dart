import 'package:flutter/material.dart';
import 'package:loguin_sistema_coop/src/services/service.dart';

class CreditPage extends StatefulWidget {
  @override
  _CreditPageState createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
  final userService = UserService();
  int _tipo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: _createAppBar(context),
      body: _createBody(),
    );
  }

  Container _createBody() {
    TextStyle style = new TextStyle(color: Colors.black, fontSize: 12);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _createRadioButtons(style),
          (_tipo == null)
              ? Container()
              : (_tipo == 1)
                  ? _createCreditRowHeader()
                  : _createExpiredRowHeader(),
          (_tipo == null)
              ? Container()
              : (_tipo == 1) ? _createCreditRows() : _createDuesRows(),
        ],
      ),
    );
  }

  Expanded _createCreditRows() {
    return Expanded(
      child: FutureBuilder(
        future: userService.getUserCredits(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            var lista = snapshot.data;
            // print('esta es la loista');
            // print(lista);
            if (lista.length == 0) {
              return Text('No existen creditos registrados');
            } else {
              return ListView.separated(
                itemCount: lista.length,
                separatorBuilder: (context, index) {
                  return Divider(height: 35);
                },
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 45,
                        alignment: Alignment.bottomCenter,
                        child: Text(lista[index]['numeroCredito'].toString()),
                      ),
                      Expanded(
                        child: Container(
                            child: Text(lista[index]['proposito'].toString())),
                      ),
                      Container(
                          alignment: Alignment.bottomCenter,
                          width: 85,
                          child: Text(lista[index]['valorCredito'].toString())),
                      Container(
                          alignment: Alignment.bottomCenter,
                          width: 85,
                          child: Text(lista[index]['saldoCredito'].toString())),
                    ],
                  );
                },
              );
            }
          }
        },
      ),
    );
  }

  Expanded _createDuesRows() {
    return Expanded(
      child: FutureBuilder(
        future: userService.getDuesCredits(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            var lista = snapshot.data;
            // print('esta es la loista');
            // print(lista);
            if (lista.length == 0) {
              return Text('No existen cuotas registradas');
            } else {
              return ListView.separated(
                itemCount: lista.length,
                separatorBuilder: (context, index) {
                  return Divider(height: 35);
                },
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 45,
                        alignment: Alignment.bottomCenter,
                        child: Text(lista[index]['id'].toString()),
                      ),
                      Expanded(
                        child: Container(
                            alignment: Alignment.bottomCenter,
                            child: Text(lista[index]['fechaPlazo'].toString())),
                      ),
                      Container(
                          alignment: Alignment.bottomCenter,
                          width: 85,
                          child: Text(lista[index]['valor'].toString())),
                      Container(
                          alignment: Alignment.bottomCenter,
                          width: 85,
                          child: Text(lista[index]['saldo'].toString())),
                    ],
                  );
                },
              );
            }
          }
        },
      ),
    );
  }

  Row _createRadioButtons(TextStyle style) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 140,
          child: RadioListTile(
            title: Text('Creditos', style: style),
            value: 1,
            groupValue: _tipo,
            onChanged: _setSelectedRadio,
          ),
        ),
        Container(
          width: 190,
          child: RadioListTile(
            title: Text('Cuotas Vencidas', style: style),
            value: 2,
            groupValue: _tipo,
            onChanged: _setSelectedRadio,
          ),
        ),
      ],
    );
  }

  _setSelectedRadio(int valor) {
    _tipo = valor;
    print(valor);
    setState(() {});
  }

  Widget _createCreditRowHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 45,
              alignment: Alignment.bottomCenter,
              child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Text('Propósito',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: 85,
              child:
                  Text('Valor', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: 85,
              child:
                  Text('Saldo', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        Divider(height: 45, color: Colors.black),
      ],
    );
  }

  Widget _createExpiredRowHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 45,
              alignment: Alignment.bottomCenter,
              child: Text('#', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Text('Fecha Plazo',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: 85,
              child:
                  Text('Valor', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: 85,
              child:
                  Text('Saldo', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        Divider(height: 45, color: Colors.black),
      ],
    );
  }

  AppBar _createAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green[400],
      centerTitle: true,
      title: Text('Lista de Creditos'),
    );
  }
}
