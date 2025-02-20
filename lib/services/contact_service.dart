import 'dart:convert';
import 'package:http/http.dart' as http;

class ContactService {
  static const String baseUrl = "https://apps.ashesi.edu.gh/contactmgt/actions/";

  /// Fetch a single contact by ID
  static Future<Map<String, dynamic>?> getSingleContact(int contid) async {
    final url = Uri.parse("${baseUrl}get_a_contact_mob?contid=$contid");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null; // Return null if API fails
      }
    } catch (e) {
      print("Error fetching single contact: $e");
      return null;
    }
  }

  /// Fetch all contacts
  static Future<List<dynamic>?> getAllContacts() async {
    final url = Uri.parse("${baseUrl}get_all_contact_mob");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching all contacts: $e");
      return null;
    }
  }

  /// Add a new contact
  static Future<String> addNewContact(String fullname, String phone) async {
    final url = Uri.parse("${baseUrl}add_contact_mob");
    final response = await http.post(
      url,
      body: {
        'ufullname': fullname,
        'uphonename': phone,
      },
    );

    return response.body; // Expected: "success" or "failed"
  }

  /// Edit a contact
  static Future<String> editContact(int cid, String newName, String newPhone) async {
    final url = Uri.parse("${baseUrl}update_contact");
    final response = await http.post(
      url,
      body: {
        'cid': cid.toString(),
        'cname': newName,
        'cnum': newPhone,
      },
    );

    return response.body; // Expected: "success" or "failed"
  }

  /// Delete a contact
  static Future<bool> deleteContact(int cid) async {
    final url = Uri.parse("${baseUrl}delete_contact");
    final response = await http.post(
      url,
      body: {
        'cid': cid.toString(),
      },
    );

    if (response.statusCode == 200) {
      return true; // Successful deletion
    } else {
      return false;
    }
  }
}
