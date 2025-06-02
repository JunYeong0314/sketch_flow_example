import 'package:flutter/material.dart';
import 'package:sketch_flow/sketch_flow.dart';

class DrawingMemoTopBar extends StatelessWidget implements PreferredSizeWidget {
  const DrawingMemoTopBar({
    super.key,
    required this.controller,
    required this.onClickCompleted,
  });

  final SketchController controller;
  final Function() onClickCompleted;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios),
            ),
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
                IconButton(
                  onPressed: () => onClickCompleted(),
                  icon: Icon(Icons.check),
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
