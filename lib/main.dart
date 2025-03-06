import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'SMOESEL Punsher'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool _isPunched = false;
  bool _isAnimating = false;
  bool _showPow = false;
  late AnimationController _controller;
  late Animation<Offset> _animation;
  Offset _tapPosition = Offset.zero;
  String _currentQuote = "Können wir da nicht einen Hotfolder verwenden?";
  String _currentFace = 'assets/patrick.png';
  List<String> _currentQuotes = [];
  double _punchSpeed = 300;

  final Map<String, Map<String, dynamic>> _faces = {
    'assets/patrick.png': {
      'name': 'Patrick',
      'quotes': [
        "Können wir da nicht einen Hotfolder verwenden?",
        "Das ist doch ganz einfach!",
        "Warum dauert das so lange?",
        "Kannst du das mal schnell machen?",
        "Jooo ich bin Patrick.",
        "Na würdest du mir gerne mal in die Fresse schlagen?",
      ],
    },
    'assets/yanic.png': {
      'name': 'Yanic',
      'quotes': [
        "Sooo Zeit ist Geld und Geld ist knapp, ...",
        "3/4 11",
        "Das sind Pfannkuchen, keine Berliner!",
        "Ahhh, die sehr sehr gute Firma Microsoft",
        "Bei Windows klappt das!",
      ],
    },
    'assets/wehrle.png': {
      'name': 'Wehrle',
      'quotes': [
        "Ich lege monatlich 10k zur Seite.",
        "Leuttteeeee!",
        "Braucht hier jemand Hilfe????",
        "Ich habe einen IQ von 128.",
        "Also ich habe ja ein Start-Up...",
      ],
    },
    'assets/cem.png': {
      'name': 'Cem',
      'quotes': [
        "Meine Freundin hat Gleichgewichtsstörungen.",
        "Also als ich in Kanada war...",
        "Also als ich in Japan war...",
        "Also als ich in der USA war...",
        "Mein Onkel ist der beste Vertriebler in Deutschland.",
        "Zählt da auch die Apple Watch?",
        "Ich habe ein Praktikum beim Frauenarzt gemacht.",
        "Eine Studie zeigt, dass 90% der Frauen auf Muskeln stehen.",
        "Eine Studie zeigt ja, dass Frauen ...",
      ],
    },
  };

  final List<String> _powQuotes = [
    "Auuaaa, das tut ja voll weh.",
    "Nicht schon wieder!",
    "Autsch!",
    "Das war gemein!",
    "Hör auf damit!",
    "Das sag ich meiner Mama!",
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: _punchSpeed.toInt()),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: const Offset(1.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _currentQuotes = _faces[_currentFace]!['quotes'];
  }

  void _punchFace(TapDownDetails details) {
    if (_isAnimating) return;

    setState(() {
      _tapPosition = details.localPosition;
      _isPunched = true;
      _isAnimating = true;
      _controller.duration = Duration(milliseconds: _punchSpeed.toInt());
      _controller.forward().then((_) {
        setState(() {
          _showPow = true;
          _currentQuote = _powQuotes[Random().nextInt(_powQuotes.length)];
        });
        Timer(Duration(milliseconds: (_punchSpeed / 2).toInt()), () {
          setState(() {
            _showPow = false;
          });
          Timer(Duration(milliseconds: (_punchSpeed / 4).toInt()), () {
            _controller.reverse().then((_) {
              setState(() {
                _isPunched = false;
                _isAnimating = false;
                _currentQuote =
                    _currentQuotes[Random().nextInt(_currentQuotes.length)];
              });
            });
          });
        });
      });
    });
  }

  void _switchFace(String face) {
    setState(() {
      _currentFace = face;
      _currentQuotes = _faces[face]!['quotes'];
      _currentQuote = _currentQuotes[Random().nextInt(_currentQuotes.length)];
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 100),
          SpeechBubble(
            child: Text(
              _currentQuote,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTapDown: _punchFace,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.asset(_currentFace, width: 500, height: 300),
                if (_isPunched)
                  Positioned(
                    left: _tapPosition.dx,
                    top: _tapPosition.dy - 62.5,
                    child: SlideTransition(
                      position: _animation,
                      child: Image.asset(
                        'assets/block.png',
                        width: 367,
                        height: 125,
                      ),
                    ),
                  ),
                if (_showPow)
                  Positioned(
                    left: _tapPosition.dx - 100,
                    top: _tapPosition.dy - 100,
                    child: Image.asset(
                      'assets/pow.png',
                      width: 200,
                      height: 200,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Slider(
            value: _punchSpeed,
            min: 50,
            max: 500,
            divisions: 9,
            label: "${_punchSpeed.toInt()} ms",
            onChanged: (value) {
              setState(() {
                _punchSpeed = value;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                _faces.keys.map((face) {
                  return GestureDetector(
                    onTap: () => _switchFace(face),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  _currentFace == face
                                      ? Colors.deepPurple
                                      : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: Image.asset(face, width: 80, height: 80),
                        ),
                        Text(_faces[face]!['name']),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}

class SpeechBubble extends StatelessWidget {
  final Widget child;

  const SpeechBubble({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
