import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  CustomAppBar({required this.title, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Color.fromRGBO(244, 238, 255, 1)),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      centerTitle: true, // Pastikan judul berada di tengah
      title: Text(
        title,
        style: TextStyle(color: Color.fromRGBO(244, 238, 255, 1)),
      ),
      backgroundColor: Color.fromRGBO(66, 72, 116, 1), // Warna AppBar
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class CustomButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  CustomButton(
      {required this.text, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(66, 72, 116, 1), // Warna tombol
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Radius sudut
        ),
        padding: EdgeInsets.symmetric(vertical: 20),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(icon, size: 15, color: Colors.white),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Text(text, style: TextStyle(fontSize: 14, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
