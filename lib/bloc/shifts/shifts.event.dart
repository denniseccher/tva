import 'package:equatable/equatable.dart';
import 'package:miss_minutes/classes/shift.class.dart';

abstract class ShiftsEvent extends Equatable{
  const ShiftsEvent();

  @override
  List<Object> get props => [];
}

// Evento per caricare i turni (es. all'avvio o con pull-to-refresh)
class LoadShifts extends ShiftsEvent {}

// Evento per aggiungere un nuovo turno
class AddShift extends ShiftsEvent {
  final Shift shiftToAdd; // Passiamo l'intero oggetto turno

  const AddShift(this.shiftToAdd);

  @override
  List<Object> get props => [shiftToAdd];
}

// Potresti aggiungere altri eventi: UpdateShift, DeleteShift, etc.
class DeleteShift extends ShiftsEvent{
  final String id;

  const DeleteShift({required this.id});
}

class UpdateShift extends ShiftsEvent{
  final Shift newShift;

  const UpdateShift({required this.newShift});
}