import 'package:cloud_firestore/cloud_firestore.dart';

class ApiCollectionsUtility{
  CollectionReference optionsRef = FirebaseFirestore.instance.collection('options');
  CollectionReference shiftsRef = FirebaseFirestore.instance.collection('shifts');
}