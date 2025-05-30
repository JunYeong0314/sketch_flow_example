import 'package:flutter/material.dart';
import 'package:sketch_flow/sketch_controller.dart';
import 'package:sketch_flow/sketch_view.dart';
import 'package:sketch_flow_example/baseExample/base_example_page.dart';
import 'package:sketch_flow_example/memoExample/memo_example_page.dart';
import 'package:sketch_flow_example/overlayExample/overlay_widget_example_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SketchFlow example project",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("SketchFlow Example App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 4,
          children: [
            _baseButton(
              context: context,
              routeWidget: BaseExamplePage(),
              text: "Base Example",
            ),
            _baseButton(
              context: context,
              routeWidget: OverlayWidgetExamplePage(
                overlayWidget: Image.asset('assets/images/example.jpg'),
              ),
              text: "Overlay Widget Example",
            ),
            _baseButton(
              context: context,
              routeWidget: MemoExamplePage(),
              text: "Memo Example",
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        color: Colors.deepPurple.withValues(alpha: 0.8),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "[Github]",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SelectableText(
                "https://github.com/Fasoo-DigitalPage/sketch_flow",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "[pub.dev]",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SelectableText(
                "https://pub.dev/packages/sketch_flow",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _baseButton({
    required BuildContext context,
    required Widget routeWidget,
    required String text,
  }) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.deepPurple),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => routeWidget),
        );
      },
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }
}
