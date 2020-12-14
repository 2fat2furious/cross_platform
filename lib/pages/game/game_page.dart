import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cross_platform/data/database/database.dart';
import 'package:cross_platform/data/database/word.dart';

class GamePage extends StatefulWidget {
  static const routeName = '/game';

  GamePage({Key key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int numParts = 6; //Максимальное количество ошибок
  int currParts = 0; //Количество нажатий
  int numCorr = 0; //Количество угаданных букв
  bool isInit = true;
  String word;
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
    }
  }

  void _incrementCounter(int index) {
    setState(() {
      var correct = false;
      for (var i=0; i< word.length; i++) {
        if (word[i] == String.fromCharCodes ([startCodeLetter + index])){
          colorLetter[i] = Colors.black;
          correct = true;
          numCorr++;
        }
      }
      if(correct){
        if(numCorr == word.length){
          showWinAlertDialog(context);
        }
        else{
          buttonDisabled[index] = true;
        }
      }
      else{
        if(currParts < numParts) {
          currParts++;
          buttonDisabled[index] = true;
        }
        else{
          showLoseAlertDialog(context);
        }
      }
    });
  }

  Future<String> getRandomWord(var local) async {
    if(isInit) {
      final db = await DBProvider.db.database;
      final res = await db.query('Word', where: 'language = ?',
          whereArgs: [local],
          orderBy: 'Random()',
          limit: 1);
      word = res.isNotEmpty ? Word
          .fromMap(res.first)
          .word : null;
      colorLetter = List.generate(word.length, (index) => Colors.transparent);
      isInit = false;
    }
    return word;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).appName),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (currParts == 0) Image.asset('image/android_hangman_gallows.png', height: 285, width: 230, fit: BoxFit.cover,),
                if (currParts == 1) Image.asset('image/android_hangman_head.png', height: 285, width: 275, fit: BoxFit.cover,),
                if (currParts == 2) Image.asset('image/android_hangman_body.png', height: 285, width: 275, fit: BoxFit.cover),
                if (currParts == 3) Image.asset('image/android_hangman_arm1.png', height: 285, width: 275, fit: BoxFit.cover),
                if (currParts == 4) Image.asset('image/android_hangman_arm2.png', height: 285, width: 275, fit: BoxFit.cover),
                if (currParts == 5) Image.asset('image/android_hangman_leg1.png', height: 285, width: 275, fit: BoxFit.cover),
                if (currParts == 6) Image.asset('image/android_hangman_leg2.png', height: 285, width: 275, fit: BoxFit.cover),
                SizedBox(
                  height: 70,
                  child: FutureBuilder<String>(
                    future: getRandomWord(myLocale == Locale('en') ? 'en' : 'ru'),
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      if(snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Container(
                                padding: EdgeInsets.only(
                                    top: 15.0, left: 3.5, right: 3.5),
                                child: Text(' ' + snapshot.data[index] + ' ',
                                    style: TextStyle(color: colorLetter[index],
                                        decorationColor: Colors.black,
                                        decoration: TextDecoration.underline,
                                        fontSize: 25))
                            );
                          },
                        );
                      }
                      else {
                        return Container();
                      }
                  })
                ),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 6,
                  childAspectRatio: (itemWidth / itemHeight),
                  children: List.generate(
                    countLetter,
                    (index) {
                      return Container(
                        padding: EdgeInsets.all(6.0),
                        alignment: Alignment.center,
                        child: FlatButton(
                            textColor: Colors.white,
                            color: Colors.black87,
                            onPressed: buttonDisabled[index]
                                ? null
                                : () => _incrementCounter(index),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.blueGrey[700],
                                    width: 4,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(70)),
                            child: Text(
                                String.fromCharCodes([startCodeLetter + index]),
                                style: TextStyle(fontSize: 20))),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showWinAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(AppLocalizations.of(context).exit),
      onPressed:  () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();// dismiss dialog
      },
    );
    Widget continueButton = FlatButton(
      child: Text(AppLocalizations.of(context).playAgain),
      onPressed:  () {
        Navigator.of(context).pop();
        setState(() {
          isInit = true;
          currParts = 0;
          numCorr = 0;
          buttonDisabled = List.generate(countLetter, (index) => false);
        });
      },
    );

    // set up the AlertDialog
    final alert = AlertDialog(
      title: Text(AppLocalizations.of(context).congrat),
      content: Text(AppLocalizations.of(context).win + word),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showLoseAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(AppLocalizations.of(context).exit),
      onPressed:  () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(AppLocalizations.of(context).playAgain),
      onPressed:  () {
        Navigator.of(context).pop();
        setState(() {
          isInit = true;
          currParts = 0;
          numCorr = 0;
          buttonDisabled = List.generate(countLetter, (index) => false);
        });
      },
    );

    // set up the AlertDialog
    final alert = AlertDialog(
      title: Text(AppLocalizations.of(context).alas),
      content: Text(AppLocalizations.of(context).lose + word),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}