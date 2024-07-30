import 'package:flutter/material.dart';
import 'package:pixel_test/routes/route.dart';
import 'package:pixel_test/screens/customer_list_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeIn,
    );

    _controller?.forward();

    Future.delayed(const Duration(seconds: 4), () {
      Navigator.push(context, createRoute(const CustomerListScreen()));
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _animation!,
          child: ScaleTransition(
            scale: _animation!,
            child: Image.asset('images/Pixel6_logo.png'),
          ),
        ),
      ),
    );
  }
}
