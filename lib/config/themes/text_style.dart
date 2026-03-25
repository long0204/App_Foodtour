import 'package:flutter/material.dart';
import '../gen/fonts.gen.dart';
import 'theme.dart';

const String _k2d = FontFamily.k2d;

const k2d300 = TextStyle(
    fontFamily: _k2d,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    color: grey900,
    fontSize: 12,
    letterSpacing: -0.05);
const k2d400 = TextStyle(
    fontFamily: _k2d,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    color: grey900,
    fontSize: 14,
    letterSpacing: -0.05);
const k2d500 = TextStyle(
    fontFamily: _k2d,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    color: grey900,
    fontSize: 16,
    letterSpacing: -0.05);
const k2d600 = TextStyle(
    fontFamily: _k2d,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    color: grey900,
    fontSize: 16,
    letterSpacing: -0.05);
const k2d600B = TextStyle(
    fontFamily: _k2d,
    fontWeight: FontWeight.w900,
    fontStyle: FontStyle.normal,
    color: grey900,
    fontSize: 16,
    letterSpacing: -0.05);
const k2d60020 = TextStyle(
    fontFamily: _k2d,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    color: grey900,
    fontSize: 20,
    letterSpacing: -0.05);
const k2d60024 = TextStyle(
    fontFamily: _k2d,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    color: grey900,
    fontSize: 21,
    letterSpacing: -0.05);
const k2d700 = TextStyle(
    fontFamily: _k2d,
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.normal,
    color: grey900,
    fontSize: 32,
    letterSpacing: -0.05);

extension ColorExtension on TextStyle {
  // Color
  TextStyle get primaryFFts => copyWith(color: primaryFF);
  TextStyle get primaryB5ts => copyWith(color: primaryB5);
  TextStyle get primary800ts => copyWith(color: primary800);

  TextStyle get white => copyWith(color: Colors.white);
  TextStyle get neutralWhitets => copyWith(color: neutralWhite);
  TextStyle get transparent => copyWith(color: Colors.transparent);
  TextStyle get grey900ts => copyWith(color: grey900);
  TextStyle get grey800ts => copyWith(color: grey800);
  TextStyle get grey700ts => copyWith(color: grey700);
  TextStyle get grey600ts => copyWith(color: grey600);
  TextStyle get grey61ts => copyWith(color: grey61);
  TextStyle get grey450ts => copyWith(color: grey450);
  TextStyle get grey400ts => copyWith(color: grey400);
  TextStyle get grey300ts => copyWith(color: grey300);
  TextStyle get grey250ts => copyWith(color: grey250);
  TextStyle get grey200ts => copyWith(color: grey200);
  TextStyle get grey100ts => copyWith(color: grey100);
  TextStyle get grey50ts => copyWith(color: grey50);

  TextStyle get blue50ts => copyWith(color: blue50);
  TextStyle get blue100ts => copyWith(color: blue100);
  TextStyle get blue200ts => copyWith(color: blue200);
  TextStyle get blue300ts => copyWith(color: blue300);
  TextStyle get blue400ts => copyWith(color: blue400);
  TextStyle get blue500ts => copyWith(color: blue500);
  TextStyle get blue600ts => copyWith(color: blue600);
  TextStyle get blue700ts => copyWith(color: blue700);
  TextStyle get blue800ts => copyWith(color: blue800);
  TextStyle get blue900ts => copyWith(color: blue900);

  TextStyle get green50ts => copyWith(color: green50);
  TextStyle get green100ts => copyWith(color: green100);
  TextStyle get green200ts => copyWith(color: green200);
  TextStyle get green300ts => copyWith(color: green300);
  TextStyle get green400ts => copyWith(color: green400);
  TextStyle get green500ts => copyWith(color: green500);
  TextStyle get green600ts => copyWith(color: green600);
  TextStyle get green700ts => copyWith(color: green700);
  TextStyle get green800ts => copyWith(color: green800);
  TextStyle get green900ts => copyWith(color: green900);
  TextStyle get greenSwitchts => copyWith(color: greenSwitch);
  TextStyle get greenSolidts => copyWith(color: greenSolid);

  TextStyle get red50ts => copyWith(color: red50);
  TextStyle get red100ts => copyWith(color: red100);
  TextStyle get red200ts => copyWith(color: red200);
  TextStyle get red300ts => copyWith(color: red300);
  TextStyle get red400ts => copyWith(color: red400);
  TextStyle get red500ts => copyWith(color: red500);
  TextStyle get red600ts => copyWith(color: red600);
  TextStyle get red700ts => copyWith(color: red700);
  TextStyle get red800ts => copyWith(color: red800);
  TextStyle get red900ts => copyWith(color: red900);

  TextStyle get yellow50ts => copyWith(color: yellow50);
  TextStyle get yellow100ts => copyWith(color: yellow100);
  TextStyle get yellow200ts => copyWith(color: yellow200);
  TextStyle get yellow300ts => copyWith(color: yellow300);
  TextStyle get yellow400ts => copyWith(color: yellow400);
  TextStyle get yellow500ts => copyWith(color: yellow500);
  TextStyle get yellowG500ts => copyWith(color: yellowGolden);
  TextStyle get yellow600ts => copyWith(color: yellow600);
  TextStyle get yellow700ts => copyWith(color: yellow700);
  TextStyle get yellow800ts => copyWith(color: yellow800);
  TextStyle get yellow900ts => copyWith(color: yellow900);

  TextStyle get s10 => copyWith(fontSize: 10);
  TextStyle get s11 => copyWith(fontSize: 11);
  TextStyle get s12 => copyWith(fontSize: 12);
  TextStyle get s13 => copyWith(fontSize: 13);
  TextStyle get s14 => copyWith(fontSize: 14);
  TextStyle get s16 => copyWith(fontSize: 16);
  TextStyle get s18 => copyWith(fontSize: 18);
  TextStyle get s20 => copyWith(fontSize: 20);
  TextStyle get s24 => copyWith(fontSize: 24);

  // Decoration
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);

  // fontWeight
  TextStyle get w500 => copyWith(fontWeight: FontWeight.w500);
  TextStyle get w600 => copyWith(fontWeight: FontWeight.w600);
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);

  // letterSpacing
  TextStyle get addSpacing => copyWith(letterSpacing: -0.05);
}
