import 'library_item.dart';
import 'user.dart';

class Library {
  final List<LibraryItem> items = [];

  bool addItem(LibraryItem item) {
    if(item.title.trim().isEmpty) {
      return false;
    }
    if(items.contains(item)) {
      return false;
    }
    items.add(item);
    return true;
  }

  List<LibraryItem> searchByTitle(String? query) {
    if (query == null || query.trim().isEmpty) {
      return [];
    }
    return items.where((item) =>
        item.title.toLowerCase().contains(query.toLowerCase())).toList();
  }

  List<LibraryItem> getItemsByAuthor(String? author) {
    if (author == null || author.trim().isEmpty) {
      return [];
    }
    return items.where((item) =>
        item.author?.toLowerCase().contains(author.toLowerCase())==true).toList();
  }

  List<LibraryItem> getRecentItems() {
    final DateTime now = DateTime.now();
    return items.where((item) =>
        item.publishDate != null &&
        item.publishDate?.isAfter(now.subtract(const Duration(days: 30)))==true).toList();
    
  }

  bool borrowItem(LibraryItem item, User user, DateTime dueDate) {
    if (item.borrower != null) {
      return false; 
    }
    if (item.borrower != null) {
      return false;
    }
    item.borrower = user;
    item.dueDate = dueDate;
    return true;
  }

  bool returnItem(LibraryItem item) {
    if (item.borrower == null) {
      return false; 
    }
    item.borrower = null;
    item.dueDate = null;
    return true;
  }
}

