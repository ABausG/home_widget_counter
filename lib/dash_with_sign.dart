import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DashWithSign extends StatelessWidget {
  const DashWithSign({Key? key, required this.count}) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox(
        width: 300,
        height: 300,
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Image.asset('assets/dash_sign_small.png'),
                ),
              ),
              Transform.rotate(
                angle: 5 * pi / 180,
                child: Transform.translate(
                  offset: const Offset(58, 29),
                  child: SizedBox(
                    height: 100,
                    width: 134,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Center(
                          child: Text(
                            count.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 70,
                              //color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
