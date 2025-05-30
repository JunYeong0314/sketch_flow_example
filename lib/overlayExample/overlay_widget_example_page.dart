import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sketch_flow/sketch_controller.dart';
import 'package:sketch_flow/sketch_model.dart';
import 'package:sketch_flow/sketch_view.dart';
import 'package:sketch_flow_example/common/base_top_bar.dart';
import 'package:sketch_flow_example/overlayExample/overlay_widget_example_top_bar.dart';

class OverlayWidgetExamplePage extends StatefulWidget {
  const OverlayWidgetExamplePage({super.key, required this.overlayWidget});

  final Widget overlayWidget;

  @override
  State<StatefulWidget> createState() => _OverlayWidgetExamplePageState();
}

class _OverlayWidgetExamplePageState extends State<OverlayWidgetExamplePage>
    with TickerProviderStateMixin {
  bool _isEditing = false;

  late AnimationController _bottomBarAnimationController;
  late Animation<Offset> _bottomBarAnimation;

  late final SketchController _controller;
  late Widget _overlayWidget;
  late final GlobalKey _repaintKey;
  late List<Color> _colorList;

  @override
  void initState() {
    super.initState();

    /// 기본 도구를 Brush로 설정
    /// Brush Config 초기 값 설정
    _controller = SketchController(
      sketchConfig: SketchConfig(
        toolType: SketchToolType.brush,
        brushConfig: SketchToolConfig(strokeThickness: 8),
      ),
    );
    _overlayWidget = widget.overlayWidget;
    _repaintKey = GlobalKey();
    _colorList = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.white,
      Colors.black,
    ];

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
  void dispose() {
    _bottomBarAnimationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _bottomBarAnimationController.forward();
      } else {
        _bottomBarAnimationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          _isEditing
              ? OverlayWidgetExampleTopBar(controller: _controller)
              : BaseTopBar(
                title: "Overlay Widget Example",
                onTap: () => Navigator.pop(context),
              ),
      body: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Stack(
            children: [
              Center(
                child:
                _isEditing
                    ? SketchBoard(
                  repaintKey: _repaintKey,
                  controller: _controller,
                  boardHeightSize: MediaQuery.of(context).size.height * 0.8,
                  boardWidthSize: MediaQuery.of(context).size.width * 0.95,
                  overlayWidget: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: _overlayWidget,
                  ),
                )
                    : _overlayWidget,
              ),
              Visibility(
                visible: !_isEditing,
                child: Positioned(
                  bottom: 0,
                  right: 8,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(60, 60),
                      shape: const CircleBorder(),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: _toggleEditing,
                    child: Icon(Icons.draw, size: 24),
                  ),
                ),
              ),
            ],
          ),
      ),
      bottomNavigationBar: SizedBox(
        height: 90,
        child: SlideTransition(
          position: _bottomBarAnimation,
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 6,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_colorList.length, (index) {
                    return GestureDetector(
                      onTap:
                          () => _controller.updateConfig(
                            lastUsedColor: _colorList[index],
                          ),
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _colorList[index],
                          border: Border.all(color: Colors.grey, width: 0.5),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              _customBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customBottomBar() {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed:
                () =>
                _controller.updateConfig(toolType: SketchToolType.brush),
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed:
                () =>
                _controller.updateConfig(toolType: SketchToolType.eraser),
            icon: Icon(CupertinoIcons.bandage_fill),
          ),
          IconButton(
            onPressed: () => _controller.clear(),
            icon: Icon(CupertinoIcons.trash),
          ),
          IconButton(
            onPressed: () async {
              /// 변경사항이 존재 할 때만 png 추출
              if (_controller.contents.isNotEmpty) {
                final image = await _controller.extractPNG(
                  repaintKey: _repaintKey,
                );

                if (image != null) {
                  _overlayWidget = Image.memory(image);
                  _toggleEditing();
                }
              } else {
                _toggleEditing();
              }
            },
            icon: Icon(Icons.check_circle_outline_rounded, size: 28),
          ),
        ],
      ),
    );
  }
}
