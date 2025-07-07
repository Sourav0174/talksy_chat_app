import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  const UserTile({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(6, 6),
              blurRadius: 12,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.7),
              offset: const Offset(-6, -6),
              blurRadius: 12,
            ),
          ],
        ),

        child: Row(
          children: [
            Image.network(
              "https://t4.ftcdn.net/jpg/04/37/73/37/240_F_437733759_BpWiU7WJXo462LNC8QxFvuZ6VFPCcHod.jpg",
            ),
            SizedBox(width: 20),
            Text(text),
          ],
        ),
      ),
    );
  }
}
