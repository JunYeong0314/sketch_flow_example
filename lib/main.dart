import 'package:flutter/material.dart';
import 'package:sketch_flow/sketch_controller.dart';
import 'package:sketch_flow/sketch_view.dart';
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("SketchFlow example project"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.deepPurple),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => OverlayWidgetExamplePage(
                          overlayWidget: Image.asset(
                            'assets/images/example.jpg',
                          ),
                        ),
                  ),
                );
              },
              child: Text(
                "Overlay Widget Example",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
