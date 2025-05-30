import 'package:flutter/material.dart';
import 'package:sketch_flow/sketch_controller.dart';
import 'package:sketch_flow/sketch_model.dart';
import 'package:sketch_flow/sketch_view.dart';
import 'package:sketch_flow_example/common/base_top_bar.dart';
import 'package:sketch_flow_example/memoExample/memo_top_bar.dart';
import 'memo_repository.dart';

class MemoDetailPage extends StatefulWidget {
  const MemoDetailPage({
    super.key,
    required this.sketchMemo,
    required this.sketchMemoIndex,
  });

  final SketchMemo sketchMemo;
  final int sketchMemoIndex;

  @override
  State<MemoDetailPage> createState() => _MemoDetailPageState();
}

class _MemoDetailPageState extends State<MemoDetailPage>
    with TickerProviderStateMixin {
  late final SketchController _controller;

  late AnimationController _bottomBarAnimationController;
  late Animation<Offset> _bottomBarAnimation;

  bool _isEditing = false;
  final _repaintKey = GlobalKey();

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _controller.updateConfig(toolType: SketchToolType.pencil);
        _bottomBarAnimationController.forward();
      } else {
        _bottomBarAnimationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _bottomBarAnimationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = SketchController();
    _controller.updateConfig(toolType: SketchToolType.move);
    _controller.fromJson(json: widget.sketchMemo.json);

    _bottomBarAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _bottomBarAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _bottomBarAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          _isEditing
              ? MemoTopBar(
                controller: _controller,
                onClickCompleted: () async {
                  final json = _controller.toJson();
                  final image = await _controller.extractPNG(
                    repaintKey: _repaintKey,
                  );

                  if (image != null) {
                    MemoRepository.instance.updateMemo(
                      index: widget.sketchMemoIndex,
                      updateMemo: SketchMemo(
                        thumbnail: Image.memory(image),
                        json: json,
                        date: DateTime.now().toString().substring(0, 10),
                      ),
                    );

                    _toggleEditing();
                  }
                },
              )
              : BaseTopBar(
                title: widget.sketchMemo.date,
                onTap: () => Navigator.pop(context),
              ),
      body: Stack(
        children: [
          SketchBoard(repaintKey: _repaintKey, controller: _controller),
          Visibility(
            visible: !_isEditing,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: ElevatedButton.icon(
                  onPressed: () => _toggleEditing(),
                  icon: Icon(Icons.edit, color: Colors.white),
                  label: Text(
                    "Edit",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.withAlpha(128),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SlideTransition(
        position: _bottomBarAnimation,
        child: SketchBottomBar(controller: _controller),
      ),
    );
  }
}
