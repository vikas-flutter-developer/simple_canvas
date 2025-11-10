import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_canvas/helpers/database_helper.dart';
import 'package:simple_canvas/models/text_item.dart';
import 'package:simple_canvas/widgets/canvas_header.dart';
import 'package:simple_canvas/widgets/editor_canvas.dart';
import 'package:simple_canvas/widgets/editor_toolbar.dart'; // Import the new toolbar

class TextEditorScreen extends StatefulWidget {
  const TextEditorScreen({super.key});

  @override
  State<TextEditorScreen> createState() => _TextEditorScreenState();
}

class _TextEditorScreenState extends State<TextEditorScreen> {

  bool _isLoading = true;
  List<TextItem> textItems = [];
  String? selectedItemId;

  List<List<TextItem>> undoStack = [];
  List<List<TextItem>> redoStack = [];

  final List<String> fontFamilies = [
    'Inter',
    'Roboto',
    'Lato',
    'Montserrat',
    'Oswald',
    'Source Code Pro',
  ];


  @override
  void initState() {
    super.initState();
    _loadItemsFromDb();
  }

  Future<void> _loadItemsFromDb() async {
    try {
      final items = await DatabaseHelper.instance.getAllTextItems();
      setState(() {
        textItems = items;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading from DB: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // --- Helper Getters ---
  TextItem? get selectedItem {
    if (selectedItemId == null) return null;
    try {
      return textItems.firstWhere((item) => item.id == selectedItemId);
    } catch (e) {
      return null;
    }
  }

  bool get canUndo => undoStack.isNotEmpty;
  bool get canRedo => redoStack.isNotEmpty;

  // --- State Management (Memory and DB) ---

  List<TextItem> _deepCopy(List<TextItem> list) {
    return list.map((item) => item.copyWith()).toList();
  }

  void _saveStateToMemory() {
    setState(() {
      undoStack.add(_deepCopy(textItems));
      redoStack.clear();
    });
  }

  Future<void> _saveStateToDb() async {
    try {
      await DatabaseHelper.instance.saveAllItems(textItems);
    } catch (e) {
      debugPrint("Error saving to DB: $e");
    }
  }

  void _undo() {
    if (!canUndo) return;
    setState(() {
      redoStack.add(_deepCopy(textItems));
      textItems = undoStack.removeLast();
      selectedItemId = null;
    });
    _saveStateToDb();
  }

  void _redo() {
    if (!canRedo) return;
    setState(() {
      undoStack.add(_deepCopy(textItems));
      textItems = redoStack.removeLast();
      selectedItemId = null;
    });
    _saveStateToDb();
  }



  void _showAddTextDialog() {
    final TextEditingController textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Text"),
          content: TextField(
            controller: textController,
            autofocus: true,
            decoration: const InputDecoration(hintText: "Enter text..."),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Add"),
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  _saveStateToMemory();
                  final String defaultFont = fontFamilies.first;
                  final newItem = TextItem(
                    text: textController.text,
                    position: const Offset(100, 100),
                    fontFamilyName: defaultFont,
                    style: GoogleFonts.getFont(defaultFont,
                        fontSize: 24, color: Colors.black),
                  );

                  setState(() {
                    textItems.add(newItem);
                    selectedItemId = newItem.id;
                  });
                  _saveStateToDb();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }



  void _deleteSelectedItem() {
    if (selectedItem == null) return;
    _saveStateToMemory();
    setState(() {
      textItems.removeWhere((item) => item.id == selectedItemId);
      selectedItemId = null;
    });
    _saveStateToDb();
  }



  void _toggleBold() {
    if (selectedItem == null) return;
    _saveStateToMemory();
    setState(() {
      selectedItem!.style = selectedItem!.style.copyWith(
        fontWeight: selectedItem!.style.fontWeight == FontWeight.bold
            ? FontWeight.normal
            : FontWeight.bold,
      );
    });
    _saveStateToDb();
  }

  void _toggleItalic() {
    if (selectedItem == null) return;
    _saveStateToMemory();
    setState(() {
      selectedItem!.style = selectedItem!.style.copyWith(
        fontStyle: selectedItem!.style.fontStyle == FontStyle.italic
            ? FontStyle.normal
            : FontStyle.italic,
      );
    });
    _saveStateToDb();
  }

  void _toggleUnderline() {
    if (selectedItem == null) return;
    _saveStateToMemory();
    setState(() {
      selectedItem!.style = selectedItem!.style.copyWith(
        decoration: selectedItem!.style.decoration == TextDecoration.underline
            ? TextDecoration.none
            : TextDecoration.underline,
        decorationColor: selectedItem!.style.color ?? Colors.black,
        decorationThickness: 2,
      );
    });
    _saveStateToDb();
  }

  /// For the +/- buttons
  void _changeFontSize(double delta) {
    if (selectedItem == null) return;
    _saveStateToMemory();
    setState(() {
      double newSize = (selectedItem!.style.fontSize ?? 14.0) + delta;
      selectedItem!.style = selectedItem!.style.copyWith(
        fontSize: newSize.clamp(8.0, 100.0),
      );
    });
    _saveStateToDb();
  }


  void _setFontSize(double newSize) {
    if (selectedItem == null) return;
    _saveStateToMemory();
    setState(() {
      selectedItem!.style = selectedItem!.style.copyWith(
        fontSize: newSize.clamp(8.0, 100.0),
      );
    });
    _saveStateToDb();
  }

  void _changeFontFamily(String? fontFamily) {
    if (selectedItem == null || fontFamily == null) return;
    _saveStateToMemory();
    setState(() {
      selectedItem!.fontFamilyName = fontFamily;
      selectedItem!.style = GoogleFonts.getFont(
        fontFamily,
        fontSize: selectedItem!.style.fontSize,
        fontWeight: selectedItem!.style.fontWeight,
        fontStyle: selectedItem!.style.fontStyle,
        decoration: selectedItem!.style.decoration,
        color: selectedItem!.style.color,
        decorationColor: selectedItem!.style.decorationColor,
        decorationThickness: selectedItem!.style.decorationThickness,
      );
    });
    _saveStateToDb();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            CanvasHeader(
              canUndo: canUndo,
              onUndo: _undo,
              canRedo: canRedo,
              onRedo: _redo,
            ),
            _isLoading
                ? const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )

                : EditorCanvas(
              textItems: textItems,
              selectedItemId: selectedItemId,
              onCanvasTap: () {
                setState(() {
                  selectedItemId = null;
                });
              },
              onItemTapped: (item) {
                setState(() {
                  selectedItemId = item.id;
                });
              },
              onItemPanStart: (item) {
                _saveStateToMemory();
                setState(() {
                  selectedItemId = item.id;
                });
              },
              onItemPanUpdate: (details) {
                if (selectedItem == null) return;
                setState(() {
                  selectedItem!.position = Offset(
                    selectedItem!.position.dx + details.delta.dx,
                    selectedItem!.position.dy + details.delta.dy,
                  );
                });
              },
              onItemPanEnd: () {
                _saveStateToDb();
              },
            ),

            EditorToolbar(
              selectedItem: selectedItem,
              fontFamilies: fontFamilies,
              onAddText: _showAddTextDialog,
              onToggleBold: _toggleBold,
              onToggleItalic: _toggleItalic,
              onToggleUnderline: _toggleUnderline,
              onChangeFontSize: _changeFontSize,
              onSetFontSize: _setFontSize,
              onChangeFontFamily: _changeFontFamily,
              onDeleteItem: _deleteSelectedItem,
            ),
          ],
        ),
      ),
    );
  }
}