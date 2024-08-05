import 'package:anime_application/screen/anime_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/anime_model.dart';
import '../services/anime_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anime App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        textTheme:
            GoogleFonts.latoTextTheme(Theme.of(context).textTheme).copyWith(
          titleLarge: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width > 600
                ? MediaQuery.of(context).size.width * 0.02
                : MediaQuery.of(context).size.width * 0.05,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: GoogleFonts.lato(
            fontSize: MediaQuery.of(context).size.width * 0.015,
            color: Colors.black87,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 4,
          margin: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          hintStyle: GoogleFonts.lato(
            fontSize: MediaQuery.of(context).size.width > 600
                ? MediaQuery.of(context).size.width * 0.015
                : MediaQuery.of(context).size.width * 0.04,
            color: Colors.black38,
          ),
          prefixIconColor: Colors.black54,
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> _topAnime;
  late Future<dynamic> _searchResults;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTopAnime();
  }

  void _loadTopAnime() {
    _topAnime = AnimeService.fetchTopAnime().then((data) {
      List<AnimeModel> animeList = [];
      for (var anime in data) {
        animeList.add(AnimeModel.fromJson(anime));
      }
      return animeList;
    });
  }

  void _searchAnime(String query) async {
    var results = await AnimeService.searchAnime(query);
    List<AnimeModel> animeList = [];
    for (var json in results) {
      animeList.add(AnimeModel.fromJson(json));
    }
    setState(() {
      results = Future.value(animeList);
      _searchResults = results;
      _isSearching = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Anime App'),
          actions: [
            Container(
                width: 250,
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (query) {
                    _searchAnime(query);
                    _searchController.clear();
                  },
                  decoration: InputDecoration(
                      hintText: 'Search Anime', prefixIcon: Icon(Icons.search)),
                ))
          ],
        ),
        body: FutureBuilder(
            future: _isSearching ? _searchResults : _topAnime,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                return _buildGridView(snapshot.data);
              } else {
                return Center(child: Text('No data found'));
              }
            }));
  }

  Widget _buildGridView(List<AnimeModel> animeModels) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.65,
      ),
      itemCount: animeModels.length,
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnimeDetail(
                    animeModel: animeModels[index],
                  ),
                ),
              );
            },
            child: Card(
              child: Column(children: [
                Expanded(
                  flex: 2,
                  child: Image.network(
                    animeModels[index].imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Column(children: [
                      Text(animeModels[index].title),
                      Text(
                        animeModels[index].synopsis,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    ]))
              ]),
            ));
      },
    );
  }
}
