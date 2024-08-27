import 'package:flutter/material.dart';

class GridCardModel {
  String icon;
  String title;
  Widget screeToNavigate;
  String? apiTocall;

  GridCardModel(
      {required this.icon,
      required this.title,
      required this.screeToNavigate,
      this.apiTocall});
}
