import 'package:flutter/material.dart';
import 'package:sketch_flow/sketch_controller.dart';
import 'package:sketch_flow/sketch_view.dart';

class BaseExamplePage extends StatelessWidget {
  const BaseExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SketchController();

    return Scaffold(
      appBar: SketchTopBar(
          controller: controller,
          onClickBackButton: () => Navigator.pop(context),
      ),
      body: SketchBoard(controller: controller),
      bottomNavigationBar: SketchBottomBar(controller: controller),
    );
  }

}