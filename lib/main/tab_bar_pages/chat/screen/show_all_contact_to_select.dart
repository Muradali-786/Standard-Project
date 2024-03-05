import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class ShowAllContact extends StatefulWidget {
  const ShowAllContact({Key? key}) : super(key: key);

  @override
  State<ShowAllContact> createState() => _ShowAllContactState();
}

class _ShowAllContactState extends State<ShowAllContact> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();

    fetchContacts();
  }

  fetchContacts() async {
    bool isShown =
    await Permission
        .contacts
        .request()
        .isGranted;

    if(isShown) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: contacts.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: contacts.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    return contacts[i].phones.isEmpty
                        ? Container()
                        : SizedBox(
                            height: 60,
                            child: ListTile(
                              onTap: () {
                                Navigator.pop(context, [
                                  contacts[i].displayName,
                                  contacts[i].phones[0].number.toString()
                                ]);
                              },
                              leading: const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              title: Text(
                                contacts[i].displayName,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis),
                              ),
                              subtitle:
                                  Text(contacts[i].phones[0].number.toString()),
                            ),
                          );
                  }),
        ),
      ),
    );
  }
}
