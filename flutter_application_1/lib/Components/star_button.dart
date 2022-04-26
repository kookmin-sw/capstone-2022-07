// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';

IconButton StarButton(BuildContext context) {
  bool isLike = false;

  return IconButton(
    onPressed: () {
      // Navigator.pop(context);
    },
    icon: Icon(isLike == false ? Icons.star_border : Icons.star),
    color: Colors.black,
  );
}
