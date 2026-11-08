import 'package:cs_elective_2/pages/cart_screen.dart';
import 'package:flutter/material.dart';

class CartIcon extends StatelessWidget {
  const CartIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return CartScreen();
                },
              ),
            );
          },
          icon: const Icon(Icons.shopping_bag),
        ),

        Positioned(
          top: 5,
          left: 5,
          child: Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
