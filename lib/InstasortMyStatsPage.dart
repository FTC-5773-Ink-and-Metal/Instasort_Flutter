import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';


void main() => runApp(MaterialApp(
  home: InstasortSortPage(),
));

class InstasortStats extends StatefulWidget {
  @override
  _InstasortStatsState createState() => _InstasortStatsState();
}

class _InstasortStatsState extends State<InstasortStats> {
  @override
  Widget build(BuildContext context) {

    int landfillSorts = 0;
    int recyclingSorts = 0;
    int compostSorts = 0;
    List<int> levelsForProgress = [50, 100, 200, 400, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000, 5500, 6000];

    Column makeSortSection({required String text, color: Colors.green, numSorted: 0}){
      return Column(
          children: <Widget> [
            SizedBox(height: 25.0),
            CircleAvatar(
                radius: 55.0,
                backgroundColor: color,
                child: Text(
                    numSorted.toString(),
                    style: TextStyle(
                        fontSize: 40.0,
                        color: Colors.grey[300],
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0)
                )
            ),
            SizedBox(height: 10.0),
            Text(
              text,
              style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.grey[200],
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0),
            ),
          ]
      )
      ;
    }
// TODO: Complete Linear Progress Indicator and create row with int values on either side
    LinearProgressIndicator initiateProgressBar(int endValue, int currentValue){
      return LinearProgressIndicator(
        backgroundColor: Colors.grey[400],
        value: 0.5,
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
          title: Text(
            "My Stats",
            style: TextStyle(
                fontSize: 50.0,
                color: Colors.purple[800],
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0),
          ),
          centerTitle: true,
          backgroundColor: Colors.grey[900],
          elevation: 0
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: Column(
            children: <Widget>[
              makeSortSection(text: "Landfill", color: Colors.grey, numSorted: landfillSorts),
              makeSortSection(text: "Recycling", color: Colors.blue, numSorted: recyclingSorts),
              makeSortSection(text: "Compost", color: Colors.green, numSorted: compostSorts),
              SizedBox(height: 35.0),
              LinearProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}