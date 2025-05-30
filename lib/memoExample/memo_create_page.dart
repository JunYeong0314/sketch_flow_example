import 'package:flutter/material.dart';
import 'package:sketch_flow/sketch_controller.dart';
import 'package:sketch_flow/sketch_view.dart';
import 'package:sketch_flow_example/memoExample/memo_top_bar.dart';
import 'memo_repository.dart';

class MemoCreatePage extends StatefulWidget {
  const MemoCreatePage({super.key});

  @override
  State<MemoCreatePage> createState() => _MemoCreatePageState();
}

class _MemoCreatePageState extends State<MemoCreatePage> {
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
      appBar: MemoTopBar(
        controller: controller,
        onClickCompleted: () async {
          final image = await controller.extractPNG(repaintKey: repaintKey);
          final json = controller.toJson();

          if (!mounted) return;

          if (image != null && controller.contents.isNotEmpty) {
            final memo = SketchMemo(
                date: DateTime.now().toIso8601String().substring(0, 10),
                thumbnail: Image.memory(image),
                json: json
            );

            MemoRepository.instance.addMemo(memo: memo);
            Navigator.pop(this.context);
          }
        },
      ),
      body: SketchBoard(
        controller: controller,
        repaintKey: repaintKey,
      ),
      bottomNavigationBar: SketchBottomBar(controller: controller),
    );
  }
}
