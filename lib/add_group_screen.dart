import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'group_model.dart';

class AddGroupScreen extends StatefulWidget {
  @override
  _AddGroupScreenState createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
  XFile? _image;
  DateTime? _date;
  List<Contact> _selectedContacts = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  Future<void> _selectContacts() async {
    if (await Permission.contacts.request().isGranted) {
      final Iterable<Contact> contacts = await ContactsService.getContacts();
      final List<Contact> selectedContacts = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return _ContactsDialog(contacts: contacts);
        },
      );
      setState(() {
        _selectedContacts = selectedContacts;
      });
    }
  }

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _date = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newGroup = Group(
        title: _title!,
        description: _description!,
        createdBy: 'Nome do Criador',  // Substitua isso com o nome do usuário autenticado
        imagePath: _image!.path,
        date: _date!,
      );
      Navigator.pop(context, newGroup);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Grupo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: _image == null
                    ? Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: Icon(Icons.camera_alt, size: 100, color: Colors.grey[700]),
                      )
                    : Image.file(File(_image!.path), height: 200, fit: BoxFit.cover),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) => value!.isEmpty ? 'Por favor, insira um título' : null,
                onSaved: (value) => _title = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descrição'),
                onSaved: (value) => _description = value,
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text(_date == null ? 'Escolha uma data' : DateFormat.yMMMd().format(_date!)),
                trailing: Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _selectContacts,
                child: Text('Adicionar Membros'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Salvar Grupo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactsDialog extends StatefulWidget {
  final Iterable<Contact> contacts;

  _ContactsDialog({required this.contacts});

  @override
  __ContactsDialogState createState() => __ContactsDialogState();
}

class __ContactsDialogState extends State<_ContactsDialog> {
  final List<Contact> _selectedContacts = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Selecione Membros'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.contacts.map((contact) {
            return CheckboxListTile(
              title: Text(contact.displayName ?? ''),
              value: _selectedContacts.contains(contact),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedContacts.add(contact);
                  } else {
                    _selectedContacts.remove(contact);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop(_selectedContacts);
          },
        ),
      ],
    );
  }
}
