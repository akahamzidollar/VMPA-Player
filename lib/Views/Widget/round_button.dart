import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    Key? key,
    required this.size,
    required this.onPress,
    required this.text,
  }) : super(key: key);
  final void Function() onPress;
  final Size size;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          minimumSize: Size(size.width * 0.9, 60)),
      onPressed: onPress,
      child: Text(
        text,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
