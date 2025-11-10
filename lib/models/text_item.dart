import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class TextItemFields {
  static const String id = 'id';
  static const String text = 'text';
  static const String positionDx = 'positionDx';
  static const String positionDy = 'positionDy';
  static const String fontSize = 'fontSize';
  static const String fontFamily = 'fontFamily';
  static const String isBold = 'isBold';
  static const String isItalic = 'isItalic';
  static const String isUnderline = 'isUnderline';
  static const String colorValue = 'colorValue';
}


class TextItem {
  String id;
  String text;
  Offset position;
  TextStyle style;
  String fontFamilyName;

  TextItem({
    required this.text,
    required this.position,
    required this.style,
    required this.fontFamilyName,
    String? id,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();


  TextItem copyWith({
    String? id,
    String? text,
    Offset? position,
    TextStyle? style,
    String? fontFamilyName,
  }) {
    return TextItem(
      id: id ?? this.id,
      text: text ?? this.text,
      position: position ?? this.position,
      style: style ?? this.style,
      fontFamilyName: fontFamilyName ?? this.fontFamilyName,
    );
  }


  bool isEqual(TextItem other) {
    return text == other.text &&
        position == other.position &&
        style == other.style &&
        id == other.id &&
        fontFamilyName == other.fontFamilyName;
  }


  Map<String, dynamic> toMap() {
    return {
      TextItemFields.id: id,
      TextItemFields.text: text,
      TextItemFields.positionDx: position.dx,
      TextItemFields.positionDy: position.dy,
      TextItemFields.fontSize: style.fontSize ?? 14.0,
      TextItemFields.fontFamily: fontFamilyName,
      TextItemFields.isBold: style.fontWeight == FontWeight.bold ? 1 : 0,
      TextItemFields.isItalic: style.fontStyle == FontStyle.italic ? 1 : 0,
      TextItemFields.isUnderline:
      style.decoration == TextDecoration.underline ? 1 : 0,
      TextItemFields.colorValue: style.color?.value ?? Colors.black.value,
    };
  }


  factory TextItem.fromMap(Map<String, dynamic> map) {
    final String fontFamily = map[TextItemFields.fontFamily];
    final Color color = Color(map[TextItemFields.colorValue]);

    return TextItem(
      id: map[TextItemFields.id],
      text: map[TextItemFields.text],
      position: Offset(
        map[TextItemFields.positionDx],
        map[TextItemFields.positionDy],
      ),
      fontFamilyName: fontFamily,
      style: GoogleFonts.getFont(
        fontFamily,
        fontSize: map[TextItemFields.fontSize],
        color: color,
        fontWeight:
        map[TextItemFields.isBold] == 1 ? FontWeight.bold : FontWeight.normal,
        fontStyle: map[TextItemFields.isItalic] == 1
            ? FontStyle.italic
            : FontStyle.normal,
        decoration: map[TextItemFields.isUnderline] == 1
            ? TextDecoration.underline
            : TextDecoration.none,
        decorationColor: color,
        decorationThickness: 2,
      ),
    );
  }
}