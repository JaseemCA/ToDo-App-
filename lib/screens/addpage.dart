
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/Bloc/bloc.dart';
import 'package:todo/Bloc/events.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            TextField(
              decoration: const InputDecoration(hintText: 'Title'),
              controller: titlecontroller,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(hintText: 'Description'),
              controller: descriptioncontroller,
              minLines: 5,
              maxLines: 10,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final title = titlecontroller.text;
                final description = descriptioncontroller.text;
                if (title.isNotEmpty && description.isNotEmpty) {
                  // print('Submitting: $title, $description');
                  context.read<TodoBloc>().add(AddTodo(
                    title: title,
                    description: description,
                  ));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
