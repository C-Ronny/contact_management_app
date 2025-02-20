import 'package:flutter/material.dart';
import 'package:contact_management_app/services/contact_service.dart';

class EditContact extends StatefulWidget {
  final int contactId;

  const EditContact({super.key, required this.contactId});

  @override
  State<EditContact> createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadContactDetails();
  }

  /// Load contact details into text fields
  Future<void> loadContactDetails() async {
    var contact = await ContactService.getSingleContact(widget.contactId);
    if (contact != null) {
      setState(() {
        nameController.text = contact['pname'];
        phoneController.text = contact['pphone'];
        isLoading = false;
      });
    }
  }

  /// Update contact
  Future<void> updateContact() async {
    String response = await ContactService.editContact(
      widget.contactId,
      nameController.text,
      phoneController.text,
    );

    if (response == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Contact updated successfully")),
      );
      Navigator.pop(context); // Go back after update
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update contact")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton()),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Name"),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: "Phone Number"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: updateContact,
                    child: const Text("Update Contact"),
                  ),
                ],
              ),
            ),
    );
  }
}
