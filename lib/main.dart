import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './characterlist.dart';

//https://api.themoviedb.org/3/search/movie?api_key=5017e649051ec5d0bc254e3478ea0bc5&query=the%20matrix api for testing
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetData(),
    );
  }
}

class GetData extends StatefulWidget {
  GetData({Key key}) : super(key: key);

  _GetDataState createState() => _GetDataState();
}

class _GetDataState extends State<GetData> {
  String search = "";
  String idMovie = '';
  final String apiKey = "5017e649051ec5d0bc254e3478ea0bc5";
  final String api = "https://api.themoviedb.org/3/search/movie?api_key=";
  final String imageUrl = "https://image.tmdb.org/t/p/w500/";

  Future<List<MovieSerch>> _getInfo() async {
    var data = await http.get(api + apiKey + "&query=" + search);
    var jsondata = json.decode(data.body);

    List<MovieSerch> info = [];
    for (var i in jsondata["results"]) {
      MovieSerch inf =
          MovieSerch(i["title"], i["poster_path"], i["release_date"], i["id"]);
      info.add(inf);
    }
    print("done");
    return info;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Character Info"),
        backgroundColor:  Colors.blueGrey,
      ),
      body: Column(
        children: <Widget>[
          TextField(
            onSubmitted: (String string) {
              setState(() {
                search = string;
              });
            },
          ),
          FutureBuilder(
            future: _getInfo(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: 200,
                    ),
                    Center(
                      child: Text("loading..."),
                    ),
                  ],
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      try {
                        return ListTile(
                          title: Text(snapshot.data[index].movieName +
                              "\n" +
                              "Relesed: " +
                              snapshot.data[index].releseDate),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                imageUrl + snapshot.data[index].posterUrl),
                          ),
                          onTap: () {
                            setState(() {
                              //test1 = snapshot.data[index].movieId;
                              movieID = snapshot.data[index].movieId.toString();
                            });
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => CharacterList()));
                          },
                        );
                      } catch (e) {
                        return ListTile(
                          title: Text(snapshot.data[index].movieName +
                              "\n" +
                              " Relesed: " +
                              snapshot.data[index].releseDate),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://cdn.onlinewebfonts.com/svg/img_335318.png"),
                          ),
                          onTap: () {
                            setState(() {
                              //test1 = snapshot.data[index].movieId;
                              // movieID = snapshot.data[index].movieId.toString() + " and " +  snapshot.data[index].movieName;
                            });
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => CharacterList()));
                          },
                        );
                      }
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class MovieSerch {
  final String movieName;
  final String posterUrl;
  final String releseDate;
  final int movieId;

  MovieSerch(this.movieName, this.posterUrl, this.releseDate, this.movieId);
}
