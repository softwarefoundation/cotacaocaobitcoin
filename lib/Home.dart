import 'dart:convert' as converter;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _cotacao = "";
  String _erro = "";
  String _requesId = "";
  String _url = "http://blockchain.info/ticker";
  bool _visibility = false;

  void wsRecuperarPrecoBitcoin() async {
    try {
      http.Response response = await http.get(_url);
      Map<String, dynamic> retorno = converter.jsonDecode(response.body);

      setState(() {
        _cotacao = formatarValorMonetario(retorno["BRL"]["buy"]);
        _visibility = false;
      });
    } catch (e) {
      setState(() {
        _visibility = true;
        _erro = e.toString();
      });
    } finally {
      setState(() {
        _requesId = new Random().nextInt(100).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("COTAÇÃO BITCOIN"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "images/bitcoin.png",
                height: 50,
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text("URL: ${_url}"),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 30,
                ),
                child: Text("Cotação atual: ${_cotacao}"),
              ),
              Visibility(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 30,
                  ),
                  child: Text(
                    "Erro: ${_erro}",
                  ),
                ),
                visible: _visibility,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 30,
                ),
                child: Text("Chamada: ${_requesId}"),
              ),
              RaisedButton(
                onPressed: () {
                  wsRecuperarPrecoBitcoin();
                },
                textColor: Colors.white,
                padding: const EdgeInsets.all(15),
                child: Container(
                  child: Text('Atualizar', style: TextStyle(fontSize: 20)),
                ),
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatarValorMonetario(double valor) {
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
        amount: valor,
        settings: MoneyFormatterSettings(
            symbol: 'R\$',
            thousandSeparator: '.',
            decimalSeparator: ',',
            symbolAndNumberSeparator: ' ',
            fractionDigits: 2,
            compactFormatType: CompactFormatType.short));

    return fmf.output.symbolOnLeft;
  }
}
