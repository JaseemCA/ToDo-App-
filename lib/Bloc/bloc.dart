import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:todo/Bloc/events.dart';
import 'package:todo/Bloc/state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<FetchTodos>(_mapFetchTodosToState);
    on<AddTodo>(_mapAddTodoToState);
    on<DeleteTodo>(_mapDeleteTodoToState);
    on<UpdateTodo>(_mapUpdateTodoToState); 
  }

  Future<void> _mapFetchTodosToState(FetchTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final response = await http.get(Uri.parse('https://api.nstack.in/v1/todos?page=1&limit=10'));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final result = json['items'] as List<dynamic>;
        emit(TodoLoaded(items: result));
      } else {
        emit(const TodoError(message: 'Failed to fetch todos'));
      }
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  Future<void> _mapAddTodoToState(AddTodo event, Emitter<TodoState> emit) async {
    try {
      final body = {
        "title": event.title,
        "description": event.description,
        "is_completed": false
      };
      final response = await http.post(Uri.parse('https://api.nstack.in/v1/todos'),
          body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 201) {
        add(FetchTodos());
      } else {
        emit(const TodoError(message: 'Failed to add todo'));
      }
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  Future<void> _mapDeleteTodoToState(DeleteTodo event, Emitter<TodoState> emit) async {
    try {
      final response = await http.delete(Uri.parse('https://api.nstack.in/v1/todos/${event.id}'));
      if (response.statusCode == 200) {
        add(FetchTodos());
      } else {
        emit(const TodoError(message: 'Failed to delete todo'));
      }
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  Future<void> _mapUpdateTodoToState(UpdateTodo event, Emitter<TodoState> emit) async {
    try {
      final body = {
        "title": event.title,
        "description": event.description
      };
      final response = await http.put(Uri.parse('https://api.nstack.in/v1/todos/${event.id}'),
          body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        add(FetchTodos());
      } else {
        emit(const TodoError(message: 'Failed to update todo'));
      }
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }
}


 