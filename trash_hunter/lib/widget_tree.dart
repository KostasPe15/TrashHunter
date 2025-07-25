import 'package:flutter/material.dart';
import 'package:trash_hunter/Pages/address_page.dart';
import 'package:trash_hunter/Pages/feed_page.dart';
import 'package:trash_hunter/Pages/profile_page.dart';
import 'package:trash_hunter/Pages/saved_page.dart';
import 'Widgets/navbar_widget.dart';
import 'Constants/notifiers.dart';

List<Widget> pages = [
  FeedPage(),
  SavedPage(),
  ProfilePage(),
];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages.elementAt(selectedPage);
        },
      ),
      bottomNavigationBar: NavbarWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddressPage();
              },
            ),
          );
        },
        backgroundColor: Colors.deepOrange,
        child: Icon(
          Icons.add_circle,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
