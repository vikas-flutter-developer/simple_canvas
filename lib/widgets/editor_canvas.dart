import 'package:flutter/material.dart';
import 'package:simple_canvas/models/text_item.dart';

class EditorCanvas extends StatelessWidget {
  const EditorCanvas({
    super.key,
    required this.textItems,
    required this.selectedItemId,
    required this.onCanvasTap,
    required this.onItemTapped,
    required this.onItemPanStart,
    required this.onItemPanUpdate,
    required this.onItemPanEnd,
  });

  final List<TextItem> textItems;
  final String? selectedItemId;
  final VoidCallback onCanvasTap;
  final Function(TextItem) onItemTapped;
  final Function(TextItem) onItemPanStart;
  final Function(DragUpdateDetails) onItemPanUpdate;
  final VoidCallback onItemPanEnd;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onCanvasTap,
        child: Container(
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          width: double.infinity,
          child: Stack(
            children: textItems.map((item) {
              return _MovableTextItem(
                key: ValueKey(item.id),
                item: item,
                isSelected: item.id == selectedItemId,
                onTap: () => onItemTapped(item),
                onPanStart: () => onItemPanStart(item),
                onPanUpdate: onItemPanUpdate,
                onPanEnd: onItemPanEnd,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

/// A private widget to handle the gestures for a single text item.
class _MovableTextItem extends StatelessWidget {
  const _MovableTextItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  final TextItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onPanStart;
  final Function(DragUpdateDetails) onPanUpdate;
  final VoidCallback onPanEnd;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: item.position.dx,
      top: item.position.dy,
      child: GestureDetector(
        onTap: onTap,
        onPanStart: (_) => onPanStart(), // Calls the function
        onPanUpdate: onPanUpdate,
        onPanEnd: (_) => onPanEnd(),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: isSelected
                ? Border.all(
                color: Theme.of(context).colorScheme.primary, width: 2)
                : Border.all(color: Colors.transparent, width: 2),
          ),
          child: Text(
            item.text,
            style: item.style,
          ),
        ),
      ),
    );
  }
}