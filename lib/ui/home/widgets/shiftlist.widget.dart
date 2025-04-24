import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:miss_minutes/classes/shift.class.dart';
import 'package:miss_minutes/ui/home/widgets/shifttile.widget.dart';
import 'package:miss_minutes/utilities/functions.utility.dart';

Widget evShiftList({ required List<Shift> shifts }){
  final yourScrollController = ScrollController();

  return ScrollbarTheme(
    data: ScrollbarThemeData(
      thickness: WidgetStatePropertyAll(6),
      radius: Radius.circular(8)
    ),
    child: Scrollbar(
      interactive: true,
      controller: yourScrollController,
      child: GroupedListView<Shift, String>( // Specifica i tipi corretti
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        elements: shifts, // La tua lista già ordinata cronologicamente
        controller: yourScrollController,
        // --- MODIFICA groupBy ---
        groupBy: (shift) => DateFormat.yMMMM('it').format(shift.dtStart),
        // --- FINE MODIFICA groupBy ---
      
        // --- MODIFICA groupComparator ---
        groupComparator: (monthYear1, monthYear2) {
          try {
            final formatter = DateFormat.yMMMM('it');
            final date1 = formatter.parse(monthYear1);
            final date2 = formatter.parse(monthYear2);
            return date1.compareTo(date2);
          } catch (e) {
            print("Errore durante il confronto dei gruppi: $e");
            return monthYear1.compareTo(monthYear2);
          }
        },
        // --- FINE MODIFICA groupComparator ---
      
        separator: Gap(8),
      
        itemBuilder: (context, shift) => evShiftTile(shift: shift, context: context),
      
        groupSeparatorBuilder: (String monthYear) => Padding( // Specifica il tipo
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                monthYear.toUpperCase(), // Ora mostra "Mese Anno"
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16
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
        order: GroupedListOrder.DESC, // Opzionale, il comparator dovrebbe bastare
      ),
    ),
  );
}