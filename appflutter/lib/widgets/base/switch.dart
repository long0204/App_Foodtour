import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../../config/themes/color.dart';

class MySwitch extends StatefulWidget {
  const MySwitch({
    required this.onToggle,
    super.key,
    this.initValue = false,
  });

  final Function(bool value) onToggle;
  final bool initValue;
  @override
  State<MySwitch> createState() => _MySwitchState();
}

class _MySwitchState extends State<MySwitch> {
  bool vl = true;

  @override
  void initState() {
    vl = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return 1 == 1
        ? CupertinoSwitch(
            applyTheme: true,
            activeColor: greenSwitch,
            value: vl,
            onChanged: (bool value) {
              setState(() {
                widget.onToggle(value);
                vl = value;
              });
            },
          )
        : FlutterSwitch(
            value: vl,
            height: 24,
            width: 48,
            padding: 3.5,
            toggleSize: 18,
            activeColor: Colors.green,
            inactiveColor: Colors.grey[200]!,
            // activeSwitchBorder: Border(),
            onToggle: (val) {
              setState(() {
                widget.onToggle(val);
                vl = val;
              });
            },
          );
  }
}
