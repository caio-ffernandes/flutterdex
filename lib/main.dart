import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
 
void main() {
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PokedexHomePage(),
    );
  }
}
 
class PokedexHomePage extends StatefulWidget {
  @override
  _PokedexHomePageState createState() => _PokedexHomePageState();
}
 
class _PokedexHomePageState extends State<PokedexHomePage> {
  TextEditingController _controller = TextEditingController();
  String _pokemonName = '';
  Map<String, dynamic>? _pokemonData;
 
  void _fetchPokemonData(String pokemonName) async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonName'));
    if (response.statusCode == 200) {
      setState(() {
        _pokemonData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load Pokemon data');
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Search Pokemon',
          ),
          onChanged: (value) {
            setState(() {
              _pokemonName = value.toLowerCase();
            });
          },
          onSubmitted: (value) {
            _fetchPokemonData(_pokemonName);
          },
        ),
      ),
      body: _pokemonData == null
          ? Center(
              child: Text('Search for a Pokemon'),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Image.network(
                    _pokemonData!['sprites']['front_default'],
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(height: 20),
                  Text(
                    _pokemonData!['name'],
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Height: ${_pokemonData!['height']}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Weight: ${_pokemonData!['weight']}',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
    );
  }
}