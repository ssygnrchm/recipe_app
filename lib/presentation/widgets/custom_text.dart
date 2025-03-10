// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String title;
  final TextAlign? textAlign;
  final double? fsize;
  final FontWeight? fweight;
  final Color? fcolor;
  final double? letterSpacing;
  final double? wordSpacing;

  const CustomText({
    super.key,
    required this.title,
    this.textAlign,
    this.fsize = 14,
    this.fweight = FontWeight.normal,
    this.fcolor = Colors.white,
    this.letterSpacing,
    this.wordSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fsize,
        fontWeight: fweight,
        color: fcolor,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
      ),
    );
  }
}
