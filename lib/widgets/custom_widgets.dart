import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const CustomAppBar({super.key, required this.title, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Color.fromRGBO(244, 238, 255, 1)),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      centerTitle: true, // Pastikan judul berada di tengah
      title: Text(
        title,
        style: const TextStyle(color: Color.fromRGBO(244, 238, 255, 1)),
      ),
      backgroundColor: const Color.fromRGBO(66, 72, 116, 1), // Warna AppBar
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const CustomButton(
      {super.key, required this.text, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(66, 72, 116, 1), // Warna tombol
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Radius sudut
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(icon, size: 15, color: Colors.white),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Text(text, style: const TextStyle(fontSize: 14, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
