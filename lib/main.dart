import 'package:api_test/movieService.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
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
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

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
  List<dynamic> _movies = [];
  final nameController = TextEditingController();
  final typeController = TextEditingController();

  @override
  void initState() {
    MovieService.fetchMovie().then((value) {
      // print(MovieService.convertJsonToMovie(value));
      setState(() {
        _movies = MovieService.convertJsonToMovie(value);
      });
    });
    super.initState();
  }

  void _removeMovies(int id) {
    MovieService.deleteMovie(id: id).then((value) => {
          setState(() {
            _movies = MovieService.convertJsonToMovie(value);
          })
        });
    // var url = "http://localhost:3000/api/removeMovies";
    // Http.get(url).then((value) {
    //   print(json.decode(value.body));
    //   MovieService.fetchMovie().then((value) {
    //     print(value);
    //     _movies = [];
    //   });
    // });
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Add movie"),
              content: Container(
                height: 120,
                child: Column(
                  children: [
                    TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.movie),
                          // hintText: 'What do people call you?',
                          labelText: 'Name',
                        )),
                    TextFormField(
                        controller: typeController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.merge_type),
                          // hintText: 'What do people call you?',
                          labelText: 'Type',
                        )),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('submit'),
                  onPressed: () {
                    MovieService.addMovie(
                            name: nameController.text,
                            type: typeController.text)
                        .then((value) => {
                              setState(() {
                                _movies =
                                    MovieService.convertJsonToMovie(value);
                              })
                            });
                    Navigator.of(context).pop();
                    print(_movies);

                    // print(mv[0].name);
                  },
                )
              ],
            ));
  }

  Future<void> _pullRefresh() async {
    List mv = await MovieService.fetchMovie();
    setState(() {
      _movies = MovieService.convertJsonToMovie(mv);
    });
    return null;
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
          child: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: ListView(
          children: _movies
              .map((e) => ListTile(
                  leading: FlutterLogo(),
                  title: Text(e.name == null ? "no" : e.name),
                  subtitle: Text(e.type == null ? "no" : e.type),
                  trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeMovies(e.id))))
              .toList(),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _showMaterialDialog,
        tooltip: 'add movie',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
