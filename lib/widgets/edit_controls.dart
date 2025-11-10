import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_canvas/models/text_item.dart';

class EditControls extends StatelessWidget {
  const EditControls({
    super.key,
    required this.setModalState,
    required this.selectedItem,
    required this.fontFamilies,
    required this.onToggleBold,
    required this.onToggleItalic,
    required this.onToggleUnderline,
    required this.onChangeFontSize,
    required this.onChangeFontFamily,
  });

  final StateSetter setModalState;
  final TextItem selectedItem;
  final List<String> fontFamilies;
  final Function(StateSetter) onToggleBold;
  final Function(StateSetter) onToggleItalic;
  final Function(StateSetter) onToggleUnderline;
  final Function(double, StateSetter) onChangeFontSize;
  final Function(String?, StateSetter) onChangeFontFamily;

  @override
  Widget build(BuildContext context) {
    final style = selectedItem.style;
    final bool isBold = style.fontWeight == FontWeight.bold;
    final bool isItalic = style.fontStyle == FontStyle.italic;
    final bool isUnderline = style.decoration == TextDecoration.underline;
    String? currentFontFamily = selectedItem.fontFamilyName;


    final containerDecoration = BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(8),
    );


    const prominentColor = Colors.black87;


    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0)
          .copyWith(
          bottom: 20.0 +
              MediaQuery.of(context)
                  .viewInsets
                  .bottom),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: containerDecoration,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: currentFontFamily,
                  iconEnabledColor: prominentColor,
                  items: fontFamilies.map((font) {
                    return DropdownMenuItem(
                      value: font,
                      child: Text(
                        font,
                        style: GoogleFonts.getFont(font).copyWith(
                          color: prominentColor,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (font) => onChangeFontFamily(font, setModalState),
                ),
              ),
            ),


            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: containerDecoration, // Use new style
              child: Row(
                children: [
                  IconButton(
                      icon: const Icon(Icons.remove, size: 20, color: prominentColor), // Use new color
                      onPressed: () => onChangeFontSize(-1, setModalState)),
                  Text(
                    (style.fontSize ?? 14.0).toStringAsFixed(0),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: prominentColor,
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.add, size: 20, color: prominentColor), // Use new color
                      onPressed: () => onChangeFontSize(1, setModalState)),
                ],
              ),
            ),


            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: containerDecoration,
              child: ToggleButtons(
                isSelected: [isBold, isItalic, isUnderline],
                onPressed: (index) {
                  if (index == 0) onToggleBold(setModalState);
                  if (index == 1) onToggleItalic(setModalState);
                  if (index == 2) onToggleUnderline(setModalState);
                },
                borderRadius: BorderRadius.circular(8),
                selectedColor: Theme.of(context).colorScheme.primary,
                color: prominentColor,
                selectedBorderColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.5),
                fillColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.format_bold, size: 20),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.format_italic, size: 20),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.format_underline, size: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}