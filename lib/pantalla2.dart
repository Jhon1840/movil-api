import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Api2 extends StatefulWidget {
  const Api2({Key? key}) : super(key: key);

  @override
  _Api2State createState() => _Api2State();
}

class _Api2State extends State<Api2> {
  final TextEditingController _controller = TextEditingController();
  String? _gameName;
  String? _gameImage;
  String? _gamePlatform;

  Future<void> _searchGame(String gameName) async {
    var dio = Dio();
    var response = await dio
        .get('https://www.freetogame.com/api/games?category=$gameName');
    if (response.statusCode == 200 &&
        response.data is List &&
        response.data.isNotEmpty) {
      var game = response.data[0];
      setState(() {
        _gameName = game['title'];
        _gameImage = game['thumbnail'];
        _gamePlatform = game['platform'];
      });
    } else {
      setState(() {
        _gameName = null;
        _gameImage = null;
        _gamePlatform = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscador de Juegos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Nombre del Juego'),
            ),
            ElevatedButton(
              child: const Text('Buscar'),
              onPressed: () => _searchGame(_controller.text),
            ),
            if (_gameName != null)
              Column(
                children: <Widget>[
                  Text('Nombre del Juego: $_gameName'),
                  Image.network(_gameImage!),
                  Text('Plataforma: $_gamePlatform'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
