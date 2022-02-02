import 'dart:io';

import 'package:contacts/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact? contact;

  const ContactPage({Key? key, this.contact}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  late bool _userEdited = false;
  Contact? _editedContact;

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = widget.contact;
      _nameController.text = _editedContact!.name!;
      _emailController.text = _editedContact!.email!;
      _phoneController.text = _editedContact!.phone!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_editedContact?.name ?? "Novo Contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            GestureDetector(
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: _editedContact?.img != null
                          ? FileImage(File(_editedContact!.img!))
                          : const AssetImage("images/user.png")
                              as ImageProvider),
                ),
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nome",
              ),
              onChanged: (text) {
                _userEdited = true;
                setState(() {
                  _editedContact?.name = text;
                });
              },
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
              onChanged: (text) {
                _userEdited = true;
                _editedContact?.email = text;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: "Phone",
              ),
              onChanged: (text) {
                _userEdited = true;
                _editedContact?.phone = text;
              },
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }
}
