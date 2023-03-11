import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

// iOS only: Localized labels language setting is equal to CFBundleDevelopmentRegion value (Info.plist) of the iOS project
// Set iOSLocalizedLabels=false if you always want english labels whatever is the CFBundleDevelopmentRegion value.
const iOSLocalizedLabels = false;

class ContactPickerPage extends StatefulWidget {
  const ContactPickerPage({Key? key}) : super(key: key);

  @override
  ContactPickerPageState createState() => ContactPickerPageState();
}

class ContactPickerPageState extends State<ContactPickerPage> {
  Contact? _contact;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickContact() async {
    try {
      final Contact? contact = await ContactsService.openDeviceContactPicker(
          iOSLocalizedLabels: iOSLocalizedLabels);
      setState(() {
        _contact = contact;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts Picker Example')),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: _pickContact,
            child: const Text('Pick a contact'),
          ),
          if (_contact != null)
            Text('Contact selected: ${_contact?.displayName}'),
        ],
      )),
    );
  }
}
