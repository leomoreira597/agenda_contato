import 'dart:io';
import 'package:agenda_contatos/helpers/contato_helper.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact? contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFocus = FocusNode();

  bool _userEddited = false;
  late Contact _editContact;

  @override
  void initState() {
    super.initState();
    // Quando a variavel que você quer usar está em classes diferentes usar o widget.e classe que você quer acessar
    if (widget.contact == null) {
      _editContact = Contact();
    }
    else {
      _editContact = Contact.fromMap(widget.contact!.toMap());
      _nameController.text = _editContact.name;
      _emailController.text = _editContact.email;
      _phoneController.text = _editContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: _requestPop,
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_editContact.name),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_editContact.name.isNotEmpty) {
            Navigator.pop(context, _editContact);
          }
          else {
            FocusScope.of(context).requestFocus(_nameFocus);
          }
        },
        child: Icon(Icons.save),
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
                      image: _editContact.img != null
                          ? FileImage(File(_editContact.img!))
                          :  const AssetImage(
                          "assets/person.png") as ImageProvider
                  ),
                ),
              ),
            ),
            TextField(
              controller: _nameController,
              focusNode: _nameFocus,
              decoration: InputDecoration(
                labelText: "Nome",
              ),
              onChanged: (text) {
                _userEddited = true;
                setState(() {
                  _editContact.name = text;
                });
              },
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "E-mail",
              ),
              onChanged: (text) {
                _userEddited = true;
                _editContact.email = text;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Telefone",
                ),
                onChanged: (text) {
                  _userEddited = true;
                  _editContact.phone = text;
                },
                keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    ),
    );
  }

  Future <bool> _requestPop(){
    if(_userEddited){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas"),
              actions: [
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Sim'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
      );
      return Future.value(false);
    }
    else{
      return Future.value(true);
    }
  }

}

