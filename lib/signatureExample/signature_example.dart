import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sketch_flow/sketch_flow.dart';
import 'package:sketch_flow_example/common/base_top_bar.dart';

class SignatureExample extends StatefulWidget {
  const SignatureExample({super.key});

  @override
  State<SignatureExample> createState() => _SignatureExampleState();
}

class _SignatureExampleState extends State<SignatureExample> {
  late SketchController _controller;
  late List<Color> _colorList;

  int _selectColorIdx = 0;
  bool _isEditing = true;
  List<Map<String, dynamic>> _lastData = [];

  @override
  void initState() {
    super.initState();

    _controller = SketchController();
    _controller.updateConfig(lastUsedStrokeThickness: 4.0, lastUsedColor: Colors.black);

    _colorList = [Colors.black, Colors.red, Colors.blue];
  }

  void _handleSignature({required List<Map<String, dynamic>> json}) {
    if (_isEditing) {
      _lastData = json;
    } else {
      _controller.fromJson(json: _lastData);
    }

    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BaseTopBar(
        title: 'Signature Example',
        onTap: () => Navigator.pop(context),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Signature",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
            textAlign: TextAlign.end,
          ),
          SizedBox(height: 10),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Stack(
                  children: [
                    SizedBox.expand(
                      child: SketchBoard(
                        controller: _controller,
                        boardColor: Color(0xFFEDEDED),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 60,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 28),
                        color: Colors.black,
                        height: 0.5,
                      ),
                    ),
                    Visibility(
                        visible: _isEditing,
                        child: Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            color: Color(0xFFEDEDED),
                            child: Row(
                              spacing: 4,
                              children: List.generate(_colorList.length, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    _controller.updateConfig(
                                      lastUsedColor: _colorList[index],
                                    );
                                    setState(() {
                                      _selectColorIdx = index;
                                    });
                                  },
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _selectColorIdx == index ? _colorList[index] : _colorList[index].withValues(alpha: 0.4),
                                      border: Border.all(
                                        color: Colors.grey.withValues(alpha: 0.4),
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        )
                    ),
                    Visibility(
                        visible: _isEditing,
                        child: Positioned(
                            top: 0,
                            left: 0,
                            child: IconButton(
                                onPressed: () {
                                  _controller.clear();
                                  _lastData = [];
                                },
                                icon: Icon(CupertinoIcons.clear, size: 16, color: Colors.grey.withValues(alpha: 0.7),)
                            )
                        )
                    ),
                    Positioned(
                        bottom: 6,
                        right: 6,
                        child: IconButton(
                            icon: _isEditing ? Icon(Icons.check) : Icon(CupertinoIcons.pen),
                            onPressed: () {
                              _handleSignature(json: _controller.toJson());
                            },
                        )
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
