import 'package:cotacaobitcoin/Home.dart';
import 'package:flutter/material.dart';

void main() => runApp(CotacaoBitCoinApp());

class CotacaoBitCoinApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cotação BitCoin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}
