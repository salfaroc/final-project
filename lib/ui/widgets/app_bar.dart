import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<MenuItem> menuItems;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF2E1A47),
      elevation: 0,
      titleSpacing: 24,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        for (var item in menuItems) _buildMenuItem(context, item),
        const SizedBox(width: 24),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, MenuItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, item.routeName);
        },
        child: Center(
          child: Text(
            item.title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class MenuItem {
  final String title;
  final String routeName;

  MenuItem({required this.title, required this.routeName});
}
