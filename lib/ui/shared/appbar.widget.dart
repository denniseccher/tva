import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miss_minutes/bloc/shifts/shifts.bloc.dart';
import 'package:miss_minutes/ui/login/login.page.dart';
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
    
    centerTitle: false,
    titleSpacing: 0,
    backgroundColor: Colors.black,
    actions: [
      IconButton(
        onPressed: () {
          // print("Username: ${FirebaseAuth.instance.currentUser?.displayName}");
          Navigator.of(context).push(
            MaterialPageRoute(builder:(context) => LoginPage(),)
          );
        },
        icon: Icon(
          Icons.login
        ),
        color: Colors.white,
      ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          "Ciao ${FirebaseAuth.instance.currentUser?.displayName}",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500
          ),
          colors: [
            Colors.purple,
            Colors.deepOrange
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