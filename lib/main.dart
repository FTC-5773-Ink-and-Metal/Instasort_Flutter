import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

//io.flutter.plugins.camera

void main() => runApp(MaterialApp(
  theme: new ThemeData(
    scaffoldBackgroundColor: Colors.black,
  ),
  home: InstasortSortPage(),
));

class CameraFeed extends StatefulWidget {
  @override
  _CameraFeedState createState() => _CameraFeedState();
}

class _CameraFeedState extends State<CameraFeed> {
  late List<CameraDescription> _cameras;
  late CameraDescription _mainCamera;
  late CameraController _cameraController;
  late CameraImage trashImage;
  late bool _cameraInitialized;

  void _processCameraImage(CameraImage picture) {
    trashImage = picture;
  }

  void initializeCameraAndController() async {
    _cameras = await availableCameras();
    _mainCamera = _cameras[0];

    _cameraController = new CameraController(_mainCamera, ResolutionPreset.medium);
    _cameraController.initialize().then((_) async {
      await _cameraController.startImageStream((CameraImage picture) => _processCameraImage(picture));
      setState(() {
        _cameraInitialized = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initializeCameraAndController();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (_cameraInitialized)
    ? AspectRatio(
      aspectRatio: _cameraController.value.aspectRatio,
        child: CameraPreview(_cameraController),
    )
    : CircularProgressIndicator();
  }
}



class InstasortSortPage extends StatefulWidget {
  const InstasortSortPage({Key? key}) : super(key: key);

  @override
  _InstasortSortPageState createState() => _InstasortSortPageState();
}

class _InstasortSortPageState extends State<InstasortSortPage> {
  final Color backgroundColor = Color.fromARGB(255, 0, 0, 0);
  final String sortButtonText = "Sort";
  final Color sortButtonTextColor = Color.fromARGB(255, 255, 255, 255);
  int placeholderCounter = 0;

  int _currentTab = 0;
  final List<Type> _tabs = <Type>[InstasortSortPage, InstasortMyStatsPage];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 625),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.purple,
                      )
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(left: 80.0, top: 20.0, right: 80.0, bottom: 20.0),
                      primary: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    child: Text('Sort'),
                    onPressed: () {},
                  )
                ]
              )
            )
          ]
        )
      ),

      bottomNavigationBar: BottomNavigationBar(
          items: const<BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.camera_alt,
              ),
              label: 'Sort',  
              backgroundColor: Colors.black ,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  Icons.person_rounded,
              ),
              label: 'My Stats',
              backgroundColor: Colors.black,
            ),
          ],
          selectedItemColor: Colors.blueAccent,
      )
    );
  }

  void _onBottomNavigationBarItemTapped(int currentTab) {
    setState(() {
      _currentTab = currentTab;
    });
  }
}

class InstasortMyStatsPage extends StatefulWidget {
  @override
  _InstasortMyStatsPageState createState() => _InstasortMyStatsPageState();
}

class _InstasortMyStatsPageState extends State<InstasortMyStatsPage> {
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

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.brown,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug   painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
