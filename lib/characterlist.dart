import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

String movieID = '';
final String apiKey = "5017e649051ec5d0bc254e3478ea0bc5";
final String img = "https://image.tmdb.org/t/p/w500";
String castApi = "https://api.themoviedb.org/3/movie/";
String actorID = "";

class CharacterList extends StatelessWidget {
  const CharacterList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CharacterListW(),
      routes: <String, WidgetBuilder>{
        "/ActorRoles": (BuildContext context) => new ActorRoles()
      },
    );
  }
}

class CharacterListW extends StatefulWidget {
  CharacterListW({Key key}) : super(key: key);

  _CharacterListWState createState() => _CharacterListWState();
}

Future<List<MovieInfo>> _getMovieInfo() async {
  List<MovieInfo> cast = [];
  var data = await http.get(castApi + movieID + "/credits?api_key=" + apiKey);
  var jsondata = json.decode(data.body);

  for (var c in jsondata["cast"]) {
    MovieInfo info =
        MovieInfo(c["name"], c["character"], c["profile_path"], c['id']);
    cast.add(info);
  }
  return cast;
}

class _CharacterListWState extends State<CharacterListW> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Character Info",
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: <Widget>[
          FutureBuilder(
            future: _getMovieInfo(),
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
                            title: Text(snapshot.data[index].actorName +
                                "\n" +
                                "Character: " +
                                snapshot.data[index].characterName),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  img + snapshot.data[index].actorImage),
                            ),
                            onTap: () {
                              setState(() {
                                // actorID = snapshot.data[index].actorId;
                                personID = snapshot.data[index].actorId.toString();
                              });
                              Navigator.of(context).pushNamed("/ActorRoles");
                            });
                      } catch (e) {
                        //  print(e);
                        return ListTile(
                          title: Text(snapshot.data[index].actorName +
                              "\n" +
                              "Character: " +
                              snapshot.data[index].characterName),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://cdn.onlinewebfonts.com/svg/img_335318.png"),
                          ),
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

class ActorRoles extends StatefulWidget {
  ActorRoles({Key key}) : super(key: key);

  @override
  _ActorRolesState createState() => _ActorRolesState();
}

String personID;
List movieCredits = [];
Future<List<ActorsRoles>> _getActorsRoles() async {
  List<ActorsRoles> roleList = [];
  // var data = await http.get(castApi + movieID + "/credits?api_key=" + apiKey);
  var data = await http.get("https://api.themoviedb.org/3/person/"+personID+"/movie_credits?api_key=5017e649051ec5d0bc254e3478ea0bc5&language=en-US");
  var jsondata = json.decode(data.body);

  for (var role in jsondata["cast"]) {
    ActorsRoles info =
        ActorsRoles(role["character"], role["title"], role["poster_path"]);
    roleList.add(info);
  }
  return roleList;
}


class _ActorRolesState extends State<ActorRoles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Roles"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder(
                future: _getActorsRoles(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Column(
                      children: <Widget>[
                        SizedBox(
                          height: 200,
                        )
                      ],
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          try {
                            return ListTile(
                              title: Text(
                                  snapshot.data[index].roleName.toString()+
                                "\n" +
                                "Movie: " +snapshot.data[index].movieTitle),
                                leading: CircleAvatar(backgroundImage: NetworkImage(img+snapshot.data[index].posterImg),),
                            );
                          } catch (e) {
                            //  print(e);
                            return ListTile(
                              title: Text(
                                  snapshot.data[index].roleName.toString()+
                                "\n" +
                                "Movie: " +snapshot.data[index].movieTitle),
                                leading: CircleAvatar(backgroundImage: NetworkImage("https://cdn.onlinewebfonts.com/svg/img_335318.png"),),
                            );
                          }
                        },
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MovieInfo {
  final String actorName;
  final String characterName;
  final String actorImage;
  final int actorId;
  MovieInfo(this.actorName, this.characterName, this.actorImage, this.actorId);
}

class ActorsRoles {
  final String roleName;
  final String movieTitle;
  final String posterImg;
  ActorsRoles(this.roleName, this.movieTitle, this.posterImg);
}
