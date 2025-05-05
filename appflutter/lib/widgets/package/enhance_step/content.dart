import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test(this.child, this.onHeightChanged, {super.key});
  final Widget child;
  final Function(double height) onHeightChanged;
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final GlobalKey _key = GlobalKey();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? renderBox =
          _key.currentContext?.findRenderObject() as RenderBox?;
      widget.onHeightChanged(renderBox?.size.height ?? 50);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: widget.child,
    );
  }
}
