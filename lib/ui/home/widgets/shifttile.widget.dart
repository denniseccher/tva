import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_minutes/bloc/shifts/shifts.bloc.dart';
import 'package:miss_minutes/bloc/shifts/shifts.event.dart';
import 'package:miss_minutes/classes/shift.class.dart';
import 'package:miss_minutes/utilities/extensions.utility.dart';
import 'package:miss_minutes/ui/add_shift/add_shift.page.dart';
import 'package:miss_minutes/utilities/open_modal.utility.dart';

Widget evShiftTile({ required Shift shift, required BuildContext context }){
  bool recap = true;
  
  return StatefulBuilder(
    builder: (context, setState) {
    // builder: (context, setState) {
      return ListTile(
        onTap: () {
          setState((){
            recap = !recap;
          });
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)
        ),
        leading: Text(
          shift.dtStart.toLocaleDayShort(context)
        ),
        title: Text(shift.name.toSentenceCase()
        ),
        subtitle: Text(
          recap ? "${shift.dtStart.difference(shift.dtEnd).abs().toHHmmSS()}h • ${shift.earning}€" : "${shift.dtStart.toLocaleTime(context)} - ${shift.dtEnd.toLocaleTime(context)}"
        ), // Formatta meglio la data/ora
        trailing: PopupMenuButton(
          padding: EdgeInsets.all(8),
          menuPadding: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)
          ),
          itemBuilder:(context) {
            return [
              PopupMenuItem(
                value: 'delete',
                onTap: () {
                  context.read<ShiftBloc>().add(DeleteShift(id: shift.id));
                },
                child: ListTile(
                  leading: Icon(
                    Icons.delete
                  ),
                  title: Text(
                    "Elimina"
                  ),
                )
              ),
              PopupMenuItem(
                value: 'edit',
                onTap: () {
                  final ShiftBloc shiftBloc = BlocProvider.of<ShiftBloc>(context);
                  openModal(
                    context: context,
                    returnWidget: AddShiftPage(bloc: shiftBloc, shift: shift,)
                  );
                },
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)
                  ),
                  leading: Icon(
                    Icons.edit
                  ),
                  title: Text(
                    "Modifica"
                  ),
                )
              ),
            ];
          },
        ),
        tileColor: switch (shift.name.toLowerCase()) {
          'clarina' => Theme.of(context).colorScheme.tertiaryContainer,
          'perfezionamento' => Theme.of(context).colorScheme.tertiary,
      
          String() => Theme.of(context).colorScheme.surface
        },
        textColor: switch (shift.name.toLowerCase()) {
          'clarina' => Theme.of(context).colorScheme.onTertiaryContainer,
          'perfezionamento' => Theme.of(context).colorScheme.onTertiary,
      
          String() => Theme.of(context).colorScheme.onSurface
        },
      );
    }
  );
}