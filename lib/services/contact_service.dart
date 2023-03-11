import 'package:contacts_service/contacts_service.dart';

class ContactService {
  static Future<List<Contact>> getContacts() async {
// Get all contacts without thumbnail (faster)
    List<Contact> contacts =
        await ContactsService.getContacts(withThumbnails: false);
    return contacts;
  }

  static Future<List<Contact>> searchContacts(String search) async {
    // Get contacts matching a string
    return await ContactsService.getContacts(query: search);
  }
}
