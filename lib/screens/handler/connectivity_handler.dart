import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:pixel_test/provider/connectivity_provider.dart';
import 'package:provider/provider.dart';


class ConnectivityHandler extends StatelessWidget {
  final Widget child;

  const ConnectivityHandler({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          child,
          Consumer<ConnectivityProvider>(
            builder: (context, provider, child) {
              if (provider.connectionStatus == ConnectivityResult.none) {
                return SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: MaterialBanner(
                      content: const Text(
                        'No internet connection',
                        style: TextStyle(
                            fontFamily: 'Poppins', color: Colors.white),
                      ),
                      leading: const Icon(
                        Icons.wifi_off,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.redAccent,
                      actions: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'DISMISS',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Poppins'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
