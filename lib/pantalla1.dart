import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Api extends StatefulWidget {
  const Api({Key? key}) : super(key: key);

  @override
  State<Api> createState() => _ApiState();
}

class _ApiState extends State<Api> {
  late Future<List<Game>> futureGames;

  @override
  void initState() {
    super.initState();
    futureGames = fetchGames();
  }

  Future<List<Game>> fetchGames() async {
    var response = await Dio().get('https://www.freetogame.com/api/games');
    return (response.data as List).map((i) => Game.fromJson(i)).toList();
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
                leading: Image.network(snapshot.data![index].thumbnail),
                title: Text(snapshot.data![index].title),
                subtitle: Text(snapshot.data![index].genre),
                trailing: Text(snapshot.data![index].platform),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class Game {
  final String title;
  final String thumbnail;
  final String genre;
  final String platform;

  Game({
    required this.title,
    required this.thumbnail,
    required this.genre,
    required this.platform,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      title: json['title'],
      thumbnail: json['thumbnail'],
      genre: json['genre'],
      platform: json['platform'],
    );
  }
}
