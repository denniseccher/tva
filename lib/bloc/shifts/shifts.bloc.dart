import 'package:bloc/bloc.dart';
import 'package:miss_minutes/bloc/shifts/shifts.event.dart';
import 'package:miss_minutes/bloc/shifts/shifts.state.dart';
import 'package:miss_minutes/repositories/shift.repository.dart';

class ShiftBloc extends Bloc<ShiftsEvent, ShiftsState> {

  final ShiftRepository _shiftRepository = ShiftRepository();

  ShiftBloc() : super(ShiftInitial()) {
    on<LoadShifts>(_onLoadShifts);

    on<AddShift>(_onAddShift);

    on<DeleteShift>(_onDeleteShift);

    on<UpdateShift>(_onUpdateShift);
  }

  // Funzione eseguita quando viene richiesto il caricamento dei dati
  void _onLoadShifts(LoadShifts event, Emitter<ShiftsState> emit) async {
    emit(ShiftLoading());
    try {
      emit(ShiftLoaded(await _shiftRepository.getShifts()));
    } catch (e) {
      emit(ShiftError("Errore durante il caricamento dei turni: ${e.toString()}"));
    }
  }

  // Funzione eseguita quando viene richiesta l'aggiunta di un turno
  void _onAddShift(AddShift event, Emitter<ShiftsState> emit) async{
    emit(ShiftLoading());
    _shiftRepository.addShift(event.shiftToAdd);
    emit(ShiftLoaded(await _shiftRepository.getShifts()));
  }

  // Funzione eseguita quando viene richiesta l'eliminazione di un turno
  void _onDeleteShift(DeleteShift event, Emitter<ShiftsState> emit) async {
    emit(ShiftLoading());
    _shiftRepository.deleteShift(event.id);
    emit(ShiftLoaded(await _shiftRepository.getShifts()));
  }

  // Funzione eseguita quando viene richiesta l'aggiornamento di un turno
  void _onUpdateShift(UpdateShift event, Emitter<ShiftsState> emit) async{
    emit(ShiftLoading());
    _shiftRepository.updateShift(event.newShift);
    emit(ShiftLoaded(await _shiftRepository.getShifts()));
    
  }
}