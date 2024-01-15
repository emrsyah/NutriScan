import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

Color primary = HexColor('#25A35F');
Color secondary = HexColor('#C4F4DA');
Color black = HexColor('#393939');
Color gray = HexColor('#8E9195');
Color graySecond = HexColor('#CCD1D6');

BoxShadow softDrop = BoxShadow(
  color: Colors.grey.withOpacity(0.14),
  spreadRadius: 0,
  blurRadius: 4,
  offset: Offset(0, 1),
);

Border softBorder = Border.all(color: Colors.black12, width: 0.4);
