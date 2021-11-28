import 'package:agenda_contatos/helpers/contato_helper.dart';
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
    c.name = "Leonardo Moreira";
    c.email = "lmoreira597@gmail.com";
    c.phone = "11933679440";
    c.img = "imgteste";

    helper.saveContact(c);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
