import 'package:flutter/material.dart';
import '../Constants/notifiers.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        // return NavigationBar(
        //   backgroundColor: Colors.grey,
        //   destinations: [
        //     NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        //     NavigationDestination(
        //         icon: Icon(Icons.bookmark_added), label: 'Saved'),
        //     NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        //   ],
        //   onDestinationSelected: (int value) {
        //     selectedPageNotifier.value = value;
        //   },
        //   selectedIndex: selectedPage,
        // );
        return BottomAppBar(
          color: Colors.grey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () => selectedPageNotifier.value = 0),
              IconButton(
                  icon: Icon(Icons.bookmark_added),
                  onPressed: () => selectedPageNotifier.value = 1),
              IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () => selectedPageNotifier.value = 2),
              SizedBox(width: 24), // Space at the end
            ],
          ),
        );
      },
    );
  }
}
