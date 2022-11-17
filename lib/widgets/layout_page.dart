import 'package:flutter/material.dart';
import 'package:tto/constant/color.dart';

class LayoutPage extends StatelessWidget {
  LayoutPage({
    super.key,
    this.child,
  });

  Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      // resizeToAvoidBottomInset: false,
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: child,
        ),
      ),
    );
  }
}
