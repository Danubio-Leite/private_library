import 'package:flutter/material.dart';

void customDialogBox(BuildContext context, String title, book, Widget content,
    List<Widget> actions) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: content,
        actions: actions,
      );
    },
  );
}
