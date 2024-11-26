import 'package:flutter/material.dart';

class CarAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String userDetailRoute;

  const CarAppBar({
    super.key,
    required this.title,
    required this.userDetailRoute,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      actions: [
        IconButton(
          icon: Icon(Icons.account_circle,
              color: Theme.of(context).colorScheme.onSecondary, size: 40),
          onPressed: () => Navigator.pushNamed(context, userDetailRoute),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
