import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HangmanApp(),
    );
  }
}

class HangmanApp extends StatefulWidget {
  @override
  _HangmanAppState createState() => _HangmanAppState();
}

class _HangmanAppState extends State<HangmanApp> {
  var chans = 5;
  String typedText = '';
  String motADeviner = '';
  String motCache = '';
  String indice = '';

  // Dictionnaire de mots
  Map<String, String> dictionnaire = {
    'Avoka Rakete peyi an ': 'ANDRE MICHEL',
    'Wanament , dlo , Sendomeng': 'Kanal',
    'chef yon fanmi': 'PAPA',
    'Kote yo resevwa malad': 'LOPITAL',
    'Kote Fanmi rete ': 'KAY',
    'Roi du Football': 'PELE',
    'Avoka Rakete peyi an ': 'ANDRE MICHEL',
  };

  @override
  void initState() {
    super.initState();
    choisirMotAleatoire();
  }

  
  void choisirMotAleatoire() {
    var rng = new Random();
    List<String> keys = dictionnaire.keys.toList();
    indice = keys[rng.nextInt(keys.length)];
    motADeviner = dictionnaire[indice] ?? '';
    motCache = motADeviner.replaceAll(RegExp(r'[a-zA-Z]'), '*');
  }

  
  void verifierLettre(String lettre) {
    setState(() {
      if (motADeviner.contains(lettre)) {
        for (int i = 0; i < motADeviner.length; i++) {
          if (motADeviner[i] == lettre) {
            motCache = motCache.replaceRange(i, i + 1, lettre);
          }
        }
      } else {
        chans--;
      }
      typedText = '';
    });

    if (chans == 0) {
      // L'utilisateur a perdu
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ou Pedi!'),
            content: Text('mo a se: $motADeviner'),
            actions: <Widget>[
              FlatButton(
                child: Text('Rejwe'),
                onPressed: () {
                  Navigator.of(context).pop();
                  restartGame();
                },
              ),
              FlatButton(
                child: Text('Anile'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Ajoutez ici la logique pour annuler le jeu
                },
              ),
            ],
          );
        },
      );
    } else if (!motCache.contains('*')) {
  
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ou genyen'),
            content: Text('mo an se: $motADeviner'),
            actions: <Widget>[
              FlatButton(
                child: Text('Rejwe'),
                onPressed: () {
                  Navigator.of(context).pop();
                  restartGame();
                },
              ),
            ],
          );
        },
      );
    }
  }

  
  void restartGame() {
    setState(() {
      chans = 5;
      typedText = '';
      choisirMotAleatoire();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Hangman'),
            SizedBox(width: 8), 
            IconButton(
              icon: Icon(Icons.star),
              onPressed: () {
                // Action à effectuer lorsque l'icône est cliquée
              },
            ),
          ],
        ),
        actions: <Widget>[
          Text('$chans'),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              // Action à effectuer lorsque l'icône est cliquée
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$motCache'),
            SizedBox(height: 20),
            Text('$indice'),
            SizedBox(height: 20),
            SizedBox(height: 20),
            // Affichage du clavier QWERTY
            Column(
              children: qwertyKeyboard.map((row) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row.map((key) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: () {
                          verifierLettre(key);
                        },
                        child: Text(key),
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),

          ],
        ),
      ),
    );
  }

  // Liste des caractères du clavier QWERTY
  List<List<String>> qwertyKeyboard = [
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
  ];
}
