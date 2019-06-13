import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'standings.dart';
import 'upcomingMatches.dart';
import 'topScorers.dart';

final String token = 'c2928278d71247c3bcb7c4ccc89cc2c6';

void main() {
  //debugPaintSizeEnabled = true;
  runApp(standingsApp());
}

class standingsApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'League Standings',
      home: mainMenu(),
    );
  }
}

class mainMenu extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Choose A League'), backgroundColor: Colors.red,),
      body: Container(
        color: Color.fromRGBO(237, 227, 212, 1),
        child: GridView.count(

          crossAxisCount: 2,
          children: <Widget>[
            mainMenuIcon('assets/images/pl.png', context, mainLeagueScreen('Premier League', 'PL',Color.fromRGBO(63, 16, 82, 1))),
            mainMenuIcon('assets/images/laLiga.jpg', context, mainLeagueScreen('La Liga', 'PD', Color.fromRGBO(0, 52, 114, 1))),
            mainMenuIcon('assets/images/serieA.png', context, mainLeagueScreen('Serie A', 'SA', Color.fromRGBO(29, 150, 71, 1))),
            mainMenuIcon('assets/images/bundesliga.png', context, mainLeagueScreen('Bundesliga', 'BL1', Color.fromRGBO(177, 40, 41, 1))),
            mainMenuIcon('assets/images/ligue1.png', context, mainLeagueScreen('Ligue 1', 'FL1', Color.fromRGBO(227, 76, 38, 1)))
          ],
        ),
      )
    );
  }
}

Widget mainMenuIcon(String imgPath, BuildContext context, StatefulWidget newScreen){
  return Padding(
    padding: EdgeInsets.all(10),
    child: GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => newScreen));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Image.asset(imgPath),
      ),
    ),
  );
}

class mainLeagueScreen extends StatefulWidget {

  String leagueName;
  String leagueCode;
  Color leagueColor;

  mainLeagueScreen(this.leagueName, this.leagueCode,this.leagueColor);

  createState() => mainLeagueScreenState(leagueName, leagueCode,leagueColor);

}

class mainLeagueScreenState extends State<mainLeagueScreen>{

  String leagueName;
  String leagueCode;
  Color leagueColor;

  mainLeagueScreenState(this.leagueName, this.leagueCode,this.leagueColor);
  Widget screenContent = Container();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text(leagueName),
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(text: 'Matches',),
                  Tab(text: 'Standings',),
                  Tab(text: 'Scorers',)
                ],
              ),
              backgroundColor: leagueColor,
            ),
            body: TabBarView(
              children: <Widget>[
                upcomingMatches(leagueCode, leagueColor),
                leagueStanding(leagueCode, leagueName, leagueColor),
                topScorers(leagueCode, leagueColor)
              ],
            ),
          )),
    );
  }

  void displayStandings(){
    setState(() {
      screenContent = leagueStanding('PL', leagueName, leagueColor);
    });
  }

  void displayMatches(){
    setState(() {
      screenContent = upcomingMatches(leagueCode, leagueColor);
    });
  }
}