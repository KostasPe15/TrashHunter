import 'package:flutter/material.dart';
import '../Constants/notifiers.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return BottomAppBar(
          color: Colors.grey[100],
          shape: const CircularNotchedRectangle(),
          notchMargin: 6,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home,
                  index: 0,
                  selectedIndex: selectedPage,
                ),
                _buildNavItem(
                  icon: Icons.bookmark_added,
                  index: 1,
                  selectedIndex: selectedPage,
                ),
                _buildNavItem(
                  icon: Icons.person,
                  index: 2,
                  selectedIndex: selectedPage,
                ),
                const SizedBox(width: 24), // space for FAB
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required int selectedIndex,
  }) {
    final bool isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () => selectedPageNotifier.value = index,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.deepPurple : Colors.grey[600],
        ),
      ),
    );
  }
}
