import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/Bloc/bloc.dart';
import 'package:todo/Bloc/events.dart';

class EditTodoPage extends StatefulWidget {
  final String id;
  final String title;
  final String description;

  const EditTodoPage({Key? key, required this.id, required this.title, required this.description}) : super(key: key);

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    descriptionController = TextEditingController(text: widget.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            TextField(
              decoration: const InputDecoration(hintText: 'Title'),
              controller: titleController,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(hintText: 'Description'),
              controller: descriptionController,
              minLines: 5,
              maxLines: 10,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text;
                final description = descriptionController.text;
                if (title.isNotEmpty && description.isNotEmpty) {
                  print('Updating: ${widget.id}, $title, $description');
                  context.read<TodoBloc>().add(UpdateTodo(
                    id: widget.id,
                    title: title,
                    description: description,
                  ));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
