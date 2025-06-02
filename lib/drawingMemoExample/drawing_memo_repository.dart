import 'package:flutter/cupertino.dart';

class SketchMemo {
  final Widget thumbnail;
  final List<Map<String, dynamic>> json;
  final String date;

  SketchMemo({required this.thumbnail, required this.json, required this.date});
}

class DrawingMemoRepository {
  DrawingMemoRepository._privateConstructor();

  static final DrawingMemoRepository _instance = DrawingMemoRepository._privateConstructor();

  static DrawingMemoRepository get instance => _instance;

  final ValueNotifier<List<SketchMemo>> _memoListNotifier = ValueNotifier([]);

  List<SketchMemo> get memoList => List.unmodifiable(_memoListNotifier.value);

  ValueNotifier<List<SketchMemo>> get memoListNotifier => _memoListNotifier;

  void addMemo({required SketchMemo memo}) {
    _memoListNotifier.value = List.from(_memoListNotifier.value)..add(memo);
  }

  void removeMemo({required int index}) {
    final newList = List<SketchMemo>.from(_memoListNotifier.value);
    if (index >= 0 && index < newList.length) {
      newList.removeAt(index);
      _memoListNotifier.value = newList;
    }
  }

  void updateMemo({required int index, required SketchMemo updateMemo}) {
    final newList = List<SketchMemo>.from(_memoListNotifier.value);

    if (index >= 0 && index < newList.length) {
      newList[index] = updateMemo;
      _memoListNotifier.value = newList;
    }
  }

  void setMemoList({required List<SketchMemo> newMemoList}) {
    _memoListNotifier.value = List.from(newMemoList);
  }
}
