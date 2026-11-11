class User { 
  final String name; 
  final int? age; 
  String? email; 
  User({
    required this.name, 
    this.age, 
    this.email
  }); 
  String getDisplayAge() { 
    if (age == null) { 
      return 'Age not specified'; 
    } else { 
      return '$age'; 
    } 
  }
}