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
      debugShowCheckedModeBanner: false,
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
  @override
  String title = "";
  String description = "";
  DateTime date = DateTime.now();
  bool status = false;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: widget.title,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,

        children: [
          CardForm(
            flex: 1,
            padding: EdgeInsets.all(size.width * 0.05),
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
                        QueryDocumentSnapshot? documentSnapshot =
                            snapshot.data?.docs[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(10)),
                          color: (documentSnapshot != null)
                              ? documentSnapshot['todoStatus']
                                  ? Colors.green[200]
                                  : Colors.white
                              : Colors.white,
                          //  color: _determineCardColor(documentSnapshot),
                          elevation: 4,
                          child: ListTile(
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
                                  Services().deleteTodo((documentSnapshot != null)
                                      ? (documentSnapshot["todoId"])
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
                    side: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(10)),
                  title: const Text("Add Todo"),
                  content: SizedBox(
                    width: 300,
                    height: 120,
                    child: Column(
                      children: [
                        TextField(
                          decoration: decorationWig(label: 'Titulo'),
                          onChanged: (String value) {
                            title = value;
                          },
                        ),
                        TextField(
                          decoration: decorationWig(label: 'Descripción'),
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
                              Services().createToDo(
                                  title: title,
                                  description: description,
                                  date: date,
                                  status: status);
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
    return IconButton(
        icon: const Icon(
          Icons.check,
          color: Colors.green,
        ),
        onPressed: () {
          setState(() {
            if (documentSnapshot != null) {
              Services().updateTodo(documentSnapshot.data()["todoId"],
                  documentSnapshot.data()["todoStatus"]);
            }
          });
        });
  }
}
