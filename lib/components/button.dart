import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  final void Function() onTap;
  final String btnName;
  bool? isLogin;
  double? width;
  Buttons(
      {super.key,
      required this.mediaQuery,
      required this.onTap,
      this.isLogin,
      this.width,
      required this.btnName});

  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
              vertical: 13, horizontal: 0)
          .copyWith(
          top: mediaQuery.height * 0.026, bottom: mediaQuery.height * 0.023),
      width: width ?? mediaQuery.width,
      height: mediaQuery.height * 0.058,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF045CA6),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        onPressed: onTap,
        child: isLogin == true
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              )
            : Text(
                btnName,
                style: const TextStyle(
                    fontFamily: 'Sora', color: Colors.white, fontSize: 19),
              ),
      ),
    );
  }
}
