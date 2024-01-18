import 'package:flutter/widgets.dart';

///NumExtension
extension NumExtension on num {
  ///Return a Sized box with height

  SizedBox get verticalSpace {
    return SizedBox(height: toDouble());
  }

  ///Return a Sized box with width
  SizedBox get horizontalSpace {
    return SizedBox(width: toDouble());
  }
}
