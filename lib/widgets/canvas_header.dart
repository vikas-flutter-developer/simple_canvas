import 'package:flutter/material.dart';

class CanvasHeader extends StatelessWidget {
  const CanvasHeader({
    super.key,
    required this.canUndo,
    required this.onUndo,
    required this.canRedo,
    required this.onRedo,
  });

  final bool canUndo;
  final VoidCallback onUndo;
  final bool canRedo;
  final VoidCallback onRedo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              TextButton(
                onPressed: canUndo ? onUndo : null,
                style: TextButton.styleFrom(
                  foregroundColor: canUndo
                      ? Colors.black87
                      : Theme.of(context).disabledColor,
                ),
                child: const Column(
                  children: [
                    Icon(Icons.undo, size: 20),
                    SizedBox(height: 2),
                    Text("undo", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 24),


              TextButton(
                onPressed: canRedo ? onRedo : null,
                style: TextButton.styleFrom(
                  foregroundColor: canRedo
                      ? Colors.black87
                      : Theme.of(context).disabledColor,
                ),
                child: const Column(
                  children: [
                    Icon(Icons.redo, size: 20),
                    SizedBox(height: 2),
                    Text("redo", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}