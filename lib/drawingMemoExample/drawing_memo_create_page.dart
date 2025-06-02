import 'package:flutter/material.dart';
import 'package:sketch_flow/sketch_flow.dart';
import 'package:sketch_flow_example/drawingMemoExample/drawing_memo_top_bar.dart';
import 'drawing_memo_repository.dart';

class DrawingMemoCreatePage extends StatefulWidget {
  const DrawingMemoCreatePage({super.key});

  @override
  State<DrawingMemoCreatePage> createState() => _DrawingMemoCreatePageState();
}

class _DrawingMemoCreatePageState extends State<DrawingMemoCreatePage> {
  late final SketchController controller;
  final GlobalKey repaintKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = SketchController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DrawingMemoTopBar(
        controller: controller,
        onClickCompleted: () async {
          final image = await controller.extractPNG(repaintKey: repaintKey);
          final json = controller.toJson();

          if (!mounted) return;

          if (image != null && controller.contents.isNotEmpty) {
            final memo = SketchMemo(
              date: DateTime.now().toIso8601String().substring(0, 10),
              thumbnail: Image.memory(image),
              json: json,
            );

            DrawingMemoRepository.instance.addMemo(memo: memo);
            Navigator.pop(this.context);
          }
        },
      ),
      body: SketchBoard(controller: controller, repaintKey: repaintKey),
      bottomNavigationBar: SketchBottomBar(controller: controller),
    );
  }
}
