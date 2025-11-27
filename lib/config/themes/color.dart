import 'package:flutter/material.dart';

const primary = Color(0xff656BFF);
const primary150 = Color(0xffA8ACFF);
const primary50 = Color(0xffF2F3FF);
const primary800 = Color(0xff33377B);
const primaryFF = Color(0xff656BFF);
const primaryB5 = Color(0xff4B51B5);
const cl5566F5 = Color(0xff5566F5);
const cl82AAFA = Color(0xff82AAFA);
const D6D8FF = Color(0xffD6D8FF);

const white = Colors.white;
const transparent = Colors.transparent;
const whiteDefault = Color(0xFFF5F5F5);
const whiteF9 = Color(0xFFF6F8F9);
const f5f6ff = Color(0xffF5F6FF);
const black = Color(0xff2E2E2E);

const grey50 = Color(0xffFCFCFC);
const grey100 = Color(0xffF6F6F6);
const grey200 = Color(0xffF3F3F3);
const grey250 = Color(0xffE6E6E6);
const grey300 = Color(0xffD8D8D8);
const grey400 = Color(0xffCCCCCC);
const grey450 = Color(0xffB3B3B3);
const grey500 = Color(0xff9B9B9B);
const grey600 = Color(0xff808080);
const grey700 = Color(0xff646464);
const grey800 = Color(0xff4D4D4D);
const grey900 = Color(0xff2E2E2E);

const blue50 = Color(0xffF4F4FE);
const blue100 = Color(0xffD0D2F8);
const blue200 = Color(0xff9398EA);
const blue300 = Color(0xff6268E1);
const blue400 = Color(0xff434BDB);
const blue500 = Color(0xff434BDB);
const blue600 = Color(0xff121BBF);
const blue700 = Color(0xff0E1595);
const blue800 = Color(0xff0B1174);
const blue900 = Color(0xff080D58);
const E8E0FE = Color(0xffE8E0FE);

const green50 = Color(0xffE9F7F0);
const green100 = Color(0xffBAE7D0);
const green200 = Color(0xff98DCB9);
const green300 = Color(0xff69CB98);
const green400 = Color(0xff4CC185);
const green500 = Color(0xff1FB266);
const green600 = Color(0xff1CA25D);
const green700 = Color(0xff167E48);
const green800 = Color(0xff116238);
const green900 = Color(0xff0D4B2B);
const greenSwitch = Color(0xff76EE59);
const green6F = Color(0xff59B16F);
const greenSolid = Color(0xff2A5312);

const red50 = Color(0xffFDEAED);
const red100 = Color(0xffF9BEC7);
const red200 = Color(0xffF69EAC);
const red300 = Color(0xffF27286);
const red400 = Color(0xffEF576F);
const red500 = Color(0xffEB2D4B);
const red600 = Color(0xffD62944);
const red700 = Color(0xffA72035);
const red800 = Color(0xff811929);
const red900 = Color(0xff631320);
const redSolid = Color(0xff670E3D);

const yellow50 = Color(0xffFDF6E6);
const yellow100 = Color(0xffF8E3B0);
const yellow200 = Color(0xffF5D68A);
const yellow300 = Color(0xffF1C355);
const yellow400 = Color(0xffEEB834);
const yellow500 = Color(0xffEAA601);
const yellow600 = Color(0xffD59701);
const yellow700 = Color(0xffA67601);
const yellow800 = Color(0xff815B01);
const yellow900 = Color(0xff624600);
const yellow04 = Color(0xffF6BD04);
const yellowSolid = Color(0xff845A11);

extension RemoveAll on String {
  String removeAll(Iterable<String> values) => values.fold(
      this,
      (
        String result,
        String pattern,
      ) =>
          result.replaceAll(pattern, ''));
}

extension AsHtmlColorToColor on String {
  Color htmlColorToColor() => Color(
        int.parse(
          removeAll(['0x', '#']).padLeft(8, 'ff'),
          radix: 16,
        ),
      );
}
