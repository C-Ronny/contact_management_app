import 'package:flutter/material.dart';
import 'package:contact_management_app/services/contact_service.dart';
import 'edit_contact.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({super.key});

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  List<dynamic>? contacts;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  /// Fetch contacts from API
  Future<void> fetchContacts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      List<dynamic>? response = await ContactService.getAllContacts();
      if (response != null) {
        setState(() {
          contacts = response;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Failed to load contacts.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred. Please try again.";
        isLoading = false;
      });
    }
  }

  /// Delete a contact and refresh the list
  Future<void> deleteContact(int contactId) async {
    bool success = await ContactService.deleteContact(contactId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Contact deleted successfully")),
      );
      fetchContacts(); // Refresh list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete contact")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contacts")),
      body: RefreshIndicator(
        onRefresh: fetchContacts,
        child: isLoading
            ? const Center(child: CircularProgressIndicator()) // Loading state
            : errorMessage != null
                ? Center(child: Text(errorMessage!)) // Error state
                : ListView.builder(
                    itemCount: contacts?.length ?? 0,
                    itemBuilder: (context, index) {
                      var contact = contacts![index];
                      return ListTile(
                        leading: CircleAvatar(child: Text(contact['pname'][0])),
                        title: Text(contact['pname']),
                        subtitle: Text(contact['pphone']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditContact(contactId: contact['pid']),
                                  ),
                                );
                                fetchContacts(); // Refresh after edit
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteContact(contact['pid']),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchContacts, // Refresh list on button tap
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
