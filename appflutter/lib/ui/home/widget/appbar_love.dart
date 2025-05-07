import 'package:Foodtour/ui/favorite_address/favorite_address.dart';
import 'package:flutter/material.dart';

import '../../../widgets/base/base.dart';

class LoveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LoveAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.red.shade300,
      actions: [
        Container(
          height: 60,
          width: 60,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ZoomTap(
            child: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritePlacesScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
