import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Api3 extends StatefulWidget {
  const Api3({Key? key}) : super(key: key);

  @override
  _Api3State createState() => _Api3State();
}

class _Api3State extends State<Api3> {
  late Future<List<Game>> futureGames;

  @override
  void initState() {
    super.initState();
    futureGames = fetchGames();
  }

  Future<List<Game>> fetchGames() async {
    var response = await Dio().get('https://www.freetogame.com/Api3/games');
    if (response.statusCode == 200) {
      return (response.data as List).map((i) => Game.fromJson(i)).toList();
    } else {
      throw Exception('Failed to load games');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Game>>(
      future: futureGames,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].title),
                subtitle: Text(
                    'Publisher: ${snapshot.data![index].publisher}\nDeveloper: ${snapshot.data![index].developer}\nDescription: ${snapshot.data![index].shortDescription}'),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class Game {
  final String title;
  final String publisher;
  final String developer;
  final String shortDescription;

  Game(
      {required this.title,
      required this.publisher,
      required this.developer,
      required this.shortDescription});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      title: json['title'],
      publisher: json['publisher'],
      developer: json['developer'],
      shortDescription: json['short_description'],
    );
  }
}
