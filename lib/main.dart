import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_app/places.dart' show Place, getPlaces;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var places = <Place>[];
  var _places = <String>[];

  @override
  void initState() {
    super.initState();
    listenForPlaces();
    _places =  new List.generate(100, (i) => 'Restaurant $i');
  }

  listenForPlaces() async {
    var stream = await getPlaces(33.9850, -118.4695);
    stream.listen((place) => setState(() => places.add(place)));
    print('imprimir valores');
    print('valores  $places');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Center(
        child: new ListView(
          children: places.map((place) => new PlaceWidget(place)).toList(),
        ),
      ),
    );
  }
}

class PlaceWidget extends StatelessWidget {
  final Place place;
  PlaceWidget(this.place);

  @override
  Widget build(BuildContext context) {

    var ratingColor = Color.lerp(Colors.red, Colors.green, place.rating / 5);

    var listTile = new ListTile(
      leading: new CircleAvatar(
        child: new Text(place.rating.toString()),
        backgroundColor: ratingColor,
      ),
      title: new Text(place.name),
      subtitle: new Text(place.address),
    );

    return new Dismissible(
      key: new Key(place.name),
      background: new Container(color: Colors.green),
      secondaryBackground: new Container(color: Colors.red),
      onDismissed: (dir) {
        dir == DismissDirection.endToStart? 
        Scaffold.of(context).showSnackBar(
          new SnackBar(content:new Text('No me gusta'),
          duration: Duration(seconds: 1))) :
         Scaffold.of(context).showSnackBar(
           new SnackBar(content:new Text('Me gusta'),
            duration: Duration(seconds: 1)));
      },
      child: listTile,
    );
  }
}
