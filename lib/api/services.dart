import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class Services {
  final Logger _logger = Logger();
  final CollectionReference _firestore =
      FirebaseFirestore.instance.collection("MyTodos");

  Future<bool> updateTodo(item) async {
    try {
      await _firestore.doc(item).update({'todoStatus': true});
      return true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  Future<bool> deleteTodo(item) async {
    try {
      await _firestore.doc(item).delete();
      return true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }


}
