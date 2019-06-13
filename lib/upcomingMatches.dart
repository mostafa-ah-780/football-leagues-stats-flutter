import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';

final String token = 'c2928278d71247c3bcb7c4ccc89cc2c6';

class match {
  String homeTeam;
  String awayTeam;
  String matchDay;
  String matchTime;

  match(this.homeTeam, this.awayTeam, this.matchDay, this.matchTime);
}

class upcomingMatches extends StatefulWidget {
  String leagueCode;
  Color leagueColor;

  upcomingMatches(this.leagueCode, this.leagueColor);
  createState() => upcomingMatchesState(leagueCode, leagueColor);
}

class upcomingMatchesState extends State<upcomingMatches> {
  String leagueCode;
  Color leagueColor;

  upcomingMatchesState(this.leagueCode, this.leagueColor);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: leagueColor,
        child: FutureBuilder(
          future: getMatches(leagueCode),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    return Card(
                        margin: EdgeInsets.all(5),
                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(15)),

                        //color: Color.fromRGBO(94, 124, 139, 1),
                        //
                        color: leagueColor.withOpacity(0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: FittedBox(
                                    alignment: Alignment(0, 0),
                                    child: Text(
                                      snapshot.data[i].homeTeam,
                                      style: teamStyle,
                                    )),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text('VS'),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      snapshot.data[i].awayTeam,
                                      style: teamStyle,
                                    )),
                              ),
                            ),
                            Expanded(
                              child: Text(snapshot.data[i].matchDay),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(snapshot.data[i].matchTime),
                              ),
                            )
                          ],
                        ));
                  });
            }
          },
        ));
  }
}

Future<List<match>> getMatches(String code) async {
  Response r = await get(
      Uri.encodeFull(
          'https://api.football-data.org/v2/competitions/$code/matches?status=SCHEDULED'),
      headers: {"X-Auth-Token": token});

  Map<String, dynamic> x = jsonDecode(r.body);
  List y = x['matches'];

  List<match> extractedMatches = [];

  print(x.keys);
  for (var i in y) {
    extractedMatches.add(new match(
        i['homeTeam']['name'],
        i['awayTeam']['name'],
        i['utcDate'].toString().substring(5, 10),
        DateTime.parse(i['utcDate'])
            .toLocal()
            .toIso8601String()
            .substring(11, 16)));
  }

  return extractedMatches;
}

TextStyle teamStyle =
    TextStyle(color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic);
