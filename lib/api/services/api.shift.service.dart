import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miss_minutes/api/classes/api.shift.class.dart';
import 'package:miss_minutes/api/utilities/api.collections.utility.dart';
import 'package:miss_minutes/classes/shift.class.dart';

class ApiShiftService{
  final ApiCollectionsUtility _apiCollectionsUtility = ApiCollectionsUtility();

  Future<List<ApiShift>> getShifts() async{
    QuerySnapshot snapshot = await _apiCollectionsUtility.shiftsRef.orderBy('dtStart').get();
    List<QueryDocumentSnapshot<Object?>> docs = snapshot.docs;

    return docs.map(
      (doc){
        try {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return ApiShift.fromJson(data);
        } catch (e) {
          return null;
        }
      }
    ).where((element) => element != null).cast<ApiShift>().toList();
  }

  void addShift(Shift newShift) {
    _apiCollectionsUtility.shiftsRef.add(newShift.toJson());
  }

  void deleteShift(String id){
    _apiCollectionsUtility.shiftsRef.doc(id).delete();
  }

  void updateShift(Shift newShift){
    _apiCollectionsUtility.shiftsRef.doc(newShift.id).update(
      newShift.toJson()
    );
  }
}