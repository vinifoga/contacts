import 'dart:io';

import 'package:contacts/components/icon_button_text.dart';
import 'package:contacts/helpers/contact_helper.dart';
import 'package:contacts/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions { orderAz, orderZa }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) =>
            <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordernar de A-Z"),
                value: OrderOptions.orderAz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordernar de Z-A"),
                value: OrderOptions.orderZa,
              ),
            ],
            onSelected: _orderList,


          ),
        ],
        title: const Text("Contacts"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return _contacCard(context, index);
        },
      ),
    );
  }

  Widget _contacCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contacts[index].img != null
                          ? FileImage(File(contacts[index].img!))
                          : const AssetImage("images/user.png")
                      as ImageProvider),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contacts[index].name ?? "",
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      contacts[index].email ?? "",
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      contacts[index].phone ?? "",
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOption(context, index);
      },
    );
  }

  void _showOption(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButtonText(
                      icon: Icon(Icons.phone),
                      text: "Ligar",
                      function: () {
                        launch("tel:${contacts[index].phone}");
                        Navigator.pop(context);
                      },
                    ),
                    IconButtonText(
                      icon: Icon(Icons.edit), text: "Editar", function: () {
                      Navigator.pop(context);
                      _showContactPage(contact: contacts[index]);
                    },),
                    IconButtonText(
                      icon: Icon(Icons.delete), text: "Excluir", function: () {
                      helper.deleteContact(
                          contacts[index].id ?? contacts[index].id!);
                      setState(() {
                        contacts.removeAt(index);
                        Navigator.pop(context);
                      });
                    },),
                  ],
                ),
              );
            },
            onClosing: () {},
          );
        });
  }

  void _showContactPage({Contact? contact}) async {
    final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactPage(contact: contact)));
    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllContact().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _orderList(OrderOptions result) {
    setState(() {
      switch (result) {
        case OrderOptions.orderAz:
          contacts.sort((a, b) {
            if (a.name == null || b.name == null) {
              return -1;
            } else {
              return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
            }
          });
          break;
        case OrderOptions.orderZa:
          contacts.sort((a, b) {
            if (a.name == null || b.name == null) {
              return -1;
            } else {
              return b.name!.toLowerCase().compareTo(a.name!.toLowerCase());
            }
          });
          break;
      }
    });
  }
}
