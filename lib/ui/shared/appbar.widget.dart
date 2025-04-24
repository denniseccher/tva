import 'package:flutter/material.dart';
import 'package:miss_minutes/bloc/shifts/shifts.bloc.dart';
import 'package:miss_minutes/utilities/functions.utility.dart';

PreferredSizeWidget evAppBar({ required BuildContext context, required ShiftBloc shiftBloc }){
  return AppBar(
    titleSpacing: 16,
    title: CircleAvatar(
      foregroundImage: AssetImage(
        'assets/dennis.png'
      ),
    ),
    backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
    actions: [
      IconButton(
        onPressed: () => openSheet(context: context, bloc: shiftBloc),
        icon: Icon(
          Icons.download_rounded
        )
      )
    ],
  );
}