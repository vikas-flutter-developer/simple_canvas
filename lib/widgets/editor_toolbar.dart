import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_canvas/models/text_item.dart';

class EditorToolbar extends StatefulWidget {
  const EditorToolbar({
    super.key,
    required this.selectedItem,
    required this.fontFamilies,
    required this.onAddText,
    required this.onToggleBold,
    required this.onToggleItalic,
    required this.onToggleUnderline,
    required this.onChangeFontSize,
    required this.onSetFontSize,
    required this.onChangeFontFamily,
    required this.onDeleteItem,
  });

  final TextItem? selectedItem;
  final List<String> fontFamilies;
  final VoidCallback onAddText;
  final VoidCallback onToggleBold;
  final VoidCallback onToggleItalic;
  final VoidCallback onToggleUnderline;
  final Function(double) onChangeFontSize;
  final Function(double) onSetFontSize;
  final Function(String?) onChangeFontFamily;
  final VoidCallback onDeleteItem;

  @override
  State<EditorToolbar> createState() => _EditorToolbarState();
}

class _EditorToolbarState extends State<EditorToolbar> {
  late TextEditingController _sizeController;

  @override
  void initState() {
    super.initState();
    _sizeController = TextEditingController(text: _getFontSize());
  }

  @override
  void dispose() {
    _sizeController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant EditorToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItem != oldWidget.selectedItem) {
      _sizeController.text = _getFontSize();
      _sizeController.selection = TextSelection.fromPosition(
        TextPosition(offset: _sizeController.text.length),
      );
    }
  }

  String _getFontSize() {
    return widget.selectedItem?.style.fontSize?.toStringAsFixed(0) ?? '14';
  }

  void _onSizeSubmitted(String value) {
    final newSize = double.tryParse(value);
    if (newSize != null) {
      widget.onSetFontSize(newSize);
    } else {
      _sizeController.text = _getFontSize();
    }
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return widget.selectedItem == null
        ? _buildAddTextToolbar(context)
        : _buildEditToolbar(context);
  }

  Widget _buildAddTextToolbar(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0)
          .copyWith(bottom: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilledButton.icon(
            icon: const Icon(Icons.title),
            label: const Text("Add text"),
            style: FilledButton.styleFrom(
              padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: widget.onAddText,
          ),
        ],
      ),
    );
  }

  Widget _buildEditToolbar(BuildContext context) {
    if (widget.selectedItem == null) return const SizedBox.shrink();

    final style = widget.selectedItem!.style;
    final bool isBold = style.fontWeight == FontWeight.bold;
    final bool isItalic = style.fontStyle == FontStyle.italic;
    final bool isUnderline = style.decoration == TextDecoration.underline;
    String? currentFontFamily = widget.selectedItem!.fontFamilyName;

    final containerDecoration = BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(8),
    );
    const prominentColor = Colors.black87;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0)
          .copyWith(bottom: 20.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Font Family Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: containerDecoration,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: currentFontFamily,
                  iconEnabledColor: prominentColor,
                  items: widget.fontFamilies.map((font) {
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
                  onChanged: widget.onChangeFontFamily,
                ),
              ),
            ),

            // Font Size Controls
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: containerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      icon: const Icon(Icons.remove, size: 20, color: prominentColor),
                      onPressed: () {
                        widget.onChangeFontSize(-1);
                        _sizeController.text = _getFontSize();
                      }),
                  SizedBox(
                    width: 40,
                    child: TextField(
                      controller: _sizeController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: prominentColor,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: _onSizeSubmitted,
                      onTapOutside: (_) => _onSizeSubmitted(_sizeController.text),
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.add, size: 20, color: prominentColor),
                      onPressed: () {
                        widget.onChangeFontSize(1);
                        _sizeController.text = _getFontSize();
                      }),
                ],
              ),
            ),

            // Style Toggles
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: containerDecoration,
              child: ToggleButtons(
                isSelected: [isBold, isItalic, isUnderline],
                onPressed: (index) {
                  if (index == 0) widget.onToggleBold();
                  if (index == 1) widget.onToggleItalic();
                  if (index == 2) widget.onToggleUnderline();
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


            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: containerDecoration,
              child: IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                color: Colors.red[700], // Make it red
                tooltip: "Delete",
                onPressed: widget.onDeleteItem, // Use the new callback
              ),
            ),
            // --- END NEW ---
          ],
        ),
      ),
    );
  }
}