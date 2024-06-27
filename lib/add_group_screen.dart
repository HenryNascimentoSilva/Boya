import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'group_model.dart';

class AddGroupScreen extends StatefulWidget {
  const AddGroupScreen({super.key});

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
      backgroundColor: Colors.grey[300],
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
                        color: Colors.grey,
                        child: Icon(Icons.camera_alt, size: 100, color: Colors.grey[700]),
                      )
                    : Image.file(File(_image!.path), height: 200, fit: BoxFit.cover),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) => value!.isEmpty ? 'Por favor, insira um título' : null,
                onSaved: (value) => _title = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descrição'),
                onSaved: (value) => _description = value,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(_date == null ? 'Escolha uma data' : DateFormat.yMMMd().format(_date!)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _selectContacts,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  textStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  )
                ),
                child: const Text('Adicionar Membros'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w700
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  )
                ),
                child: const Text('Salvar Grupo'),
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

  const _ContactsDialog({required this.contacts});

  @override
  __ContactsDialogState createState() => __ContactsDialogState();
}

class __ContactsDialogState extends State<_ContactsDialog> {
  final List<Contact> _selectedContacts = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Selecione Membros'),
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
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop(_selectedContacts);
          },
        ),
      ],
    );
  }
}
