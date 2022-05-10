import 'package:flutter/material.dart';

InputDecoration decorationWig({required String label}) {
  return InputDecoration(

    border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
    labelText: label,
  );
}
