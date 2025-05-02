import 'dart:math';

import 'package:flutter/material.dart';

openModal({ required BuildContext context, required dynamic returnWidget }){
  showModalBottomSheet(
    sheetAnimationStyle: AnimationStyle(
      duration: Duration(milliseconds: 400),
      // curve: Curves.fastEaseInToSlowEaseOut
    ),
    constraints: BoxConstraints(
      maxHeight: min(MediaQuery.of(context).size.height - (kToolbarHeight * 2), MediaQuery.of(context).size.height * 0.8),
      minHeight: kBottomNavigationBarHeight * 2,
      minWidth: min(MediaQuery.of(context).size.width, 512),
      maxWidth: 512
    ),
    showDragHandle: true,
    context: context,
    isScrollControlled: true, // Già corretto
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      ),
    ),
    builder: (context) {
      // Usa il nuovo StatefulWidget invece della funzione
      return ConfirmExitWrapper(
        child: returnWidget,
        // TODO implementare il canPop
      );
    },
  );
}

// Widget wrapper per aggiungere la conferma di chiusura al bottom sheet
class ConfirmExitWrapper extends StatefulWidget {
  const ConfirmExitWrapper({super.key, required this.child, this.canPop = true});

  final Widget child;
  final bool canPop;

  @override
  ConfirmExitWrapperState createState() => ConfirmExitWrapperState();
}

class ConfirmExitWrapperState extends State<ConfirmExitWrapper> {

  @override
  Widget build(BuildContext context) {
    // PopScope intercetta l'evento di "pop" (chiusura)
    return PopScope(
      // canPop: se è false, impedisce la chiusura automatica e onPopInvoked viene chiamato con didPop = false
      // Se è true, onPopInvoked viene chiamato con didPop = true DOPO che la navigazione è avvenuta
      canPop: widget.canPop, // Permette la chiusura diretta solo se non stiamo gestendo il pop
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          // Se didPop è true, il bottom sheet si è già chiuso. Non fare nulla qui.
          return;
        }
        // Se didPop è false, intercettiamo l'evento di chiusura.
        if (!widget.canPop) {
          _showExitConfirmationDialog(context);
        }
      },
      child: widget.child, // Mostra il widget originale passato
    );
  }

  // Funzione per mostrare il popup di conferma
  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      // builder usa un nuovo BuildContext (dialogContext)
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Conferma chiusura'),
          content: const Text('Sei sicuro di voler chiudere? Le modifiche potrebbero non essere salvate.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annulla'),
              onPressed: () {
                // Chiudi solo il dialog
                Navigator.of(dialogContext).pop();
                // Resetta il flag in modo che l'utente possa riprovare a chiudere
              },
            ),
            TextButton(
              child: const Text('Chiudi'),
              onPressed: () {
                // Chiudi prima il dialog
                Navigator.of(dialogContext).pop();
                // Poi chiudi il bottom sheet
                // È importante usare il context del bottom sheet (quello originale)
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}