import 'package:flutter/material.dart';

class GriotBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const GriotBottomNavigationBar(
      {super.key, required this.currentIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onItemTapped,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
              backgroundColor: Color.fromRGBO(81, 172, 135, 1),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_outlined),
              label: '',
              backgroundColor: Color.fromRGBO(81, 172, 135, 1),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: '',
              backgroundColor: Color.fromRGBO(81, 172, 135, 1),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: '',
              backgroundColor: Color.fromRGBO(81, 172, 135, 1),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
              backgroundColor: Color.fromRGBO(81, 172, 135, 1),
            ),
          ],
        ),
        Positioned(
          top: -10,
          left: MediaQuery.of(context).size.width / 2 - 30,
          child: FloatingActionButton(
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () async {
                Navigator.pushNamed(
                  context,
                  '/memories_details_page',
                  arguments: null,
                );
              }),
        )
      ],
    );
  }
}
