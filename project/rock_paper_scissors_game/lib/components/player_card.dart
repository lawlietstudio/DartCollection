import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final String card;
  const PlayerCard({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      runAlignment: WrapAlignment.center,
      children: [
        Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset("images/${card}.jpg"),
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, .7),
                blurRadius: 16,
                offset: Offset(0, 2), // Shadow position
              ),
            ],
          ),
        ),
      ],
    );
  }
}
