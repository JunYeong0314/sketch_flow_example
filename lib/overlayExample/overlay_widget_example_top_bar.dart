import 'package:flutter/material.dart';
import 'package:sketch_flow/sketch_flow.dart';

class OverlayWidgetExampleTopBar extends StatelessWidget
    implements PreferredSizeWidget {
  final SketchController controller;

  const OverlayWidgetExampleTopBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: controller.canUndoNotifier,
                  builder: (context, canUndo, _) {
                    return IconButton(
                      onPressed: canUndo ? () => controller.undo() : null,
                      icon:
                          canUndo
                              ? Icon(Icons.undo)
                              : Icon(Icons.undo, color: Colors.grey),
                    );
                  },
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: controller.canRedoNotifier,
                  builder: (context, canRedo, _) {
                    return IconButton(
                      onPressed: canRedo ? () => controller.redo() : null,
                      icon:
                          canRedo
                              ? Icon(Icons.redo)
                              : Icon(Icons.redo, color: Colors.grey),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
