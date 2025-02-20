import 'package:contact_management_app/screens/about.dart';
import 'package:contact_management_app/screens/add_contact.dart';
import 'package:contact_management_app/screens/contacts_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 85, 255),
        ),
      ),
      home: const MyHomePage(title: 'Contact Management System'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedTab = 0; // Now a mutable variable

  // Create list to store available screens
  static final List<Widget> _pages = <Widget>[
    const ContactsList(),
    const AddContact(),
    const About(),
  ];

  // function to set state when an item is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedTab = index; // Updates the selected tab instead of navigating
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedTab], // Display the correct page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab, // Highlight selected tab
        onTap: _onItemTapped, // Change tab on tap
        selectedItemColor: const Color.fromARGB(255, 0, 76, 255),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Contact'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
        ],
      ),
    );
  }
}
