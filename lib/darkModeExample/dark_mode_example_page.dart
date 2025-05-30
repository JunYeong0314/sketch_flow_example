import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sketch_flow/sketch_controller.dart';
import 'package:sketch_flow/sketch_model.dart';
import 'package:sketch_flow/sketch_view.dart';

class DarkModeExamplePage extends StatefulWidget {
  const DarkModeExamplePage({super.key});

  @override
  State<DarkModeExamplePage> createState() => _DarkModeExamplePageState();
}

class _DarkModeExamplePageState extends State<DarkModeExamplePage> {
  late final SystemUiOverlayStyle _previousStyle;

  @override
  void initState() {
    super.initState();
    _previousStyle = SystemUiOverlayStyle.dark;

    // 다크 테마 적용
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(_previousStyle);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = SketchController(
      sketchConfig: SketchConfig(
        pencilConfig: SketchToolConfig(color: Colors.white),
        brushConfig: SketchToolConfig(
          color: Colors.white,
          strokeThickness: 5.0,
          strokeThicknessList: [5.0, 7.5, 10.0, 12.5, 15.0],
        ),
        lineConfig: SketchToolConfig(color: Colors.white),
        rectangleConfig: SketchToolConfig(color: Colors.white),
        circleConfig: SketchToolConfig(color: Colors.white),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: SketchTopBar(
        controller: controller,
        onClickBackButton: () => Navigator.pop(context),
        systemUiOverlayStyle: _previousStyle,
        topBarColor: Colors.black,
        backButtonIcon: Icon(Icons.arrow_back_ios, color: Colors.white),
        undoIcon: SketchToolIcon(
          enableIcon: Icon(Icons.undo, color: Colors.white),
          disableIcon: Icon(Icons.undo, color: Colors.grey),
        ),
        redoIcon: SketchToolIcon(
          enableIcon: Icon(Icons.redo, color: Colors.white),
          disableIcon: Icon(Icons.redo, color: Colors.grey),
        ),
      ),
      body: SketchBoard(controller: controller, boardColor: Colors.black),
      bottomNavigationBar: SketchBottomBar(
        controller: controller,
        bottomBarColor: Colors.black,
        overlayBackgroundColor: Colors.black,
        eraserThicknessSliderThemeData: SliderTheme.of(context).copyWith(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 25),
          activeTrackColor: Colors.white,
          inactiveTrackColor: Colors.white.withAlpha(15),
          inactiveTickMarkColor: Colors.white,
          thumbColor: Colors.white,
          overlayColor: Colors.white.withValues(alpha: 0.05),
          secondaryActiveTrackColor: Colors.white,
          trackHeight: 4,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
        ),
        eraserRadioButtonColor: Colors.white,
        eraserThicknessTextStyle: TextStyle(color: Colors.white),
        areaEraserText: Text(
          "Area Eraser",
          style: TextStyle(color: Colors.white),
        ),
        strokeEraserText: Text(
          "Stroke Eraser",
          style: TextStyle(color: Colors.white),
        ),
        overlayStrokeThicknessSelectColor: Colors.black,
      ),
    );
  }
}
