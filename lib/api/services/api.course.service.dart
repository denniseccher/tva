import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:miss_minutes/api/classes/api.course.class.dart';
import 'package:miss_minutes/api/utilities/api.collections.utility.dart';

class ApiCourseService{
  final ApiCollectionsUtility _apiCollectionsUtility = ApiCollectionsUtility();
  final User? user = FirebaseAuth.instance.currentUser;

  Future<List<ApiCourse>> getCourses() async{
    QuerySnapshot snapshot = await _apiCollectionsUtility.coursesRef
      .where("uid", isEqualTo: user?.uid)
      .get();
    List<QueryDocumentSnapshot<Object?>> docs = snapshot.docs;

    return docs.map(
      (doc){
        try {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return ApiCourse.fromJson(data);
        } catch (e) {
          return null;
        }
      }
    ).where((element) => element != null).cast<ApiCourse>().toList();
  }

  void addCourse(ApiCourse newCourse){
    newCourse = newCourse.copyWith(
      uid: user?.uid
    );
    _apiCollectionsUtility.coursesRef.add(newCourse.toJson());
  }

  void deleteCourse(String id){
    _apiCollectionsUtility.coursesRef.doc(id).delete();
  }

  void updateCourse(ApiCourse newCourse){
    _apiCollectionsUtility.coursesRef.doc(newCourse.id).update(
      newCourse.toJson()
    );
  }
}