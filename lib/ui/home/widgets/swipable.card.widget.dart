import 'package:flutter/material.dart';

class SwipableCard extends StatefulWidget {
  /// Contenuto principale della card
  final Widget child;

  /// Lista di action widget da mostrare a destra
  final List<Widget> actions;

  /// Altezza della card
  final double height;

  /// Colore di sfondo della card
  final Color backgroundColor;

  const SwipableCard({
    super.key,
    required this.child,
    this.actions = const [],
    this.height = 112,
    this.backgroundColor = Colors.blueGrey,
  });

  @override
  _SwipableCardState createState() => _SwipableCardState();
}

class _SwipableCardState extends State<SwipableCard> {
  double iconWidth = 0;
  bool isVisible = false;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      if (details.delta.dx < 0) {
        // swipe verso sinistra → mostra actions
        iconWidth += details.delta.dx.abs() * 4;
        iconWidth = iconWidth.clamp(0, widget.height / 2);
      } else if (details.delta.dx > 0) {
        // swipe verso destra → nascondi actions
        iconWidth -= details.delta.dx.abs() * 4;
        iconWidth = iconWidth.clamp(0, widget.height / 2);
      }

      if (iconWidth == (widget.height / 2) && !isVisible) isVisible = true;
      if (iconWidth == 0 && isVisible) isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        Expanded(
          child: GestureDetector(
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            child: Card(
              color: widget.backgroundColor,
              child: Container(
                height: widget.height,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: widget.child,
              ),
            ),
          ),
        ),

        // Mostra dinamicamente le actions in base a quanti widget sono stati passati
        ...widget.actions.map((action) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: iconWidth,
            height: widget.height,
            child:
                isVisible
                    ? CustomExpandableFab(
                      width: iconWidth,
                      height: widget.height,
                      child: action,
                    )
                    : const SizedBox.shrink(),
          );
        }),
      ],
    );
  }
}

class CustomExpandableFab extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const CustomExpandableFab({
    Key? key,
    required this.width,
    required this.height,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double iconMaxSize = 28;
    double iconSize = (width * 0.6).clamp(0, iconMaxSize);

    return Material(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(width / 2),
      ),
      color:
          Theme.of(context).floatingActionButtonTheme.backgroundColor ??
          Colors.blue,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.center,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: iconSize),
            duration: const Duration(milliseconds: 300),
            builder: (context, size, _) {
              return SizedBox(
                width: size,
                height: size,
                child: FittedBox(child: child),
              );
            },
          ),
        ),
      ),
    );
  }
}
