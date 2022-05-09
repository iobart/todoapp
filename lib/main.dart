import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:todoapp/wigets/activity_indicator.dart';
import 'package:todoapp/wigets/card_form.dart';
import 'package:todoapp/wigets/custom_app_bar.dart';
import 'package:todoapp/wigets/decoration.dart';

import 'api/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false
      ,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Flutter TODO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List todos = List.empty();
  String title = "";
  String description = "";
  DateTime date = DateTime.now();
  bool status = false;
  @override
  void initState() {
    super.initState();
    todos = ["Hello", "Hey There", date];
  }

  createToDo() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(title);

    Map<String, dynamic> todoList = {
      "todoTitle": title,
      "todoDesc": description,
      "todoDate": date,
      "todoStatus": status
    };

    documentReference.set(todoList).whenComplete(
        () => Logger().log(Level.info, "Data Store successfully"));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,),
      body: Column(
        children: [
          CardForm(
            flex: 4,
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.01, vertical: size.height * 0.01),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("MyTodos")
                  .orderBy('todoDate', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                } else if (snapshot.hasData || snapshot.data != null) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        QueryDocumentSnapshot<Object?>? documentSnapshot =
                            snapshot.data?.docs[index];
                        return Card(
                        //  color: _determineCardColor(documentSnapshot),
                          elevation: 4,
                          child: ListTile(
                            selectedTileColor: Colors.blue,
                            leading: _buttonUpdate(documentSnapshot),
                            title: Text((documentSnapshot != null)
                                ? (documentSnapshot["todoTitle"])
                                : ""),
                            subtitle: Text((documentSnapshot != null)
                                ? ((documentSnapshot["todoDesc"] != null)
                                    ? documentSnapshot["todoDesc"]
                                    : "")
                                : ""),

                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                setState(() {
                                  //todos.removeAt(index);
                                  Services().deleteTodo((documentSnapshot != null)
                                      ? (documentSnapshot["todoTitle"])
                                      : "");
                                });
                              },
                            ),
                          ),
                        );
                      });
                }
                return const ActivityIndicator();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: const Text("Add Todo"),
                  content: SizedBox(
                    width: 300,
                    height: 120,
                    child: Column(
                      children: [
                        TextField(
                          decoration: decorationWig(label: 'Title'),
                          onChanged: (String value) {
                            title = value;
                          },
                        ),
                        TextField(
                          decoration: decorationWig(label: 'Body'),
                          onChanged: (String value) {
                            description = value;
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              createToDo();
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text("Agregar")),
                    )
                  ],
                );
              });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }


  Widget _buttonUpdate(documentSnapshot) {
    return IconButton(icon: const Icon(Icons.check,color: Colors.green,), onPressed: () {
      setState(() {
        Services().updateTodo((documentSnapshot != null)
            ? (documentSnapshot["todoTitle"])
            : "");
      });
    });
  }
}
