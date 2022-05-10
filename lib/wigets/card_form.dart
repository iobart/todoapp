import 'dart:io';

import 'package:flutter/material.dart';

class CardForm extends StatelessWidget {
  final Widget child;
  final int? flex;
  final EdgeInsetsGeometry? padding;

  const CardForm({Key? key, required this.child, this.flex, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double paddingBottom = MediaQuery.of(context).padding.bottom;
    return Expanded(
      flex: Platform.isIOS ? 1 : flex ?? 2,
      child: Container(
        padding:
            padding ?? EdgeInsets.fromLTRB(40, 40, 40, (paddingBottom + 20)),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        //alignment: Alignment.,
        child: child,
      ),
    );
  }
}
