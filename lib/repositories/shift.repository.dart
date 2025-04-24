import 'package:miss_minutes/api/classes/api.shift.class.dart';
import 'package:miss_minutes/api/services/api.shift.service.dart';
import 'package:miss_minutes/classes/shift.class.dart';

class ShiftRepository{
  final ApiShiftService _apiOptionsService = ApiShiftService();

  Future<List<Shift>> getShifts() async{
    final List<ApiShift> apiShifts = await _apiOptionsService.getShifts();
    return apiShifts.map((apiShift) => Shift.fromApi(apiShift)).toList();
  }

  void addShift(Shift newShift){
    _apiOptionsService.addShift(newShift);
  }

  void deleteShift(String id){
    _apiOptionsService.deleteShift(id);
  }

  void updateShift(Shift newShift){
    _apiOptionsService.updateShift(newShift);
  }
}