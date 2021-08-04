import 'dart:async';

import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(BuildContext context,
    {String? title,
    String? content,
    String rejectBtnText = 'Отмена',
    String continueBtnText = 'Продолжить'}) {
  final responseCompleter = new Completer<bool>();

  Widget cancelButton = TextButton(
    child: Text(rejectBtnText),
    onPressed: () {
      responseCompleter.complete(false);
    },
  );
  Widget continueButton = TextButton(
    child: Text(continueBtnText),
    onPressed: () {
      responseCompleter.complete(true);
    },
  );
  AlertDialog alert = AlertDialog(
    title: title != null ? Text(title) : null,
    content: content != null ? Text(content) : null,
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

  return responseCompleter.future;
}
