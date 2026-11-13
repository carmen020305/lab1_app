import 'package:flutter/material.dart';

import '../api/todo_api.dart';
import '../models/todo.dart';

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
        value: todo.completed,
        onChanged: onChanged,
      ),
    );
  }
}

class _TodoScreenState extends State<TodoScreen> {
  final _items = <Todo>[];
  final _log = <String>[];
  final _input = TextEditingController();
  String? _filter;

  @override
  void initState() {
    super.initState();
    _load('/todos');
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _addLog(String line) {
    if (!mounted) {
      return;
    }
    setState(() {
      _log.add(line);
    });
  }

  Future<void> _load(String path) async {
    setState(() {
      _log.clear();
    });
    try {
      final todos = await withRetry(() => fetchTodos(path: path), _addLog);
      if (!mounted) {
        return;
      }
      setState(() {
        _items.clear();
        _items.addAll(todos);
      });
    } catch (_) {
      _addLog('Load failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = _items
        .where((t) => t.title.contains(_filter ?? ''))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Todos (${_countDone()} done)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _load('/todos'),
          ),
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () => _load('/nope'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(controller: _input),
          ),
          if (_log.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _log.map((line) => Text(line)).toList(),
                ),
              ),
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
                      final position = _items.indexWhere(
                        (t) => t.id == todo.id,
                      );
                      setState(() {
                        _items[position] = todo.copyWith(
                          completed: value ?? false,
                        );
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
      _items.add(
        Todo(
          userId: 1,
          id: DateTime.now().millisecondsSinceEpoch,
          title: _input.text,
          completed: false,
        ),
      );
      _input.clear();
    });
  }

  int _countDone() {
    var done = 0;
    for (var i = 0; i < _items.length; i++) {
      done += _items[i].completed ? 1 : 0;
    }
    return done;
  }
}