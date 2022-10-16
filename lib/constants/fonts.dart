import 'package:flutter/material.dart';

// Note: to use a given text style with a custom color, do something like:
// SchejFonts.header.copyWith(color: SchejColors.green)

class Fonts {
  static const TextStyle header = TextStyle(
    fontFamily: 'DM Sans',
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.6,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: 'DM Sans',
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'DM Sans',
    color: Colors.black,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1,
  );

  static const TextStyle medium = TextStyle(
    fontFamily: 'DM Sans',
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'DM Sans',
    color: Colors.black,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1,
  );

  static const TextStyle small = TextStyle(
    fontFamily: 'DM Sans',
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle smallBold = TextStyle(
    fontFamily: 'DM Sans',
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle smallMedium = TextStyle(
    fontFamily: 'DM Sans',
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}
