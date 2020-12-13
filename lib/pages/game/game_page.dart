import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GamePage extends StatefulWidget {
  static const routeName = '/game';

  GamePage({Key key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int numParts = 6;
  int _counter = 0;
  bool isInit = true;
  int wordLength = 7;
  String word = 'СИСТЕМА';
  Locale myLocale;
  int countLetter;
  int startCodeLetter;
  double itemHeight;
  double itemWidth;
  List<bool> buttonDisabled;
  List<Color> colorLetter;

  @override
  void initState(){
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    myLocale = Localizations.localeOf(context);
    countLetter = myLocale == Locale('en') ? 26 : 32;
    startCodeLetter = myLocale == Locale('en') ? 65 : 1040;
    final size = MediaQuery.of(context).size;

    itemHeight = 48;
    itemWidth = size.width / 6;
    if(isInit) {
      buttonDisabled = List.generate(countLetter, (index) => false);
      colorLetter = List.generate(word.length, (index) => Colors.transparent);
      isInit = false;
    }
  }

  void _incrementCounter(int index) {
    setState(() {
      var correct = false;
      buttonDisabled[index] = true;
      for (var i=0; i< word.length; i++) {
        if (word[i] == String.fromCharCodes ([startCodeLetter + index])){
          colorLetter[i] = Colors.white;
          correct = true;
        }
      }
      if(!correct){
        _counter++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).appName),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_counter == 0) Image.asset('image/android_hangman_gallows.png', height: 285, width: 230, fit: BoxFit.cover,),
              if (_counter == 1) Image.asset('image/android_hangman_head.png', height: 285, width: 275, fit: BoxFit.cover,),
              if (_counter == 2) Image.asset('image/android_hangman_body.png', height: 285, width: 275, fit: BoxFit.cover),
              if (_counter == 3) Image.asset('image/android_hangman_arm1.png', height: 285, width: 275, fit: BoxFit.cover),
              if (_counter == 4) Image.asset('image/android_hangman_arm2.png', height: 285, width: 275, fit: BoxFit.cover),
              if (_counter == 5) Image.asset('image/android_hangman_leg1.png', height: 285, width: 275, fit: BoxFit.cover),
              if (_counter == 6) Image.asset('image/android_hangman_leg2.png', height: 285, width: 275, fit: BoxFit.cover),
              SizedBox(
                height: 70,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: word.length,
                  itemBuilder: (context, index) {
                    return Container(
                        padding: EdgeInsets.only(top:15.0, left: 5.0, right: 5.0),
                        child: Text(' ' + word[index] + ' ', style: TextStyle(color: colorLetter[index], decorationColor: Colors.white, decoration: TextDecoration.underline, fontSize: 25))
                    );
                  },
                ),
              ),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 6,
                childAspectRatio: (itemWidth/ itemHeight),
                children: List.generate(countLetter, (index) {
                  return Container(
                    padding: EdgeInsets.all(6.0),
                    alignment: Alignment.center,
                    child: FlatButton(
                        textColor: Colors.white,
                        color: Colors.black54,
                        onPressed: buttonDisabled[index] ? null : () => _incrementCounter(index),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.blueGrey,
                                width: 4,
                                style: BorderStyle.solid
                            ),
                            borderRadius: BorderRadius.circular(70)
                        ),
                        child: Text(
                            String.fromCharCodes([startCodeLetter + index]),
                            style: TextStyle(fontSize: 20)
                        )
                    ),
                  );
                },),
              ),
            ],
          ),
        ),
      ),
    );
  }
}