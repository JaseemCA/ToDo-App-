
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/Bloc/bloc.dart';
import 'package:todo/Bloc/events.dart';
import 'package:todo/Bloc/state.dart';
import 'package:todo/screens/addpage.dart';
import 'package:todo/screens/edittodo.dart'; 

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HOME PAGE"),
        centerTitle: true,
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TodoBloc>().add(FetchTodos());
              },
              child: ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index] as Map<String, dynamic>;
                  final id = item['_id'] as String? ?? '';
                  final title = item['title'] as String? ?? 'No Title';
                  final description = item['description'] as String? ?? 'No Description';

                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(title),
                    subtitle: Text(description),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == 'delete') {
                          context.read<TodoBloc>().add(DeleteTodo(id: id));
                        } else if (value == 'edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTodoPage(
                                id: id,
                                title: title,
                                description: description,
                              ),
                            ),
                          );
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ];
                      },
                    ),
                  );
                },
              ),
            );
          } else if (state is TodoError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final route = MaterialPageRoute(
            builder: (context) => const AddTodoPage(),
          );
          Navigator.push(context, route);
        },
        label: const Text('TO DO'),
      ),
    );
  }
}
