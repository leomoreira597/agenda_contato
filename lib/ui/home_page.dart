import 'dart:io';
import 'package:agenda_contatos/helpers/contato_helper.dart';
import 'package:agenda_contatos/ui/contact_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions {oderaz, oderza}

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
        title: const Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de A-Z"),
                value: OrderOptions.oderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de Z-A"),
                value: OrderOptions.oderza,
              ),
            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
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
            return _contectCard(context, index);
          }),
    );
  }

  Widget _contectCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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
                        : const AssetImage("assets/person.png")
                            as ImageProvider,
                      fit: BoxFit.cover
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contacts[index].name,
                      style: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contacts[index].email,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      contacts[index].phone,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: TextButton(
                          style:TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20.0),
                            primary: Colors.red,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            launch("tel:${contacts[index].phone}");
                          },
                          child: const Text('Ligar'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: TextButton(
                          style:TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20.0),
                            primary: Colors.red,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _showContactPage(contact: contacts[index]);
                          },
                          child: const Text('Editar'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: TextButton(
                          style:TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20.0),
                            primary: Colors.red,
                          ),
                          onPressed: () {
                            helper.deleteContact(contacts[index].id!);
                            setState(() {
                              contacts.removeAt(index);
                              Navigator.pop(context);
                            });
                          },
                          child: const Text('Excluir'),
                        ),
                      ),
                    ],
                  ),
                );
              });
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
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _orderList(OrderOptions result){
    switch (result) {
      case OrderOptions.oderaz:
        contacts.sort((a,b){
         return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.oderza:
        contacts.sort((a,b){
         return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {

    });
  }

}
