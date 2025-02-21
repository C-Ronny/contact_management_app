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
        SnackBar(
          content: const Text("Contact deleted successfully"),
          backgroundColor: Colors.green,
        ),
      );
      fetchContacts(); // Refresh list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Failed to delete contact"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"), 
        centerTitle: true, 
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ), 
      body: RefreshIndicator(
        onRefresh: fetchContacts,
        child: isLoading
            ? const Center(child: CircularProgressIndicator()) // Loading state
            : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 50),
                        const SizedBox(height: 10),
                        Text(errorMessage!, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  )
                : contacts!.isEmpty
                    ? const Center(
                        child: Text(
                          "No contacts available.\nTap + to add one!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: contacts?.length ?? 0,
                        itemBuilder: (context, index) {
                          var contact = contacts![index];
                          return Dismissible(
                            key: Key(contact['pid'].toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              deleteContact(contact['pid']);
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 2,
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blueAccent,
                                  child: Text(
                                    contact['pname'][0].toUpperCase(),
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  contact['pname'],
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                subtitle: Text(
                                  contact['pphone'],
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
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
                              ),
                            ),
                          );
                        },
                      ),
      ),
      
    );
  }
}
