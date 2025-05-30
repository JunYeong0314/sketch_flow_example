import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseTopBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseTopBar({super.key, required this.title, required this.onTap});

  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 16, 0, 0),
        child: InkWell(
          onTap: () => onTap(),
          child: Row(
            children: [
              Icon(Icons.arrow_back_ios),
              Text(title, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
