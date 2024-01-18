import 'package:flutter/material.dart';
import 'package:scanner/generated/l10n.dart';

///
/// [Pallets] Contains all the app colors
class Pallets {
  ///
  /// [ @since	v0.0.1 ]
  /// [@var		const	primary]
  ///
  ///

  static const scheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF4F46E5),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFFE0E7FF),
    onSecondary: Color(0xFF4F46E5),
    error: Color(0xFFEF4444),
    onError: Color(0xFFFFFFFF),
    background: Color(0xFFFFFFFF),
    onBackground: Color(0xFF111827),
    surface: Color(0xFFF3F4F6),
    onSurface: Color(0xFF111827),
    surfaceTint: Color(0xFFFFFFFF),
  );

  ///
  final colorScheme = scheme;

  ///searchDecoration
  static final InputDecoration searchDecoration = InputDecoration(
    suffixIcon: const Icon(Icons.search),
    filled: true,
    fillColor: scheme.surface,
    hintStyle: const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    hintText: S.current.search,
    // hintText: l10n.search,
    disabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    border: const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  );
}
