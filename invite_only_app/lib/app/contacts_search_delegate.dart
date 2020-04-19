import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsSearchDelegate extends SearchDelegate<List<Contact>> {
  List<Contact> contacts;
  StreamController<List<Contact>> contactsSC;

  ContactsSearchDelegate({List<Contact> selectedContacts})
      : contacts = selectedContacts != null ? selectedContacts : List() {
    contactsSC = StreamController.broadcast();
    contactsSC.add(contacts);
  }

  @override
  void close(BuildContext context, List<Contact> result) {
    contactsSC.close();
    super.close(context, result);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<Iterable<Contact>>(
      future: ContactsService.getContacts(
        query: query.isNotEmpty ? query : null,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        }

        var displayedContacts = snapshot.data;
        return StreamBuilder<List<Contact>>(
          stream: contactsSC.stream,
          builder: (context, snapshot) {
            return Scaffold(
              body: ListView.separated(
                itemCount: displayedContacts.length,
                separatorBuilder: (context, index) => Container(),
                itemBuilder: (context, index) {
                  var contact = displayedContacts.elementAt(index);
                  if (contact.phones.isEmpty) {
                    return Container();
                  }

                  return CheckboxListTile(
                    title: Text(contact.displayName),
                    subtitle: Text(contact.phones.first.value),
                    value: contacts.where((c) {
                      return c.identifier == contact.identifier;
                    }).isNotEmpty,
                    onChanged: (selected) {
                      if (selected) {
                        contacts.add(contact);
                      } else {
                        contacts.remove(contact);
                      }
                      contactsSC.add(contacts);
                    },
                  );
                },
              ),
              persistentFooterButtons: <Widget>[
                FlatButton(
                  onPressed: () {
                    close(context, contacts);
                  },
                  child: Text('Save'),
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }

  @override
  String get searchFieldLabel => 'Search Contacts';

  static Future<List<Contact>> selectContacts(BuildContext context,
      [List<Contact> selectedContacts]) async {
    // First ensure that contacts permission is granted
    var permissionStatus = await Permission.contacts.status;
    if (!permissionStatus.isGranted) {
      permissionStatus = await Permission.contacts.request();
      if (!permissionStatus.isGranted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Permission Denied'),
              content: Text(
                  'Access to your contacts has been denied. You will need to grant the permission from the App\'s settings.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Open Settings'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    openAppSettings();
                  },
                ),
              ],
            );
          },
        );

        return null;
      }
    }

    // Select and return contacts through a search using ContactsSearchDelegate
    return await showSearch<List<Contact>>(
      context: context,
      delegate: ContactsSearchDelegate(selectedContacts: selectedContacts),
    );
  }
}