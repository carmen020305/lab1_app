import 'package:flutter/material.dart';

class Todo {
  String id;
  String title;
  bool done;

  Todo({required this.id, required this.title, this.done = false});
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class TodoTile extends StatelessWidget {
  final Todo todo;
  final ValueChanged<bool?> onChanged;

  const TodoTile({super.key, required this.todo, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        title: Text(todo.title),
        value: todo.done,
        onChanged: onChanged,
      ),
    );
  }
}

class _TodoScreenState extends State<TodoScreen> {
  final _items = <Todo>[];
  final _input = TextEditingController();
  String? _filter;

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = _items
        .where((t) => t.title.contains(_filter ?? ''))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Todos (${_countDone()} done)')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(controller: _input),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: visible.length,
              itemBuilder: (context, index) {
                final todo = visible[index];
                return Dismissible(
                  key: ValueKey(todo.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    final position = _items.indexWhere((t) => t.id == todo.id);
                    setState(() {
                      _items.removeAt(position);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Todo "${todo.title}" deleted'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            setState(() {
                              _items.insert(position, todo);
                            });
                          },
                        ),
                      ),
                    );
                  },
                  background: Container(color: Colors.red),
                  child: TodoTile(
                    todo: todo,
                    onChanged: (value) {
                      setState(() {
                        todo.done = value ?? false;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTodo() {
    if (_input.text.trim().isEmpty) {
      return;
    }
    setState(() {
      _items.add(Todo(id: DateTime.now().toString(), title: _input.text));
      _input.clear();
    });
  }

  int _countDone() {
    var done = 0;
    for (var i = 0; i < _items.length; i++) {
      done += _items[i].done ? 1 : 0;
    }
    return done;
  }
}
