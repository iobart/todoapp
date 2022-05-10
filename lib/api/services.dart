import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:translator/translator.dart';
import 'package:uuid/uuid.dart';
class Services {
  final Logger _logger = Logger();
  final CollectionReference _firestore =
      FirebaseFirestore.instance.collection("MyTodos");

  final translator = GoogleTranslator();
  Future<void> createToDo({String? title,String? description,DateTime? date,bool? status}) async {
    var uuid = Uuid();
    Map<String, dynamic> todoList = {
      "todoTitle": title,
      "todoDesc": description,
      "todoDate": date,
      "todoStatus": status,
      "todoId": uuid.v4().toLowerCase()
    };
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(todoList["todoId"]);

    await Future.forEach(todoList.keys, (String element) async {
      if (todoList[element] is String) {
        var translation =
            await translator.translate(todoList[element], from: 'es', to: 'en');
        todoList[element] = translation.text;
        print(translation);
      }
    });
    documentReference.set(todoList).whenComplete(
        () => Logger().log(Level.info, "Data Store successfully"));
  }

  Future<bool> updateTodo(item,status) async {
    try {
      final b=item.toString().toLowerCase();
      await _firestore.doc(b).update({'todoStatus': !status});
      return true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  Future<bool> deleteTodo(item) async {
    try {
      final b=item.toString().toLowerCase();
      await _firestore.doc(b).delete();
      return true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }
}
