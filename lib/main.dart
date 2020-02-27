import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'First Homework',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'First Homework'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  final String langTextBegin = "Language is ";

  final List<String> songText = [
    'Дым сигарет с ментолом,\nПьяный угар качает.\nВ глаза ты смотришь другому,\nКоторый тебя ласкает.',
    'А я нашёл другую,\nХоть не люблю, но целую.\nА когда я её обнимаю,\nВсё равно о тебе вспоминаю.',
    'Губы твои, как маки,\nПлатье по моде носишь,\nСебя ты ему раздаришь,\nМеня же знать не хочешь.',
    "Дым сигарет с ментолом,\nПьяный угар качает.\nВ глаза ты смотришь другому,\nКоторый тебя ласкает.",
    'А я нашёл другую,\nХоть не люблю, но целую.\nА когда я её обнимаю,\nВсё равно о тебе вспоминаю.' +
        'Завтра я буду дома,\nЗавтра я буду пьяный,\nНо никогда не забуду,\nКак к щеке прикоснулся губами.\n' +
        'Лучше меня прости,\nБрось и вернись ко мне.\nПрости за то, что ушёл с другой,\nПрости за то, что ушла и ты.',
  ];

  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentTextPart = -1;
  bool _isAudioOpened = false;
  bool _isAudioPlaying = false;

  void _playPause() {
    _openAudio();
    widget._assetsAudioPlayer.playOrPause();

    setState(() {
      _isAudioPlaying = !_isAudioPlaying;
    });
  }

  void _openAudio() {
    if (!_isAudioOpened) {
      widget._assetsAudioPlayer.open("audios/nensi_dim_sigaret.mp3");

      setState(() {
        _isAudioOpened = true;
      });
    }
  }

  Widget _buildLangText() {
    String langCode = ui.window.locale.languageCode;
    String langText = '';

    switch (langCode) {
      case 'uk':
        langText = 'Ukrainian';
        break;
      case 'bg':
        langText = 'Bulgarian';
        break;
      case 'en':
        langText = 'English';
        break;
    }
    return new Text(widget.langTextBegin + langText);
  }

  Widget _buildLangImage() {
    String langText = ui.window.locale.languageCode;
    String assetName = 'images/';

    switch (langText) {
      case 'uk':
        assetName += 'flag_ua.jpg';
        break;
      case 'bg':
        assetName += 'flag_bg.jpg';
        break;
      case 'en':
        assetName += 'flag_uk.jpg';
        break;
    }

    return new Image.asset(assetName);
  }

  void onClickText() {
    setState(() {
      _currentTextPart++;
      if (_currentTextPart >= widget.songText.length) {
        _currentTextPart = 0;
      }
    });

    String toastText = widget.songText[_currentTextPart];

    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: toastText,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16);
  }

  Widget _buildTextButton() {
    return new Container(
      margin: EdgeInsets.only(top: 5),
      child: new FlatButton(
        child: new Text('Text', style: new TextStyle(fontSize: 18)),
        onPressed: onClickText,
        color: Colors.black12,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(widget.title),
      ),
      body: new Container(
          margin: const EdgeInsets.all(10),
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _buildLangText(),
                _buildLangImage(),
                _buildTextButton(),
                new Text(
                  '${_currentTextPart + 1}',
                  style: Theme.of(context).textTheme.display1,
                ),
              ],
            ),
          )),
        floatingActionButton: new FloatingActionButton(
          onPressed: _playPause,
          child: new Icon(_isAudioPlaying ? Icons.pause : Icons.play_arrow ),
        )
    );
  }

  @override
  void dispose() {
    widget._assetsAudioPlayer.stop();
    super.dispose();
  }
}
