import 'package:contact_manager/screens/add_new_contect/add_new_contect_screen.dart';
import 'package:contact_manager/screens/all_contacts/all_contacts_screen.dart';
import 'package:contact_manager/screens/favourite_contacts/favourite_contacts_screen.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentTab = 0;

  AllContactsScreen allContactsScreen;
  FavouriteContactsScreen favouriteContactsScreen;
  List<Widget> pages;
  Widget currentPage;

  @override
  void initState() {
    allContactsScreen = AllContactsScreen();
    favouriteContactsScreen = FavouriteContactsScreen();

    pages = [allContactsScreen, favouriteContactsScreen];
    currentPage = allContactsScreen;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentTab,
          onTap: (int index) {
            setState(() {
              currentTab = index;
              currentPage = pages[index];
            });
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.contacts), title: Text("All Contects")),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), title: Text("Favourites")),
          ]),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddNewContact(), fullscreenDialog: true));
        },
        icon: Icon(Icons.add),
        label: Text("Add Contact"),
      ),
    );
  }
}
