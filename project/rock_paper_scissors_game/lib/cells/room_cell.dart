import 'package:flutter/material.dart';
import 'package:rock_paper_scissors_game/hubs/game_hub.dart';
import 'package:rock_paper_scissors_game/pages/game_page.dart';

import '../models/room.dart';

class RoomCell extends StatelessWidget {
  final RoomInfo room;
  final VoidCallback onPress;

  const RoomCell({super.key, required this.room, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xAA231917),
              blurRadius: 12,
              offset: Offset(0, 2), // Shadow position
            ),
          ],
        ),
        child: ListTile(
          onTap: onPress,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
          tileColor: Color(0xFF231917),
          textColor: Colors.white,
          // leading: Icon(
          //   todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          //   color: tdBlue,
          // ),
          title: Text(
            room.name,
            // textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              // color: tdBlack,
              // decoration: todo.isDone ? TextDecoration.lineThrough : null,
            ),
          ),
          // trailing: Container(
          //   padding: EdgeInsets.all(0),
          //   margin: EdgeInsets.symmetric(vertical: 12),
          //   height: 35,
          //   width: 35,
          //   decoration: BoxDecoration(
          //     color: tdRed,
          //     borderRadius: BorderRadius.circular(5),
          //   ),
          //   child: IconButton(
          //     color: Colors.white,
          //     iconSize: 18,
          //     icon: Icon(Icons.delete),
          //     onPressed: () {
          //       // print('Clicked on delete icon');
          //       onDeleteItem(todo.id);
          //     },
          //   ),
          // ),
        ),
      ),
    );
  }
}
