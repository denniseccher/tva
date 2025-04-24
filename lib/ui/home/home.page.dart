import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:miss_minutes/bloc/shifts/shifts.bloc.dart';
import 'package:miss_minutes/bloc/shifts/shifts.event.dart';
import 'package:miss_minutes/bloc/shifts/shifts.state.dart';
import 'package:miss_minutes/ui/home/widgets/shiftlist.widget.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      // The refresh function triggers a haptic feedback and requires a shifts reload
      onRefresh: () async{
        HapticFeedback.mediumImpact();
        context.read<ShiftBloc>().add(LoadShifts());
      },
      color: Theme.of(context).colorScheme.tertiary,
      // If Shifts are loaded, ShiftList is displayed otherwise a loading animation is shown
      child: BlocBuilder<ShiftBloc, ShiftsState>(
        builder: (context, state) {
          if(state is ShiftLoaded){
            return evShiftList(shifts: state.shifts);
          }

          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Theme.of(context).colorScheme.tertiary,
              size: 32
            ),
          );
        },
      ),
    );
  }
}