import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_minutes/bloc/shifts/shifts.bloc.dart';
import 'package:miss_minutes/ui/home/home.page.dart';
import 'package:miss_minutes/ui/shared/appbar.widget.dart';
import 'package:miss_minutes/ui/shared/fab.widget.dart';

class RootPage extends StatelessWidget{
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ShiftBloc shiftBloc = BlocProvider.of<ShiftBloc>(context);

    return Scaffold(
      extendBody: true,
      appBar: evAppBar(context: context, shiftBloc: shiftBloc),
      floatingActionButton: evFab(context: context, shiftBloc: shiftBloc),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: HomePage(),
    );
  }
  
}