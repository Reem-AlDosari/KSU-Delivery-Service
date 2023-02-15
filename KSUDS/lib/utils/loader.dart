import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kcds/resources/resources.dart';

class MyLoader extends StatelessWidget {
  final Color color;

  MyLoader({
    this.color = const Color(0xff78BBD5),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: SpinKitCircle(
          color: R.colors.theme,
        ),
      ),
    );
  }
}
