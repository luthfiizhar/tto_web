import 'package:flutter/material.dart';
import 'package:tto/widgets/layout_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutPage(
      child: Center(
        child: Text('Welcome'),
      ),
    );
  }
}
