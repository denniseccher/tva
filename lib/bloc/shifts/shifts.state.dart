import 'package:equatable/equatable.dart';
import 'package:miss_minutes/classes/shift.class.dart';

abstract class ShiftsState extends Equatable {
  const ShiftsState();

  @override
  List<Object> get props => [];
}

// Stato iniziale o mentre si caricano i dati
class ShiftInitial extends ShiftsState {}
class ShiftLoading extends ShiftsState {}

// Stato quando i turni sono stati caricati con successo
class ShiftLoaded extends ShiftsState {
  final List<Shift> shifts; // La lista dei turni

  const ShiftLoaded(this.shifts);

  @override
  List<Shift> get props => shifts; // Importante per Equatable!
}

// Stato in caso di errore
class ShiftError extends ShiftsState {
  final String message;

  const ShiftError(this.message);

  @override
  List<Object> get props => [message];
}