import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miss_minutes/bloc/shifts/shifts.bloc.dart';
import 'package:miss_minutes/ui/add_shift/add_shift.page.dart';
import 'package:miss_minutes/utilities/open_modal.utility.dart';

Widget evFab({ required BuildContext context, required ShiftBloc shiftBloc }){
  return FloatingActionButton(
    // When pressed, the FAB triggers a haptic feedback and opens the bottom sheet to add a new shift
    onPressed: (){
      HapticFeedback.lightImpact();
      openModal(
        context: context,
        returnWidget: AddShiftPage(bloc: shiftBloc)
      );
    },
    heroTag: null,
    child: Icon(
      Icons.add_rounded
    ),
  );
}