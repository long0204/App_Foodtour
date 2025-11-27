import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoveHeader extends StatefulWidget {
  final double height;

  const LoveHeader({super.key, required this.height});

  @override
  State<LoveHeader> createState() => _LoveHeaderState();
}

class _LoveHeaderState extends State<LoveHeader> {
  DateTime? _startDate;

  @override
  void initState() {
    super.initState();
    _loadStartDate();
  }

  Future<void> _loadStartDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = prefs.getString('start_date');
    if (dateStr != null) {
      setState(() {
        _startDate = DateTime.parse(dateStr);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('start_date', picked.toIso8601String());

      // Giả sử username đã được lưu sau login
      final username = prefs.getString('username');
      if (username != null) {
        await FirebaseFirestore.instance.collection('users').doc(username).update({
          'start_date': picked.toIso8601String(),
        });
      }

      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<String?> getAvatarPath(bool isLeft) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(isLeft ? 'avatar_left' : 'avatar_right');
  }

  int calculateDaysFromDate(DateTime targetDate) {
    final now = DateTime.now();
    return now.difference(targetDate).inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      color: Colors.transparent,
      child: Stack(
        children: [
          FutureBuilder<String?>(
            future: getAvatarPath(true),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData && snapshot.data != null) {
                return Positioned(
                  left: 0,
                  top: 50,
                  child: Image.file(
                    File(snapshot.data!),
                    width: 100,
                    height: 100,
                  ),
                );
              } else {
                return Positioned(
                  left: 0,
                  top: 50,
                  child: Image.asset(
                    'asset/avtllac.gif',
                    width: 100,
                    height: 100,
                  ),
                );
              }
            },
          ),
          Center(
            child: GestureDetector(
              onTap: () => _selectDate(context),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'asset/heart2.json',
                    width: 150,
                    height: 150,
                    repeat: true,
                    reverse: true,
                    animate: true,
                  ),
                  const Gap( 10),
                  if (_startDate != null)
                    Text(
                      '${calculateDaysFromDate(_startDate!)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 8,
                            color: Colors.black54,
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                    )
                  else
                    const Text(
                      'Chưa chọn ngày',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                ],
              ),
            ),
          ),
          FutureBuilder<String?>(
            future: getAvatarPath(false),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData && snapshot.data != null) {
                return Positioned(
                  right: 0,
                  top: 50,
                  child: Image.file(
                    File(snapshot.data!),
                    width: 100,
                    height: 100,
                  ),
                );
              } else {
                return Positioned(
                  right: 0,
                  top: 50,
                  child: Image.asset(
                    'asset/avthla.gif',
                    width: 100,
                    height: 100,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
