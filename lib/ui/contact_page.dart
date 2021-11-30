import 'package:agenda_contatos/helpers/contato_helper.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact contact ;

 ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late Contact _editContact;

  @override
  void initState() {
    super.initState();
    // Quando a variavel que você quer usar está em classes diferentes usar o widget.e classe que você quer acessar
    if(widget.contact == null){
        _editContact = Contact();
    }
    else{
      _editContact = Contact.fromMap(widget.contact.toMap());
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_editContact.name ?? "Novo Contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
    );
  }

}

