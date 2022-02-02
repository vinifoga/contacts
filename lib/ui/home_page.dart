import 'package:contacts/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();


  @override
  void initState() {
    super.initState();
    Contact c = Contact();
    c.name = "Loki Laufeyson";
    c.email = "loki@gmail.com";
    c.phone = "1147859654";
    c.img = "imgTest";

    helper.saveContact(c);

    helper.getAllContact().then((list) {
      print(list);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
