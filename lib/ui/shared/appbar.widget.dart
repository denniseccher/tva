import 'package:flutter/material.dart';
import 'package:loomeive/loomeive.dart';
import 'package:miss_minutes/bloc/shifts/shifts.bloc.dart';
import 'package:miss_minutes/utilities/functions.utility.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

PreferredSizeWidget evAppBar({ required BuildContext context, required ShiftBloc shiftBloc }){
  return AppBar(
    leading: Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 8,
        top: 8,
        bottom: 8
      ),
      child: CircleAvatar(
        backgroundImage: AssetImage('assets/dennis.png'), // Immagine placeholder
      ),
    ),
    leadingWidth: 16 + 8 + 40,
    actionsPadding: EdgeInsets.symmetric(
      horizontal: 8
    ),
    titleSpacing: 0,
    backgroundColor: Colors.black,
    actions: [
      IconButton(
        onPressed: () => openSheet(context: context, bloc: shiftBloc),
        icon: Icon(
          Icons.download_rounded
        ),
        color: Colors.white,
      )
    ],
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GradientText(
          "${DateTime.now().greeting().toSentenceCase()} Dennis",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500
          ),
          colors: [
            Color(0xFFFF0000),
            Color.fromARGB(255, 251, 137, 60)
          ],
        ),
        Text(
          "CSI Trento Nuoto",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white
          ),
        )
      ],
    ),
  );
}