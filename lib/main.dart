import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'add_dog.dart';
import 'dog.dart';
import 'login.dart';
import 'tasks.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const LoginPage(title: 'Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var dogs= [];

  Future<void> loadData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('dogs');
    DatabaseEvent event = await ref.once();
    var snapshot = event.snapshot;
    var tmpdogs = [];
    snapshot.children.forEach((child) {
      print(child.key);
      tmpdogs.add(child.value);
    });
    dogs = tmpdogs;
    setState(() {

    });
  }

  _MyHomePageState(){
    loadData();
    FirebaseDatabase.instance.ref().child("dogs").onChildChanged.listen((event) {
      loadData();
    });
    FirebaseDatabase.instance.ref().child("dogs").onChildAdded.listen((event) {
      loadData();
    });
    FirebaseDatabase.instance.ref().child("dogs").onChildRemoved.listen((event) {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Image(
              image: NetworkImage('https://cdn.pixabay.com/photo/2016/04/07/18/57/silhouette-1314467_960_720.png'),
              width: 100,
              height: 100,
              color: Colors.green,
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: dogs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(top: 2, bottom: 2, left: 100, right: 100),
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TasksPage(title: 'Tasks', dogDetails: dogs[index],)),
                        );
                      },
                      child: Text('${dogs[index]['name']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDogPage(title: 'Add Dog Profile')),
          );
        },
        tooltip: 'Add Dog Profile',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
