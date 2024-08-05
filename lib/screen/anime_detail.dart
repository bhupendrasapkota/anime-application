import 'package:anime_application/models/anime_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

class AnimeDetail extends StatelessWidget {
  final AnimeModel animeModel;
  const AnimeDetail({super.key, required this.animeModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(animeModel.title),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Row(
              children: [
                Image.network(animeModel.imageUrl),
                Column(children: [
                  Text(
                    "Title:" + animeModel.title,
                    style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.width > 600 ? 20 : 15),
                  ),
                  Text("English Title:" + animeModel.englishTitle),
                  Text("Rating:" + animeModel.rating.toString()),
                  Text("Status:" + animeModel.status),
                  Text("Source:" + animeModel.source),
                  Text("Episodes:" + animeModel.episodes.toString()),
                ])
              ],
            ),
          ),
          Row(
            children: [Text(animeModel.synopsis)],
          )
        ],
      ),
    );
  }
}
