  import 'dart:io';

import 'package:flutter/material.dart';

showCloseDialog(BuildContext context,
      {required String swipeDirection}) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: swipeDirection == 'left' ? Offset(-1, 0) : Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: Curves.easeInOut,
          )),
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            title: const Text(
              "Are you sure you want to exit?",
              style: TextStyle(
                fontFamily: 'Sora',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => exit(0),
                child: const Text(
                  "Confirm",
                  style: TextStyle(
                      color: Color(0xFF196889), fontFamily: 'Sora'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel",
                    style: TextStyle(
                        color: Color(0xFF196889), fontFamily: 'Sora')),
              ),
            ],
          ),
        );
      },
    );
  }