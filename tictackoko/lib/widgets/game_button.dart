import 'package:flutter/material.dart';
import '../utils/constants.dart';

class GameButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Widget? child;
  final TextStyle? textStyle;

  const GameButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width = 300,
    this.height = 65,
    this.child,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: onPressed == null ? Colors.grey.shade300 : AppColors.primary,
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
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          onTap: onPressed,
          child: Center(
            child: child ?? Text(
              text,
              style: textStyle ?? const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'ClashGrotesk',
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
