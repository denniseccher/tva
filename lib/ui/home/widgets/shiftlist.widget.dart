import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:miss_minutes/classes/shift.class.dart';
import 'package:miss_minutes/ui/home/widgets/shifttile.widget.dart';
import 'package:miss_minutes/utilities/functions.utility.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

Widget evShiftList({ required List<Shift> shifts }){
  final yourScrollController = ScrollController();

  return ScrollbarTheme(
    data: ScrollbarThemeData(
      thickness: WidgetStateProperty.all(6), // Usa WidgetStateProperty.all
      radius: Radius.circular(8),
    ),
    child: Scrollbar(
      interactive: true,
      controller: yourScrollController, // Il controller va qui
      child: CustomScrollView( // Usa CustomScrollView
        controller: yourScrollController, // E anche qui
        physics: const AlwaysScrollableScrollPhysics(), // La fisica va qui
        slivers: <Widget>[
          SliverPadding( // Applica il padding generale qui se necessario
            padding: EdgeInsets.symmetric(horizontal: 16.0), // Padding orizzontale generale
            sliver: SliverGroupedListView<Shift, String>( // Usa la versione Sliver
              elements: shifts,
              groupBy: (shift) => DateFormat.yMMMM('it').format(shift.dtStart),
              groupComparator: (monthYear1, monthYear2) {
                try {
                  final formatter = DateFormat.yMMMM('it');
                  final date1 = formatter.parse(monthYear1);
                  final date2 = formatter.parse(monthYear2);
                  return date1.compareTo(date2);
                } catch (e) {
                  return monthYear1.compareTo(monthYear2);
                }
              },
              itemComparator: (shift1, shift2) => shift1.dtStart.compareTo(shift2.dtStart), // Aggiunto itemComparator se l'ordine cronologico è per item
              separator: const Gap(8), // Usa const
              itemBuilder: (context, shift) => evShiftTile(shift: shift, context: context),
              groupSeparatorBuilder: (String monthYear) => Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0), // Padding verticale per il separatore
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      monthYear.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${count(monthYear, shifts)}€",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        // color: Theme.of(context).colorScheme.onSurface.withAlpha(192)
                      ),
                    )
                  ],
                ),
              ),
              order: GroupedListOrder.DESC,
              // NOTA: Il padding interno agli item/separatori va gestito dentro itemBuilder/groupSeparatorBuilder
              // Il padding: EdgeInsets.all(16) originale è stato spostato in SliverPadding
            ),
          ),

          // --- AGGIUNTA DELLO SPAZIO ---
          SliverToBoxAdapter(
            child: SizedBox(height: 32), // Aggiunge spazio verticale
          ),
          // --- FINE AGGIUNTA SPAZIO ---

          // --- AGGIUNTA DEL TESTO ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Padding per il testo
              child: Center( // O allinea come preferisci
                child: GradientText(
                  "Designed & Developed by Dennis",
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600
                  ),
                  textAlign: TextAlign.center,
                  colors: [
                    Colors.purple,
                    Colors.deepOrange
                  ],
                ),
              ),
            ),
          ),
          // --- FINE AGGIUNTA TESTO ---

           // --- AGGIUNTA DI ALTRO SPAZIO IN FONDO (Opzionale) ---
          SliverToBoxAdapter(
            child: SizedBox(height: 20), // Spazio extra sotto il testo
          ),
          // --- FINE AGGIUNTA SPAZIO ---
        ],
      ),
    ),
  );
}