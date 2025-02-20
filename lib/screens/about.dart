import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.contact_page, size: 80, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            const Text(
              "Contact Management App",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text("Version 1.0.0", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text(
              "Developer Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text("Name: Ronelle Cudjoe"),
            const Text("Student ID: 50942026"),
            const SizedBox(height: 20),
            const Text(
              "About the App",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              "This a contact management app that allows users to manage"
              "their contacts efficiently. It has features such as creating,"
              "reading, updating and deleting contact information details."
              "It uses an API to read from and store the data."
            ),
            const SizedBox(height: 20),
            

          ],
        ),
      ),
    );
  }
}
