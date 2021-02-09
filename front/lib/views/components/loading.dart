import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final double size;

  Loading({this.size = 50.0});

  @override
  Widget build(BuildContext context) {
    return SpinKitRotatingCircle(
      color: Theme.of(context).primaryColor,
      size: this.size,
    );
  }
}
