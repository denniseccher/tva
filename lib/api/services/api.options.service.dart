import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:miss_minutes/api/classes/api.option.class.dart';
import 'package:miss_minutes/api/utilities/api.collections.utility.dart';

class ApiOptionsService{

  ApiCollectionsUtility apiCollections = ApiCollectionsUtility();

  Future<List<ApiOption>> getOptions() async{
    QuerySnapshot snapshot = await apiCollections.optionsRef.where("uid", isEqualTo: FirebaseAuth.instance.currentUser?.uid).get();
    List<QueryDocumentSnapshot<Object?>> docs = snapshot.docs;

    return docs.map(
      (doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ApiOption(
          value: data['value'],
          label: data['label'],
          location: data['location']
        );
      } 
    ).toList();
  }
}