import 'package:flutter/material.dart';

import 'models/user.dart';
import 'models/bank_account.dart';
import 'models/library_item.dart';
import 'models/book.dart';
import 'models/magazine.dart';
import 'models/library.dart';
import 'screens/todo_screen.dart';
import 'models/todo.dart';

void main() {
  const a = Todo(userId: 1, id: 1, title: 'test', completed: false);
  const b = Todo(userId: 1, id: 1, title: 'test', completed: false);
  debugPrint('${a == b}');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const TodoScreen(),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<User> users = [
    User(name: 'Ana', age: 21, email: 'ana@example.com'),
    User(name: 'Alexandru', age: null, email: 'alexandru@example.com'),
    User(name: 'Matei', age: null, email: null),
  ];
  final List<BankAccount> accounts = [
    BankAccount(
      holderName: 'Ana',
      bankBranch: 'Bucuresti Nord',
      balance: 1500.0,
    )..initializeAccount('RO01INGB000012345678'),
    BankAccount(holderName: 'Alexandru', balance: 250.0)
      ..initializeAccount('RO02BTRL000087654321'),
    BankAccount(holderName: 'Matei'),
  ];
  final Library library = Library();
  late final List<LibraryItem> searchResultsNullQuery;

  @override
  void initState() {
    super.initState();

    final book1 = Book(
      title: 'Clean Code',
      author: 'Robert C. Martin',
      publishDate: DateTime(2008, 8, 1),
      pageCount: 464,
      isbn: '978-0132350884',
    );

    final magazine1 = Magazine(
      title: 'National Geographic',
      publishDate: DateTime(2023, 5, 1),
      issueNumber: 312,
      publisher: 'National Geographic Partners',
    );

    library.addItem(book1);
    library.addItem(magazine1);

    library.borrowItem(
      book1,
      users[0],
      DateTime.now().add(const Duration(days: 14)),
    );

    searchResultsNullQuery = library.searchByTitle(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Task I: Users',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...users.map(
            (user) => ListTile(
              title: Text(user.name),
              subtitle: Text(
                'Age: ${user.getDisplayAge()} | Email: ${user.email ?? "Not provided"}',
              ),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Task II: Bank Accounts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...accounts.map(
            (acc) => ListTile(
              title: Text('${acc.holderName} (Balance: ${acc.balance})'),
              subtitle: Text(
                'Account: ${acc.getDisplayAccountNumber()} | Branch: ${acc.bankBranch ?? "N/A"}',
              ),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Task III: Library Items & Borrowing',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...library.items.map((item) {
            final extraInfo = item is Book
                ? 'ISBN: ${item.isbn ?? "N/A"}'
                : item is Magazine
                ? 'Issue: ${item.issueNumber ?? "N/A"}'
                : 'N/A';
            final borrowStatus = item.borrower != null
                ? 'Borrowed by ${item.borrower?.name}'
                : 'Available';

            return ListTile(
              leading: Icon(item is Book ? Icons.book : Icons.newspaper),
              title: Text('${item.title} (${item.author ?? "Unknown author"})'),
              subtitle: Text('$extraInfo | Status: $borrowStatus'),
            );
          }),
          ListTile(
            leading: const Icon(Icons.search_off),
            title: const Text('Search with null query test:'),
            subtitle: Text(
              'Results count: ${searchResultsNullQuery.length} items (expected 0)',
            ),
          ),
        ],
      ),
    );
  }
}
