import 'package:flutter/material.dart';
import '../utils/constants.dart';

class GameButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GameButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 65,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: const Offset(6, 6),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'ClashGrotesk',
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
