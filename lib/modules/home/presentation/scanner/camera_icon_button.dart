import 'package:flutter/material.dart';

///CameraIconButton
class CameraIconButton extends StatelessWidget {
  ///CameraIconButton
  const CameraIconButton({
    required this.iconData,
    super.key,
    this.onTap,
  });

  ///onTap
  final VoidCallback? onTap;

  ///iconData
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        iconData,
        color: Colors.white,
      ),
    );
  }
}
