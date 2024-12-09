import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(GameListApp());
}

class GameListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Jogos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 16), // Substitui bodyText1
          titleLarge: TextStyle(color: Colors.yellowAccent, fontSize: 20), // Substitui headline6
        ),
      ),
      home: GameListScreen(),
    );
  }
}

class GameListScreen extends StatefulWidget {
  @override
  _GameListScreenState createState() => _GameListScreenState();
}

class _GameListScreenState extends State<GameListScreen> {
  List games = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGames();
  }

  Future<void> fetchGames() async {
    final response = await http.get(Uri.parse('https://arquivos.ectare.com.br/jogos.json'));
    if (response.statusCode == 200) {
      setState(() {
        games = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Falha ao carregar os jogos.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogos Disponíveis'),
        backgroundColor: Colors.black87,
        actions: [
          Icon(Icons.videogame_asset, color: Colors.yellowAccent),
        ],
      ),
      backgroundColor: Colors.grey[900],
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: Colors.yellowAccent),
            )
          : ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return Card(
                  color: Colors.grey[800],
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Icon(
                      Icons.gamepad,
                      color: Colors.greenAccent,
                    ),
                    title: Text(
                      game['nome'],
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      'Gênero: ${game['genero']}\nPlataforma: ${game['plataforma']}\nAno: ${game['ano de lançamento']}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
