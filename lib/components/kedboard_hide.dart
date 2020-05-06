import 'package:flutter/material.dart';

class KeyboardHide extends StatelessWidget {
  final Widget child;
  KeyboardHide({this.child});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,
      onTap: () {
        FocusScopeNode node = FocusScope.of(context);
        if (!node.hasPrimaryFocus) {
          node.unfocus();
        }
      },
    );
  }
}
