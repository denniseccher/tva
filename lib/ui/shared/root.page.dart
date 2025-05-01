import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_minutes/bloc/shifts/shifts.bloc.dart';
import 'package:miss_minutes/bloc/shifts/shifts.event.dart';
import 'package:miss_minutes/ui/home/home.page.dart';
import 'package:miss_minutes/ui/login/login.page.dart';
import 'package:miss_minutes/ui/shared/appbar.widget.dart';
import 'package:miss_minutes/ui/shared/fab.widget.dart';

class RootPage extends StatelessWidget{
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    final FirebaseAuth current = FirebaseAuth.instance;

    return current.currentUser != null ?
      BlocProvider(
        create: (context) => ShiftBloc()..add(LoadShifts()),
        child: Builder(
          builder: (context) {
            final ShiftBloc shiftBloc = BlocProvider.of<ShiftBloc>(context);
            return Scaffold(
              extendBody: true,
              appBar: evAppBar(context: context, shiftBloc: shiftBloc),
              floatingActionButton: evFab(context: context, shiftBloc: shiftBloc),
              floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
              body: HomePage(),
            );
          }
        ),
      )
      :
      LoginPage()
    ;
  }
  
}