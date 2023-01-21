import 'package:flutter/material.dart';
import 'package:marketdo_flutter/home.dart';
import 'package:marketdo_flutter/widgets/colors.dart';

Widget errorDialog(String message, BuildContext context) {
  return AlertDialog(
    scrollable: true,
    title: Text(
      'ERROR',
      style: TextStyle(color: darkred),
    ),
    content: Text(message),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('OK', style: TextStyle(color: darkblue)),
      )
    ],
  );
}

Widget successDialog(String message, BuildContext context) {
  return AlertDialog(
    scrollable: true,
    title: Text(
      'SUCCESS',
      style: TextStyle(color: darkgreen),
    ),
    content: Text(message),
    actions: [
      TextButton(
        onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false),
        child: Text('OK', style: TextStyle(color: darkblue)),
      ),
    ],
  );
}
