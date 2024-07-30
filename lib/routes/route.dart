import 'package:flutter/material.dart';

Route createRoute(Widget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}
