import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sketch_flow_example/common/base_top_bar.dart';
import 'drawing_memo_create_page.dart';
import 'drawing_memo_detail_page.dart';
import 'drawing_memo_repository.dart';

class DrawingMemoExamplePage extends StatelessWidget {
  const DrawingMemoExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BaseTopBar(
        title: "Memo Example Page",
        onTap: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: DrawingMemoRepository.instance.memoListNotifier,
          builder: (context, memoList, child) {
            return Stack(
              fit: StackFit.expand,
              children: [
                memoList.isEmpty
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.pencil_outline, color: Colors.grey),
                        Text(
                          "Please add a note!",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                    : Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: memoList.length,
                        itemBuilder: (context, index) {
                          return _memoListCard(
                            memo: memoList[index],
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => DrawingMemoDetailPage(
                                          sketchMemoIndex: index,
                                          sketchMemo: memoList[index],
                                        ),
                                  ),
                                ),
                          );
                        },
                      ),
                    ),
                Positioned(
                  bottom: 36,
                  right: 18,
                  child: ElevatedButton(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DrawingMemoCreatePage(),
                          ),
                        ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(60, 60),
                      shape: const CircleBorder(),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: Icon(Icons.edit, size: 28),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _memoListCard({required SketchMemo memo, required Function() onTap}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Expanded(child: memo.thumbnail),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(memo.date, style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
