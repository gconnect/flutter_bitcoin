import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io' show Platform;
import 'coin_data.dart';

const APIKEY = "";
const BITCOIN_API = "https://apiv2.bitcoinaverage.com/indices/global/ticker/";

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = "AUD";
  double value;
  @override
  void initState() {
    super.initState();
    getData();
  }

  List<DropdownMenuItem> getDropdownItem() {
    List<DropdownMenuItem<String>> dropDownItem = [];
    for (String currency in currenciesList) {
      print(currency);
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItem.add(newItem);
    }
    return dropDownItem;
  }

  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> dropDownItem = [];
    for (String currency in currenciesList) {
      print(currency);
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItem.add(newItem);
    }
    return DropdownButton(
      value: selectedCurrency,
      hint: Text("Select Currency"),
      items: dropDownItem,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
          print(selectedCurrency);
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Text> pickerItem = [];
    for (String currency in currenciesList) {
      pickerItem.add(Text(currency));
      print(currency);
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: pickerItem,
    );
  }

  //Alternatively called
  Widget getPicker() {
    if (Platform.isIOS) {
      return iosPicker();
    } else if (Platform.isAndroid) {
      return androidDropDown();
    }
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  Column makeCards() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          cryptoCurrency: crypto,
          selectedCurrency: selectedCurrency,
          value: isWaiting ? 0 : coinValues[crypto],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropDown(),
          )
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  final String cryptoCurrency;
  final String selectedCurrency;
  final double value;
  CryptoCard({this.cryptoCurrency, this.value, this.selectedCurrency});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $cryptoCurrency = $value $selectedCurrency',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
