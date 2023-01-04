import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final String gesture;
  final VoidCallback? onPress;
  final bool isStarted;
  const OptionCard(
      {super.key,
      required this.gesture,
      this.onPress,
      required this.isStarted});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Visibility(
        visible: isStarted,
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true,
        child: GestureDetector(
          onTap: onPress,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Wrap(
              direction: Axis.vertical,
              runAlignment: WrapAlignment.center,
              children: [
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset("images/$gesture.jpg"),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
