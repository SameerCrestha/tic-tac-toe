import 'package:flutter/material.dart';
import 'package:tic_tac_toe/enums.dart';

class BoxContainer extends StatelessWidget {
  const BoxContainer({super.key, required this.state, this.onClickHandler});
  final BoxState state;
  final VoidCallback? onClickHandler;
  @override
  Widget build(BuildContext context) {
    IconData? boxIcon;
    switch (state) {
      case BoxState.circle:
        boxIcon = Icons.circle_outlined;
        break;
      case BoxState.cross:
        boxIcon = Icons.close;
        break;
      default:
    }
    return InkWell(
      onTap: onClickHandler,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue, // Set your desired border color
            width: 2.0, // Set the border width
          ),
        ),
        width: 100,
        height: 100,
        child: Icon(
          boxIcon,
          size: 100,
        ),
      ),
    );
  }
}
