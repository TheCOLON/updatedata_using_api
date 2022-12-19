import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:semi_final_exam/home.dart';
import 'dart:convert';

class updatePage extends StatefulWidget {
  final Map todo;

  const updatePage({super.key, required this.todo});

  @override
  State<updatePage> createState() => _updatePageState();
}

class _updatePageState extends State<updatePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['body'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit TODO')),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                label: Text('Title'),
              ),
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 50,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                label: Text('Body'),
              ),
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 50,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  editNotes();
                  final route = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                },
                child: const Text('Save Todo'))
          ],
        ),
      ),
    );
  }

  Future<void> editNotes() async {
    final todo = widget.todo;
    if (todo == null) {
      return;
    }

    final id = todo['_id'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      'title ': title,
      'body': description,
    };

    final url = 'https://jsonplaceholder.typicode.com/posts/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {"content-type": "application/json"});
  }
}
